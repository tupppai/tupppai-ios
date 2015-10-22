//
//  PIEFollowViewController.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteViewController.h"
#import "PIEEliteScrollView.h"
#import "HMSegmentedControl.h"
#import "PIEEliteFollowTableViewCell.h"
//#import "PIEEliteHotTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PIEEliteManager.h"
#import "PIECarouselViewController.h"
#import "PIEFriendViewController.h"
#import "DDCommentVC.h"
#import "DDCollectManager.h"
#import "PIEReplyCollectionViewController.h"
#import "JGActionSheet.h"
#import "AppDelegate.h"
#import "ATOMReportModel.h"
#import "DDInviteVC.h"

#import "PIEShareView.h"
#import "PIEEliteAskTableViewCell.h"
#import "PIEEliteReplyTableViewCell.h"
#import "PIEEliteHotReplyTableViewCell.h"

static  NSString* askIndentifier = @"PIEEliteAskTableViewCell";
static  NSString* replyIndentifier = @"PIEEliteReplyTableViewCell";


static  NSString* hotReplyIndentifier = @"PIEEliteHotReplyTableViewCell";
//static  NSString* indentifier2 = @"PIEEliteHotTableViewCell";

@interface PIEEliteViewController ()<UITableViewDelegate,UITableViewDataSource,PWRefreshBaseTableViewDelegate,UIScrollViewDelegate,PIEShareViewDelegate,JGActionSheetDelegate>
@property (nonatomic, strong) PIEEliteScrollView *sv;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *sourceFollow;
@property (nonatomic, strong) NSMutableArray *sourceHot;

@property (nonatomic, assign) NSInteger currentIndex_follow;
@property (nonatomic, assign) NSInteger currentIndex_hot;

@property (nonatomic, assign) BOOL canRefreshFooterFollow;
@property (nonatomic, assign) BOOL canRefreshFooterHot;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureHot;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureFollow;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
//@property (nonatomic, strong) UITableViewCell *selectedFollowCell;
//@property (nonatomic, strong) PIEEliteHotTableViewCell *selectedHotCell;
@property (nonatomic, strong) DDPageVM *selectedVM;

@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;
@property (nonatomic, strong)  PIEShareView * shareView;

@end

@implementation PIEEliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self createNavBar];
    [self configSubviews];
    [self firstGetRemoteSourceHot:nil];
    [self firstGetRemoteSourceFollow:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - init methods

- (void)configData {
    _canRefreshFooterFollow = YES;
    _canRefreshFooterHot = YES;

    _currentIndex_follow = 1;
    _currentIndex_hot = 1;
    
    _sourceFollow = [NSMutableArray new];
    _sourceHot = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_Elite" object:nil];
}
- (void)configSubviews {
    self.view = self.sv;
    [self configTableViewFollow];
    [self configTableViewHot];
}
- (void)configTableViewFollow {
    _sv.tableFollow.dataSource = self;
    _sv.tableFollow.delegate = self;
    _sv.tableFollow.psDelegate = self;
    
    UINib* nib2 = [UINib nibWithNibName:askIndentifier bundle:nil];
    [_sv.tableFollow registerNib:nib2 forCellReuseIdentifier:askIndentifier];
    UINib* nib3 = [UINib nibWithNibName:replyIndentifier bundle:nil];
    [_sv.tableFollow registerNib:nib3 forCellReuseIdentifier:replyIndentifier];
    
    _tapGestureFollow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFollow:)];
    [_sv.tableFollow addGestureRecognizer:_tapGestureFollow];
}
- (void)configTableViewHot {
    
    _sv.tableHot.dataSource = self;
    _sv.tableHot.delegate = self;
    _sv.tableHot.psDelegate = self;
    
    UINib* nib = [UINib nibWithNibName:hotReplyIndentifier bundle:nil];
    [_sv.tableHot registerNib:nib forCellReuseIdentifier:hotReplyIndentifier];
    UINib* nib2 = [UINib nibWithNibName:askIndentifier bundle:nil];
    [_sv.tableHot registerNib:nib2 forCellReuseIdentifier:askIndentifier];

    _tapGestureHot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHot:)];
    [_sv.tableHot addGestureRecognizer:_tapGestureHot];
}
- (void)createNavBar {
    WS(ws);
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"热门",@"关注"]];
    _segmentedControl.frame = CGRectMake(0, 120, 200, 45);
    _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
    _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentedControl.backgroundColor = [UIColor clearColor];

    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            [ws.sv toggleWithType:PIEPageTypeEliteHot];
        }
        else {
            [ws.sv toggleWithType:PIEPageTypeEliteFollow];
        }
    }];
    self.navigationItem.titleView = _segmentedControl;
}
- (void)refreshHeader {
    if (_sv.type == PIEPageTypeEliteFollow && ![_sv.tableFollow.header isRefreshing]) {
        [_sv.tableFollow.header beginRefreshing];
    } else if (_sv.type == PIEPageTypeEliteHot && ![_sv.tableHot.header isRefreshing]) {
        [_sv.tableHot.header beginRefreshing];
    }
}

