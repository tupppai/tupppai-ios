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
//#import "UITableView+FDTemplateLayoutCell.h"
#import "DeviceUtil.h"
#import "PIENotificationCommentViewController.h"
@interface PIENotificationViewController ()
<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate>

@property (nonatomic, strong) NSMutableArray<PIENotificationVM *> *source;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) PIENotificationVM* selectedVM;
@property (nonatomic, assign) long long timeStamp;

@end

@implementation PIENotificationViewController

static NSString * const NotificationViewControllerDefaultCellIdentifier =
@"defaultCell";

#pragma mark - UI life cycles

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的消息";
    _source = [NSMutableArray<PIENotificationVM *> array];
    _canRefreshFooter = YES;
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnTableView:)];
    [self.tableView addGestureRecognizer:tapGes];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(refreshTableView)
     name:PIEUpdateNotificationStatusNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateNotificationStatus)
     name:PIEUpdateNotificationStatusNotification
     object:nil];

    [self configSlack];
    [self configTableView];
    [self setupRefresh_Footer];
    [self getDataSource];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor =
    [UIColor colorWithHex:0xffffff andAlpha:0.9];
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

    [[NSUserDefaults standardUserDefaults]setObject:@(NO)
                                             forKey:PIEHasNewNotificationFlagKey];
    [[NSUserDefaults standardUserDefaults]synchronize];

    if (![[self.navigationController viewControllers] containsObject: self])
        //any other hierarchy compare
    {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:PIEUpdateNotificationStatusNotification object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:PIEUpdateNotificationStatusNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Notification methods
- (void)updateNotificationStatus {
    [self getDataSource];
}
- (void)refreshTableView {
    [self.tableView reloadData];
}

#pragma mark - Gesture methods

/** 识别不同indexPath的cell内部的不同UI元素的点击事件 */
- (void)tapOnTableView:(UITapGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];

    if (selectedIndexPath == nil) {
        return;
    }
    /*
        消息正文部分
     */
    if (selectedIndexPath.section == 1) {
        PIENotificationVM* vm = [_source objectAtIndex:selectedIndexPath.row];
        if (vm == nil) {
            return;
        }
        PIEPageVM* pageVM = [self transformNotificationVMToPageVM:vm];
        _selectedVM = vm;
        
        
//         if (vm.type == PIENotificationTypeComment) {
//             PIENotificationCommentTableViewCell* cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
//             CGPoint p = [gesture locationInView:cell];
//             if (CGRectContainsPoint(cell.replyLabel.frame,p)) {
// //                self.textInputbarHidden = NO;
// //                self.textView.placeholder = [NSString stringWithFormat:@"@%@:",vm.username];
// //                [self.textView becomeFirstResponder];
//                 PIECommentViewController* vc = [PIECommentViewController new];
//
// //                pageVM.ID = vm.targetID;
// //                pageVM.type = vm.targetType;
//                 vc.vm = pageVM;
// //                vc.shouldDownloadVMSource = YES;
//                 vc.shouldShowHeaderView = YES;
//                 [self.navigationController pushViewController:vc animated:YES];
//
//             }     else       if (CGRectContainsPoint(cell.avatarView.frame,p) || (CGRectContainsPoint(cell.usernameLabel.frame,p))) {
//                 PIEFriendViewController* vc = [PIEFriendViewController new];
//                 vc.pageVM = pageVM;
// //                vc.uid = vm.senderID;
// //                vc.name = vm.username;
//                 [self.navigationController pushViewController:vc animated:YES];
//             } else   {
//                 PIECommentViewController* vc = [PIECommentViewController new];
// //                PIEPageVM* pageVM = [PIEPageVM new];
// //                pageVM.ID = vm.targetID;
// //                pageVM.type = vm.targetType;
//                 vc.vm = pageVM;
// //                vc.shouldDownloadVMSource = YES;
//                 vc.shouldShowHeaderView = YES;
//                 [self.navigationController pushViewController:vc animated:YES];
//             }
//         }
        // else
        
        
        
         if (vm.type == PIENotificationTypeReply) {
            PIENotificationReplyTableViewCell* cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.replyLabel.frame,p)) {
                PIECommentViewController* vc = [PIECommentViewController new];
                vc.vm = pageVM;
                vc.shouldShowHeaderView = YES;
                [self.navigationController pushViewController:vc animated:YES];

            } else if (CGRectContainsPoint(cell.avatarView.frame,p) || (CGRectContainsPoint(cell.usernameLabel.frame,p))) {
                PIEFriendViewController* vc = [PIEFriendViewController new];
                vc.pageVM = pageVM;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                PIECommentViewController* vc = [PIECommentViewController new];
                vc.vm = pageVM;
                vc.shouldShowHeaderView = YES;

                [self.navigationController pushViewController:vc animated:YES];
            }
        }
         else if (vm.type == PIENotificationTypeFollow) {
            PIEFriendViewController* vc = [PIEFriendViewController new];
            vc.pageVM = pageVM;
//                vc.uid = vm.senderID;
//                vc.name = vm.username;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    /*
        消息类型部分：系统消息、收到的赞和收到的评论
     */
    else if (selectedIndexPath.section == 0) {

            NSInteger row = selectedIndexPath.row;
            NSString* badgeKey;
            if (row == 0 ) {
                badgeKey = PIENotificationCountSystemKey;
            } else   if (row == 1 ) {
                badgeKey = PIENotificationCountLikeKey;
            } else if (row == 2){
                badgeKey = PIENotificationCountCommentKey;
            }
        
            /**
                进入某个特定分类的消息之前，把UI上的提示数量的红点去掉，并且归零本地沙盒之中的全局状态量
             */
        
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:badgeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            PIENotificationTypeTableViewCell *cell = (PIENotificationTypeTableViewCell*)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
            cell.badgeNumber = 0;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];

        
            if (selectedIndexPath.row == 0) {
                PIENotificationSystemViewController* vc = [PIENotificationSystemViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (selectedIndexPath.row == 1) {
                PIENotificationLikedViewController* vc = [PIENotificationLikedViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (selectedIndexPath.row == 2){
                PIENotificationCommentViewController *commentVC =
                [[PIENotificationCommentViewController alloc] init];
                [self.navigationController pushViewController:commentVC
                                                     animated:YES];
                
            }
        }
}

#pragma mark - Initial setup
- (void)configTableView {
//    UINib* nib  = [UINib nibWithNibName:@"PIENotificationCommentTableViewCell" bundle:nil];
    UINib* nib3 = [UINib nibWithNibName:@"PIENotificationFollowTableViewCell" bundle:nil];
    UINib* nib4 = [UINib nibWithNibName:@"PIENotificationReplyTableViewCell" bundle:nil];

//    [self.tableView registerNib:nib  forCellReuseIdentifier:@"PIENotificationCommentTableViewCell"];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"PIENotificationFollowTableViewCell"];
    [self.tableView registerNib:nib4 forCellReuseIdentifier:@"PIENotificationReplyTableViewCell"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag|UIScrollViewKeyboardDismissModeInteractive;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 10);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

/**
    用于快速回复
 */
- (void)configSlack {
    self.bounces                                = NO;
    self.shakeToClearEnabled                    = NO;
    self.keyboardPanningEnabled                 = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted                               = NO;
    [self.rightButton setTitle:@"回复ta" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.textInputbar.autoHideRightButton       = YES;
    self.textInputbar.maxCharCount              = 128;
    self.textInputbar.counterStyle              = SLKCounterStyleSplit;
    self.textInputbar.counterPosition           = SLKCounterPositionTop;
    self.shouldClearTextAtRightButtonPress      = YES;
    self.textView.placeholder                   = @"回复ta";
    self.textInputbarHidden                     = YES;
}
/**
    手动设置Refresh_Footer, 执行上拉加载
 */
- (void)setupRefresh_Footer {
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=6; i++) {
        UIImage *image =
        [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
        [animatedImages addObject:image];
    }
    MJRefreshAutoGifFooter *footer =
    [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    [footer setImages:animatedImages
             duration:0.5 forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;

    _canRefreshFooter = YES;
}

#pragma mark - GetDataSource
- (void)getMoreDataSource {
    [self.tableView.mj_header endRefreshing];
    _currentIndex++;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.25) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        if (source.count <15) {
            _canRefreshFooter = NO;
        }
        else {
            _canRefreshFooter = YES;
        }
        [ws.source addObjectsFromArray:source];
        [ws.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [Hud text:@"已经拉到底啦"];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)getDataSource {
    _currentIndex = 1;
    [self.tableView.mj_footer endRefreshing];
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.25) forKey:@"width"];
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
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - <UITableViewDataSource & UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return _source.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
        消息正文部分
     */
    if (indexPath.section == 1) {
        if (_source.count > indexPath.row) {
            PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
            switch (vm.type) {
//                case PIENotificationTypeComment:
//                {
//                    PIENotificationCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationCommentTableViewCell"];
//                    [cell injectSauce:vm];
//                    return cell;
//                    break;
//                }
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

    /*
        消息类型部分
     */
    else {
        PIENotificationTypeTableViewCell* cell =
        [[PIENotificationTypeTableViewCell alloc]
         initWithStyle:UITableViewCellStyleDefault
         reuseIdentifier:@"defaultCell"];
        cell.textLabel.font = [UIFont lightTupaiFontOfSize:14];

        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"notify_system"];
            cell.textLabel.text  = @"系统消息";
            cell.badgeNumber     =
            [[[NSUserDefaults standardUserDefaults]
              objectForKey:PIENotificationCountSystemKey]
             integerValue];

        }else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"pieLike_selected"];
            cell.textLabel.text  = @"收到的赞";
            cell.badgeNumber     =
            [[[NSUserDefaults standardUserDefaults]
              objectForKey:PIENotificationCountLikeKey] integerValue];
        }else if (indexPath.row == 2){
            cell.imageView.image =
            [UIImage imageNamed:@"pie_notification_receivedComments"];
            cell.textLabel.text  = @"收到的评论";
            cell.badgeNumber     =
            [[[NSUserDefaults standardUserDefaults]
             objectForKey:PIENotificationCountCommentKey] integerValue];
        }
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
    view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
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
//            case PIENotificationTypeComment:
//                return UITableViewAutomaticDimension;
//                break;
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
        /* 上面的消息类型部分，高度统一为50 */
        return 50;
    }
    return 0;

}

#pragma mark - overridden super_class methods
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

#pragma mark - private helpers
- (PIEPageVM*)transformNotificationVMToPageVM:(PIENotificationVM*)vm {
    PIEPageModel* model = [PIEPageModel new];
    model.ID            = vm.model.targetID;
    model.type          = vm.model.targetType;
    model.imageURL      = vm.model.imageUrl;
    model.avatar        = vm.model.avatarUrl;
    model.askID         = vm.model.askID;
    model.nickname      = vm.model.username;
    model.uid           = vm.model.senderID;
    model.uploadTime    = vm.model.time;
    PIEPageVM* pageVM   = [[PIEPageVM alloc]initWithPageEntity:model];
    return pageVM;
}



@end
