//
//  PIENotificationViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationViewController.h"
#import "PIERefreshTableView.h"
#import "PIENotificationManager.h"
#import "PIENotificationVM.h"

#import "PIENotificationReplyTableViewCell.h"
#import "PIENotificationFollowTableViewCell.h"
#import "PIENotificationCommentTableViewCell.h"
#import "PIENotificationSystemViewController.h"
#import "PIENotificationLikedViewController.h"
#import "PIENotificationTypeTableViewCell.h"
#import "PIEFriendViewController.h"
#import "PIECommentViewController.h"
#import "PIECommentManager.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface PIENotificationViewController ()<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate>
@property (nonatomic, strong) NSMutableArray *source;
//@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) PIENotificationVM* selectedVM;
@property (nonatomic, assign)  long long timeStamp;

@end

@implementation PIENotificationViewController

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    _source = [NSMutableArray array];
    _canRefreshFooter = YES;
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnTableView:)];
    [self.tableView addGestureRecognizer:tapGes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"updateNoticationStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNoticationStatus)
                                                 name:@"updateNoticationStatus"
                                               object:nil];
    [self configSlack];
    [self configTableView];
    [self setupRefresh_Footer];
    [self getDataSource];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults]setObject:@(NO) forKey:@"NotificationNew"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    if (![[self.navigationController viewControllers] containsObject: self]) //any other hierarchy compare
    {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateNoticationStatus" object:nil];
    }
}

- (void)updateNoticationStatus {
    [self getDataSource];
}
- (void)keyboardWillShow:(id)sender {
    self.textInputbarHidden = NO;
}
- (void)keyboardDidHide:(id)sender {
    self.textInputbarHidden = YES;
}