#pragma mark - Getters and Setters

-(PIEEliteScrollView*)sv {
    if (!_sv) {
        _sv = [PIEEliteScrollView new];
        _sv.delegate =self;
    }
    return _sv;
}
#pragma mark - UITableView Datasource and delegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _sv.tableFollow) {
        return _sourceFollow.count;
    } else if (tableView == _sv.tableHot) {
        return _sourceHot.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _sv.tableFollow) {
        DDPageVM* vm = [_sourceFollow objectAtIndex:indexPath.row];
        if (vm.type == PIEPageTypeAsk) {
            PIEEliteAskTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:askIndentifier];
            [cell injectSauce:vm];
            return cell;
        }
        else {
            PIEEliteReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:replyIndentifier];
            [cell injectSauce:vm];
            return cell;
        }
    } else if (tableView == _sv.tableHot) {
        DDPageVM* vm = [_sourceHot objectAtIndex:indexPath.row];
        if (vm.type == PIEPageTypeAsk) {
            PIEEliteAskTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:askIndentifier];
            [cell injectSauce:vm];
            return cell;
        }
        else {
            PIEEliteHotReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:hotReplyIndentifier];
            [cell injectSauce:vm];
            return cell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _sv.tableFollow) {
        DDPageVM* vm = [_sourceFollow objectAtIndex:indexPath.row];
        if (vm.type == PIEPageTypeAsk) {
            return [tableView fd_heightForCellWithIdentifier:askIndentifier  cacheByIndexPath:indexPath configuration:^(PIEEliteAskTableViewCell *cell) {
                [cell injectSauce:[_sourceFollow objectAtIndex:indexPath.row]];
            }];

        }
        else {
            return [tableView fd_heightForCellWithIdentifier:replyIndentifier  cacheByIndexPath:indexPath configuration:^(PIEEliteReplyTableViewCell *cell) {
                [cell injectSauce:[_sourceFollow objectAtIndex:indexPath.row]];
            }];
        }
    } else if (tableView == _sv.tableHot) {
        DDPageVM* vm = [_sourceHot objectAtIndex:indexPath.row];
        if (vm.type == PIEPageTypeAsk) {
            return [tableView fd_heightForCellWithIdentifier:askIndentifier  cacheByIndexPath:indexPath configuration:^(PIEEliteAskTableViewCell *cell) {
                [cell injectSauce:[_sourceHot objectAtIndex:indexPath.row]];
            }];
            
        }
        else {
            return [tableView fd_heightForCellWithIdentifier:hotReplyIndentifier  cacheByIndexPath:indexPath configuration:^(PIEEliteHotReplyTableViewCell *cell) {
                [cell injectSauce:[_sourceHot objectAtIndex:indexPath.row]];
            }];
        }

    } else {
        return 0;
    }
}

#pragma mark - Gesture Event


- (void)tapGestureFollow:(UITapGestureRecognizer *)gesture {
    if (_sv.type == PIEPageTypeEliteFollow) {
        CGPoint location = [gesture locationInView:_sv.tableFollow];
        _selectedIndexPath = [_sv.tableFollow indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            //关注  求p
            _selectedVM = _sourceFollow[_selectedIndexPath.row];

            if (_selectedVM.type == PIEPageTypeAsk) {

                PIEEliteAskTableViewCell* cell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
                CGPoint p = [gesture locationInView:cell];
                //点击小图
                //点击大图
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    //进入热门详情
                    PIECarouselViewController* vc = [PIECarouselViewController new];
                    _selectedVM.image = cell.theImageView.image;
                    vc.pageVM = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                //点击头像
                else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
                    friendVC.pageVM = _selectedVM;
                    [self.navigationController pushViewController:friendVC animated:YES];
                }
                //点击用户名
                else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
                    friendVC.pageVM = _selectedVM;
                    [self.navigationController pushViewController:friendVC animated:YES];
                }
                else if (CGRectContainsPoint(cell.bangView.frame, p)) {
                        [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
                }
                else if (CGRectContainsPoint(cell.followView.frame, p)) {
                    [self follow:cell.followView];
                }
                else if (CGRectContainsPoint(cell.shareView.frame, p)) {
                    [self showShareView];
                }
               
                else if (CGRectContainsPoint(cell.commentView.frame, p)) {
                    DDCommentVC* vc = [DDCommentVC new];
                    vc.vm = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if (CGRectContainsPoint(cell.allWorkView.frame, p)) {
                    PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
                    vc.pageVM = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }

            }
            
            //关注  作品
            
            else {
                PIEEliteReplyTableViewCell* cell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
                CGPoint p = [gesture locationInView:cell];
                //点击小图
                //点击小图
                if (CGRectContainsPoint(cell.thumbView.frame, p)) {
                    CGPoint pp = [gesture locationInView:cell.thumbView];
                    if (CGRectContainsPoint(cell.thumbView.leftView.frame,pp)) {
                        [cell animateThumbScale:PIEAnimateViewTypeLeft];
                    }
                    else if (CGRectContainsPoint(cell.thumbView.rightView.frame,pp)) {
                        [cell animateThumbScale:PIEAnimateViewTypeRight];
                    }
                }
                //点击大图
                else  if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    //进入热门详情
                    PIECarouselViewController* vc = [PIECarouselViewController new];
                    _selectedVM.image = cell.theImageView.image;
                    vc.pageVM = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                //点击头像
                else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
                    friendVC.pageVM = _selectedVM;
                    [self.navigationController pushViewController:friendVC animated:YES];
                }
                //点击用户名
                else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
                    friendVC.pageVM = _selectedVM;
                    [self.navigationController pushViewController:friendVC animated:YES];
                }
                else if (CGRectContainsPoint(cell.likeView.frame, p)) {
                        [self like:cell.likeView];
                }
                else if (CGRectContainsPoint(cell.followView.frame, p)) {
                    [self follow:cell.followView];
                }
                else if (CGRectContainsPoint(cell.shareView.frame, p)) {
                    [self showShareView];
                }
                else if (CGRectContainsPoint(cell.collectView.frame, p)) {
                    [self collect:cell.collectView];
                }
                else if (CGRectContainsPoint(cell.commentView.frame, p)) {
                    DDCommentVC* vc = [DDCommentVC new];
                    vc.vm = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if (CGRectContainsPoint(cell.allWorkView.frame, p)) {
                    PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
                    vc.pageVM = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}

- (void)tapGestureHot:(UITapGestureRecognizer *)gesture {
    if (_sv.type == PIEPageTypeEliteHot) {
        CGPoint location = [gesture locationInView:_sv.tableHot];
        _selectedIndexPath = [_sv.tableHot indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            //关注  求p
            _selectedVM = _sourceHot[_selectedIndexPath.row];
            
            if (_selectedVM.type == PIEPageTypeAsk) {
                
                PIEEliteAskTableViewCell* cell = [_sv.tableHot cellForRowAtIndexPath:_selectedIndexPath];
                CGPoint p = [gesture locationInView:cell];
                //点击小图
                //点击大图
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    //进入热门详情
                    PIECarouselViewController* vc = [PIECarouselViewController new];
                    _selectedVM.image = cell.theImageView.image;
                    vc.pageVM = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                //点击头像
                else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
                    friendVC.pageVM = _selectedVM;
                    [self.navigationController pushViewController:friendVC animated:YES];
                }
                //点击用户名
                else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
                    friendVC.pageVM = _selectedVM;
                    [self.navigationController pushViewController:friendVC animated:YES];
                }
                else if (CGRectContainsPoint(cell.bangView.frame, p)) {
                    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
                }
                else if (CGRectContainsPoint(cell.followView.frame, p)) {
                    [self follow:cell.followView];
                }
                else if (CGRectContainsPoint(cell.shareView.frame, p)) {
                    [self showShareView];
                }
                
                else if (CGRectContainsPoint(cell.commentView.frame, p)) {
                    DDCommentVC* vc = [DDCommentVC new];
                    vc.vm = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if (CGRectContainsPoint(cell.allWorkView.frame, p)) {
                    PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
                    vc.pageVM = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            
            //关注  作品
            
            else {
                PIEEliteHotReplyTableViewCell* cell = [_sv.tableHot cellForRowAtIndexPath:_selectedIndexPath];
                CGPoint p = [gesture locationInView:cell];
                //点击小图
                if (CGRectContainsPoint(cell.thumbView.frame, p)) {
                    CGPoint pp = [gesture locationInView:cell.thumbView];
                    if (CGRectContainsPoint(cell.thumbView.leftView.frame,pp)) {
                        [cell animateThumbScale:PIEAnimateViewTypeLeft];
                    }
                    else if (CGRectContainsPoint(cell.thumbView.rightView.frame,pp)) {
                        [cell animateThumbScale:PIEAnimateViewTypeRight];
                    }
                }
                //点击大图
                else  if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    //进入热门详情
                    PIECarouselViewController* vc = [PIECarouselViewController new];
                    _selectedVM.image = cell.theImageView.image;
                    vc.pageVM = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                //点击头像
                else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
                    friendVC.pageVM = _selectedVM;
                    [self.navigationController pushViewController:friendVC animated:YES];
                }
                //点击用户名
                else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
                    friendVC.pageVM = _selectedVM;
                    [self.navigationController pushViewController:friendVC animated:YES];
                }
                else if (CGRectContainsPoint(cell.likeView.frame, p)) {
                    [self like:cell.likeView];
                }
                else if (CGRectContainsPoint(cell.followView.frame, p)) {
                    [self follow:cell.followView];
                }
                else if (CGRectContainsPoint(cell.shareView.frame, p)) {
                    [self showShareView];
                }
                else if (CGRectContainsPoint(cell.collectView.frame, p)) {
                    [self collect:cell.collectView];
                }
                else if (CGRectContainsPoint(cell.commentView.frame, p)) {
                    DDCommentVC* vc = [DDCommentVC new];
                    vc.vm = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if (CGRectContainsPoint(cell.allWorkView.frame, p)) {
                    PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
                    vc.pageVM = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}





- (void)showShareView {
    [self.shareView show];
}

-(void)follow:(UIImageView*)followView {
    followView.highlighted = !followView.highlighted;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_selectedVM.userID) forKey:@"uid"];
    if (followView.highlighted) {
        [param setObject:@1 forKey:@"status"];
    }
    else {
        [param setObject:@0 forKey:@"status"];
    }

    [DDService follow:param withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.followed = followView.highlighted;
        } else {
            followView.highlighted = !followView.highlighted;
        }
    }];
}
-(void)collect:(PIEPageButton*) collectView {
    NSMutableDictionary *param = [NSMutableDictionary new];
    collectView.selected = !collectView.selected;
    if (collectView.selected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:_selectedVM.type withID:_selectedVM.ID withBlock:^(NSError *error) {
        if (!error) {
            _selectedVM.collected = collectView.selected;
            _selectedVM.collectCount = collectView.numberString;
        }   else {
            collectView.selected = !collectView.selected;
        }
    }];
}

-(void)like:(PIEPageLikeButton*)likeView {
    likeView.selected = !likeView.selected;

    [DDService toggleLike:likeView.selected ID:_selectedVM.ID type:_selectedVM.type  withBlock:^(BOOL success) {
        if (success) {
            if (likeView.selected) {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue + 1];
            } else {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue - 1];
            }
            _selectedVM.liked = likeView.selected;
        } else {
            likeView.selected = !likeView.selected;
        }
    }];
}


- (void)help:(BOOL)shouldDownload {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_selectedVM.ID) forKey:@"target"];
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        if (imageUrl != nil) {
            if (shouldDownload) {
                [DDService downloadImage:imageUrl withBlock:^(UIImage *image) {
                    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }];
            }
        }
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Hud error:@"保存失败" inView:self.view];
    } else {
        [Hud success:@"保存成功" inView:self.view];
    }
}