- (void)tapOnTableView:(UITapGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    if (selectedIndexPath.section == 1) {
        PIENotificationVM* vm = [_source objectAtIndex:selectedIndexPath.row];
        _selectedVM = vm;
        if (vm.type == 1) {
            PIENotificationCommentTableViewCell* cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.replyLabel.frame,p)) {
                self.textInputbarHidden = NO;
                self.textView.placeholder = [NSString stringWithFormat:@"@%@:",vm.username];
                [self.textView becomeFirstResponder];
            }     else       if (CGRectContainsPoint(cell.avatarView.frame,p) || (CGRectContainsPoint(cell.usernameLabel.frame,p))) {
                PIEFriendViewController* vc = [PIEFriendViewController new];
                vc.uid = vm.senderID;
                vc.name = vm.username;
                [self.navigationController pushViewController:vc animated:YES];
            } else   {
                PIECommentViewController* vc = [PIECommentViewController new];
                PIEPageVM* pageVM = [PIEPageVM new];
                pageVM.ID = vm.targetID;
                pageVM.type = vm.targetType;
                vc.vm = pageVM;
                vc.shouldDownloadVMSource = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else    if (vm.type == 2) {
            PIENotificationReplyTableViewCell* cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.replyLabel.frame,p)) {
                self.textInputbarHidden = NO;
                self.textView.placeholder = [NSString stringWithFormat:@"@%@:",vm.username];
                [self.textView becomeFirstResponder];
            } else if (CGRectContainsPoint(cell.avatarView.frame,p) || (CGRectContainsPoint(cell.usernameLabel.frame,p))) {
                PIEFriendViewController* vc = [PIEFriendViewController new];
                vc.uid = vm.senderID;
                vc.name = vm.username;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                PIECommentViewController* vc = [PIECommentViewController new];
                PIEPageVM* pageVM = [PIEPageVM new];
                pageVM.ID = vm.targetID;
                pageVM.type = vm.targetType;
                vc.vm = pageVM;
                vc.shouldDownloadVMSource = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (vm.type == 3) {
                PIEFriendViewController* vc = [PIEFriendViewController new];
                vc.uid = vm.senderID;
                vc.name = vm.username;
                [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (selectedIndexPath.section == 0) {

            NSInteger row = selectedIndexPath.row;
            NSString* badgeKey;
            if (row == 0 ) {
                badgeKey = @"NotificationSystem";
            } else     if (row == 1 ) {
                badgeKey = @"NotificationLike";
            }
            [[NSUserDefaults standardUserDefaults]setObject:@(0) forKey:badgeKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            PIENotificationTypeTableViewCell *cell = (PIENotificationTypeTableViewCell*)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
            cell.badgeNumber = 0;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (selectedIndexPath.row == 0) {
                PIENotificationSystemViewController* vc = [PIENotificationSystemViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (selectedIndexPath.row == 1) {
                PIENotificationLikedViewController* vc = [PIENotificationLikedViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateNoticationStatus" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];

}
- (void)configTableView {
    UINib* nib  = [UINib nibWithNibName:@"PIENotificationCommentTableViewCell" bundle:nil];
    UINib* nib3 = [UINib nibWithNibName:@"PIENotificationFollowTableViewCell" bundle:nil];
    UINib* nib4 = [UINib nibWithNibName:@"PIENotificationReplyTableViewCell" bundle:nil];
    [self.tableView registerNib:nib  forCellReuseIdentifier:@"PIENotificationCommentTableViewCell"];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"PIENotificationFollowTableViewCell"];
    [self.tableView registerNib:nib4 forCellReuseIdentifier:@"PIENotificationReplyTableViewCell"];
//    self.tableView.emptyDataSetSource = self;
//    self.tableView.emptyDataSetDelegate = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag|UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 10);
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
}
- (void)configSlack {
    self.bounces = NO;
    self.shakeToClearEnabled = NO;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = NO;
    [self.rightButton setTitle:@"回复ta" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 128;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    self.shouldClearTextAtRightButtonPress = YES;
    self.textView.placeholder = @"回复ta";
    self.textInputbarHidden = YES;
}
- (void)setupRefresh_Footer {
    [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
        [animatedImages addObject:image];
    }
    self.tableView.gifFooter.refreshingImages = animatedImages;
    self.tableView.footer.stateHidden = YES;
    _canRefreshFooter = YES;
}


-(void)refreshTableView {
    [self.tableView reloadData];
}

#pragma mark - GetDataSource
- (void)getDataSource {
    _currentIndex = 1;
    [self.tableView.footer endRefreshing];
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(100) forKey:@"size"];
    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        if (source.count>0) {
            ws.source = [source mutableCopy];
            [ws.tableView reloadData];
            _canRefreshFooter = YES;
        }
        else {
            _canRefreshFooter = NO;
        }
        [self.tableView.header endRefreshing];
    }];
}


- (void)didPressRightButton:(id)sender
{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    if (_selectedVM) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.textView.text forKey:@"content"];
        [param setObject:@(_selectedVM.targetType) forKey:@"type"];
        [param setObject:@(_selectedVM.targetID) forKey:@"target_id"];
        [param setObject:@(_selectedVM.commentId) forKey:@"for_comment"];
        PIECommentManager *commentManager = [PIECommentManager new];
        [commentManager SendComment:param withBlock:^(NSInteger comment_id, NSError *error) {
            if (comment_id) {
                [Hud success:@"回复成功" inView:self.view];
                [self.textView resignFirstResponder];
            } else if (error) {
                [Hud error:@"回复失败" inView:self.view];
            }
        }];
    }
    [super didPressRightButton:sender];
}

#pragma mark - GetDataSource
- (void)getMoreDataSource {
    [self.tableView.header endRefreshing];
    _currentIndex++;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        if (source.count>0) {
            [ws.source addObjectsFromArray:source];
            [ws.tableView reloadData];
            _canRefreshFooter = YES;
        }
        else {
            _canRefreshFooter = NO;
        }
        [self.tableView.footer endRefreshing];
    }];
}

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [self.tableView.footer endRefreshing];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (_source.count > indexPath.row) {
            PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
            switch (vm.type) {
                case PIENotificationTypeComment:
                {
                    PIENotificationCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationCommentTableViewCell"];
                    [cell injectSauce:vm];
                    return cell;
                    break;
                }
                case PIENotificationTypeFollow:
                {
                    PIENotificationFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationFollowTableViewCell"];
                    [cell injectSauce:vm];
                    return cell;
                    break;
                }
   
                case PIENotificationTypeReply:
                {
                    PIENotificationReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationReplyTableViewCell"];
                    [cell injectSauce:vm];
                    return cell;
                    break;
                }

                default:
                    return nil;
                    break;
            }
        }
    }
    else {

        PIENotificationTypeTableViewCell* cell = [[PIENotificationTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"notify_system"];
            cell.textLabel.text = @"系统消息";
            cell.badgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationSystem"]integerValue];
        }    else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"pieLike_selected"];
            cell.textLabel.text = @"收到的赞";
            cell.badgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationLike"]integerValue];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }else {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,40)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 100,40)];
    label.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    label.font = [UIFont lightTupaiFontOfSize:12];
    switch (section)
    {
        case 1:
            label.text  = @"最近消息";
            break;
        default:
            break;
    }
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
        switch (vm.type) {
            case PIENotificationTypeComment:
                return [tableView fd_heightForCellWithIdentifier:@"PIENotificationCommentTableViewCell"  cacheByIndexPath:indexPath configuration:^(PIENotificationCommentTableViewCell *cell) {
                    [cell injectSauce:vm];
                }];
                break;
            case PIENotificationTypeFollow:
                return 68;
                break;

            case PIENotificationTypeReply:
                return 85;
                break;
            default:
                return 105;
                break;
        }
    }
    else {
        return 50;
    }
    return 0;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return _source.count;
    }
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        if (self.navigationController.topViewController != self) {
//            return;
//        }
//        NSInteger row = indexPath.row;
//        NSString* badgeKey;
//        if (row == 0 ) {
//            badgeKey = @"NotificationSystem";
//        } else     if (row == 1 ) {
//            badgeKey = @"NotificationLike";
//        }
//        [[NSUserDefaults standardUserDefaults]setObject:@(0) forKey:badgeKey];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        PIENotificationTypeTableViewCell *cell = (PIENotificationTypeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//        cell.badgeNumber = 0;
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//            if (indexPath.row == 0) {
//                PIENotificationSystemViewController* vc = [PIENotificationSystemViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//            } else if (indexPath.row == 1) {
//                PIENotificationLikedViewController* vc = [PIENotificationLikedViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//    }
//
//}

@end