#pragma mark - ATOMShareViewDelegate

//sina
-(void)tapShare1 {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:_selectedVM.type];
}
//qqzone
-(void)tapShare2 {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeQQZone withPageType:_selectedVM.type];
}
//wechat moments
-(void)tapShare3 {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:_selectedVM.type];
}
//wechat friends
-(void)tapShare4 {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:_selectedVM.type];
}
-(void)tapShare5 {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeQQFriends withPageType:_selectedVM.type];
    
}
-(void)tapShare6 {
    
}
-(void)tapShare7 {
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
}
-(void)tapShare8 {
    if (_sv.type == PIEPageTypeEliteHot) {
        //        [self collect:_selectedHotCell.collectView];
    } else {
        [self collect:nil];
    }
}

-(void)tapShareCancel {
    [self.shareView dismiss];
}



#pragma mark - getDataSource

- (void)getRemoteSourceFollow {
    WS(ws);
    [ws.sv.tableFollow.footer endRefreshing];
    _currentIndex_follow = 1;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(5) forKey:@"size"];
    
    [PIEEliteManager getMyFollow:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterFollow = NO;
            [ws.sv.tableFollow.header endRefreshing];
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sv.tableFollow.header endRefreshing];
            [ws.sourceFollow removeAllObjects];
            [ws.sourceFollow addObjectsFromArray:sourceAgent];
            [ws.sv.tableFollow reloadData];
        }
    }];
}

- (void)getMoreRemoteSourceFollow {
    WS(ws);
    [ws.sv.tableFollow.header endRefreshing];
    _currentIndex_follow++;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentIndex_follow) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    [PIEEliteManager getMyFollow:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterFollow = NO;
            [ws.sv.tableFollow.footer endRefreshing];
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sv.tableFollow.footer endRefreshing];
            [ws.sourceFollow addObjectsFromArray:sourceAgent];
            [ws.sv.tableFollow reloadData];
        }
    }];
}

- (void)firstGetRemoteSourceHot:(void (^)(BOOL finished))block {
    [_sv.tableHot.header beginRefreshing];
}
- (void)firstGetRemoteSourceFollow:(void (^)(BOOL finished))block {
    [_sv.tableFollow.header beginRefreshing];
}

- (void)getRemoteSourceHot:(void (^)(BOOL finished))block {
    WS(ws);
    [ws.sv.tableHot.footer endRefreshing];
    _currentIndex_hot = 1;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(8) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sourceHot removeAllObjects];
            [ws.sourceHot addObjectsFromArray:sourceAgent];
            [ws.sv.tableHot reloadData];
        }
        [ws.sv.tableHot.header endRefreshing];
        if (block) {
            block(YES);
        }
    }];
}
- (void)getMoreRemoteSourceHot {
    WS(ws);
    [ws.sv.tableHot.header endRefreshing];
    _currentIndex_hot ++;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentIndex_hot) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sourceHot addObjectsFromArray:sourceAgent];
            [ws.sv.tableHot reloadData];
        }
        [ws.sv.tableHot.footer endRefreshing];
    }];
}

-(void)didPullRefreshDown:(UITableView *)tableView {
    if (tableView == _sv.tableFollow) {
        [self getRemoteSourceFollow];
    } else  {
        [self getRemoteSourceHot:nil];
    }
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (tableView == _sv.tableFollow) {
        if (_canRefreshFooterFollow) {
            [self getMoreRemoteSourceFollow];
        } else {
            [_sv.tableFollow.footer endRefreshing];
        }
    } else {
        if (_canRefreshFooterHot) {
            [self getMoreRemoteSourceHot];
        } else {
            [_sv.tableHot.footer endRefreshing];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _sv) {
        int currentPage = (scrollView.contentOffset.x + CGWidth(scrollView.frame) * 0.1) / CGWidth(scrollView.frame);
        if (currentPage == 0) {
            _sv.tableHot.scrollsToTop = YES;
            _sv.tableFollow.scrollsToTop = NO;
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
            _sv.type = PIEPageTypeEliteHot;
        } else if (currentPage == 1) {
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            _sv.tableHot.scrollsToTop = NO;
            _sv.tableFollow.scrollsToTop = YES;
            _sv.type = PIEPageTypeEliteFollow;
        }
    }
}

-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}
- (JGActionSheet *)psActionSheet {
    WS(ws);
    if (!_psActionSheet) {
        _psActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"下载图片，马上帮P", @"塞入“进行中”,暂不下载",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:2];
        NSArray *sections = @[section];
        _psActionSheet = [JGActionSheet actionSheetWithSections:sections];
        _psActionSheet.delegate = self;
        [_psActionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_psActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 0:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws help:YES];
                    break;
                case 1:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws help:NO];
                    break;
                case 2:
                    [ws.psActionSheet dismissAnimated:YES];
                    break;
                default:
                    [ws.psActionSheet dismissAnimated:YES];
                    break;
            }
        }];
    }
    return _psActionSheet;
}
- (JGActionSheet *)reportActionSheet {
    WS(ws);
    if (!_reportActionSheet) {
        _reportActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"色情、淫秽或低俗内容", @"广告或垃圾信息",@"违反法律法规的内容"] buttonStyle:JGActionSheetButtonStyleDefault];
        NSArray *sections = @[section];
        _reportActionSheet = [JGActionSheet actionSheetWithSections:sections];
        _reportActionSheet.delegate = self;
        [_reportActionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_reportActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(ws.selectedVM.ID) forKey:@"target_id"];
            [param setObject:@(PIEPageTypeAsk) forKey:@"target_type"];
            UIButton* b = section.buttons[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 1:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 2:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                default:
                    [ws.reportActionSheet dismissAnimated:YES];
                    break;
            }
            [ATOMReportModel report:param withBlock:^(NSError *error) {
                if(!error) {
                    [Hud text:@"已举报" inView:[AppDelegate APP].window];
                }
                
            }];
        }];
    }
    return _reportActionSheet;
}


@end
