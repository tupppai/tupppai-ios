//
//  PIEEliteFollowReplyViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/17.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteFollowViewController.h"
#import "PIEActionSheet_PS.h"
#import "PIEShareView.h"
#import "PIERefreshTableView.h"
#import "PIEEliteFollowReplyTableViewCell.h"
#import "PIEEliteFollowAskTableViewCell.h"
#import "DDCollectManager.h"
#import "DeviceUtil.h"
#import "PIEEliteManager.h"
#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"
#import "AppDelegate.h"
#import "PIECommentViewController.h"
#import "PIEReplyCollectionViewController.h"

#import "PIECellIconStatusChangedNotificationKey.h"

/* Variables */
@interface PIEEliteFollowViewController ()
@property (nonatomic, strong) NSMutableArray *sourceFollow;

@property (nonatomic, strong) PIERefreshTableView *tableFollow;

@property (nonatomic, assign) BOOL isfirstLoadingFollow;

@property (nonatomic, assign) NSInteger currentIndex_follow;

@property (nonatomic, assign) BOOL canRefreshFooterFollow;

@property (nonatomic, assign) long long timeStamp_follow;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath_follow;

@property (nonatomic, strong) PIEPageVM *selectedVM;

@property (nonatomic, strong) PIEActionSheet_PS * psActionSheet;

@property (nonatomic, strong) PIEShareView * shareView;

@end

/* Protocols */
@interface PIEEliteFollowViewController (TableView)
<UITableViewDelegate,UITableViewDataSource>
@end

@interface PIEEliteFollowViewController (PWRefreshBaseTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEEliteFollowViewController (PIEShareView)
<PIEShareViewDelegate>
@end

@interface PIEEliteFollowViewController (DZNEmptyDataSet)
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@interface PIEEliteFollowViewController (JGActionSheet)
<JGActionSheetDelegate>
@end

@implementation PIEEliteFollowViewController

static  NSString* askIndentifier      = @"PIEEliteFollowAskTableViewCell";
static  NSString* replyIndentifier    = @"PIEEliteFollowReplyTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configData];
    
    [self setupNotificationObserver];
    
    [self configTableViewFollow];
    
    [self setupGestures];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_Elite_Follow" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PIECollectedIconStatusChangedNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PIESharedIconStatusChangedNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PIELikedIconStatusChangedNotification
                                                  object:nil];
}

#pragma mark - data setup
- (void)configData {
    _canRefreshFooterFollow = YES;
    
    _currentIndex_follow    = 1;
    
    _isfirstLoadingFollow   = YES;
    
    _sourceFollow           = [NSMutableArray new];
    
   
}

#pragma mark - Notification Setup
- (void)setupNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_Elite_Follow" object:nil];
    
    // 响应下一级PIECarouselItemView和下下一级的PIECommentViewController的“收藏”Icon同步事件
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(collectedIconStatusDidChanged:)
     name:PIECollectedIconStatusChangedNotification
     object:nil];
    
    // 响应下一级的PIECarouselItemView和下下一级的PIECommentViewController的“分享”icon的数字的同步事件
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateShareStatus)
     name:PIESharedIconStatusChangedNotification
     object:nil];
//    
//    // 响应下一级的PIECarouselItemView和下下一级的PIECommentViewController的“点赞”icon的数字的同步事件
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(updateLikedStatus:)
//     name:PIELikedIconStatusChangedNotification
//     object:nil];
}


#pragma mark - UI components setup
- (void)configTableViewFollow {
    // add as subview and add constraint
    [self.view addSubview:self.tableFollow];
    
    [self.tableFollow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupGestures {
    
    UITapGestureRecognizer* tapGestureFollow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFollow:)];
    [self.tableFollow addGestureRecognizer:tapGestureFollow];
   
    UILongPressGestureRecognizer* longPressGestureFollow = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnFollow:)];
    [self.tableFollow addGestureRecognizer:longPressGestureFollow];
    
}


#pragma mark - Notification Methods
- (void)refreshHeader {
    if (self.tableFollow.mj_header.isRefreshing == false) {
        [self.tableFollow.mj_header beginRefreshing];
    }
}

- (void)collectedIconStatusDidChanged:(NSNotification *)notification
{
    if (_selectedIndexPath_follow) {
//        BOOL isCollected = [notification.userInfo[PIECollectedIconIsCollectedKey] boolValue];
//        NSString *collectedCount = notification.userInfo[PIECollectedIconCollectedCountKey];
        PIEPageVM* vm = [_sourceFollow objectAtIndex:_selectedIndexPath_follow.row];
        if (vm.type == PIEPageTypeReply) {
            /* 取得PIEEliteFollowReplyTableViewCell的实例，修改星星的状态和个数 */
            PIEEliteFollowReplyTableViewCell *cell =
            [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
            cell.collectView.highlighted  = vm.collected;
            cell.collectView.numberString = vm.collectCount;
        }

    }
    
}

/**
 *  用户点击了updateShareStatus之后（在弹出的窗口分享），刷新本页面ReplyCell的分享数
 */
- (void)updateShareStatus {
    
    /*
     _vm.shareCount ++ 这个副作用集中发生在PIEShareView之中。
     
     */
    
    //    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    
    if (_selectedIndexPath_follow != nil) {
        [self.tableFollow reloadRowsAtIndexPaths:@[_selectedIndexPath_follow] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (void)updateLikedStatus:(NSNotification *)notification
{
    // 严格按照通知传来的值来刷新UI状态，可免去不少麻烦；
    BOOL isLiked = notification.userInfo[PIELikedIconIsLikedKey];
    // 刷新UI
    
    // BUG AWARE!
    // 这里不知道怎么判断pageViewModel的类型（eliteFollow?eliteHot?Ask?Reply? 这四个枚举值又不可以用"||"叠加但意义又有交集,却只能居其一）
    // 所以有个Pre-Assumption: 带着“点赞”按钮的cell，类型只能是reply(只能点赞其他人的帮P）
    // 假如将来需求有变，这里可能会出现BAD_ACCESS_EXEC的崩溃错误。
    
    PIEEliteFollowReplyTableViewCell *cell =[_tableFollow dequeueReusableCellWithIdentifier:replyIndentifier
                                                                               forIndexPath:_selectedIndexPath_follow];
    cell.likeView.selected = isLiked;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceFollow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PIEPageVM* vm = [_sourceFollow objectAtIndex:indexPath.row];
        
    if (vm.type == PIEPageTypeAsk) {
        PIEEliteFollowAskTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:askIndentifier];
        [cell injectSauce:vm];
        return cell;
    }
    else {
        PIEEliteFollowReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:replyIndentifier];
        [cell injectSauce:vm];
        return cell;
    }
    

}

#pragma mark - <UITableViewDelegate>
/* Nothing yet. */

#pragma mark - Cell 点击事件

/** Cell-点击 － 关注 */
- (void)follow:(UIImageView*)followView {
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

/** Cell-点击 收藏 */
-(void)collect:(PIEPageButton*) collectView shouldShowHud:(BOOL)shouldShowHud {
    
    // 这里的“收藏”方法的逻辑和shareView中的完全一样，可以考虑将下面的代码统一封装到DDCollectionManager之中，
    // 让controller的collet：方法和shareView的collect方法调用
    
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
            if (shouldShowHud) {
                if (  collectView.selected) {
                    [Hud textWithLightBackground:@"收藏成功"];
                } else {
                    [Hud textWithLightBackground:@"取消收藏成功"];
                }
            }
            _selectedVM.collected = collectView.selected;
            _selectedVM.collectCount = collectView.numberString;
        }   else {
            collectView.selected = !collectView.selected;
        }
    }];
}

/** Cell点击 － 点赞 */
-(void)like:(PIEPageLikeButton*)likeView {
    /**
     *  准备发往服务器的“点赞”的状态（特地这么明显地写出来以防出错）
     */
    
    BOOL likeButtonSelectedStatusToSend = !likeView.selected;
    
    [DDService toggleLike:likeButtonSelectedStatusToSend ID:_selectedVM.ID type:_selectedVM.type  withBlock:^(BOOL success) {
        if (success) {
            // 自己发送的通知自己也会监听，和其他观察者一同刷新UI
            // 发通知后所有观察者只负责刷新UI不修改ViewModel；谁发通知就由谁更新ViewModel（副作用只发生一次！）。
            
            // 在这一步只修改ViewModel
            _selectedVM.liked =  !likeView.selected;
            if (likeView.selected) {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue + 1];
            } else {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue - 1];
            }
            
            // 由最终的_vm.liked作为通知发送携带的值的最终标准
            [[NSNotificationCenter defaultCenter]
             postNotificationName:PIELikedIconStatusChangedNotification
             object:nil
             userInfo:@{PIELikedIconIsLikedKey:@(_selectedVM.liked)}];
            
        }
        else {
            // 服务器没有确认这次”点赞“的行为，所以既不刷新UI也不对ViewModel做任何修改
            [Hud text:@"服务器不鸟你～"];
        }
    }];

}

#pragma mark - <PIEShareViewDelegate> and its related methods
- (void)shareViewDidShare:(PIEShareView *)shareView
{
    // refresh ui element on main thread after successful sharing, do nothing otherwise.
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self updateShareStatus];
//    }];
}

- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}

- (void)shareViewDidCollect:(PIEShareView *)shareView
{
    // Optional的代理方法：仅在EliteViewController才有星星需要更新状态
   
    
    
}



- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
}

#pragma mark - fetch data source
- (void)getRemoteSourceFollow {
    WS(ws);
    [self.tableFollow.mj_footer endRefreshing];
    _currentIndex_follow = 1;
    _timeStamp_follow = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_follow) forKey:@"last_updated"];
    
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    
    [PIEEliteManager getMyFollow:param withBlock:^(NSMutableArray *returnArray) {
        ws.isfirstLoadingFollow = NO;
        if (returnArray.count == 0) {
            _canRefreshFooterFollow = NO;
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
                [ws.sourceFollow removeAllObjects];
                [ws.sourceFollow addObjectsFromArray:sourceAgent];
            }
        }
        [ws.tableFollow.mj_header endRefreshing];
        [ws.tableFollow reloadData];
    }];
}

- (void)getMoreRemoteSourceFollow {
    WS(ws);
    [self.tableFollow.mj_header endRefreshing];
    _currentIndex_follow++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_follow) forKey:@"last_updated"];
    
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [param setObject:@(_currentIndex_follow) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    [PIEEliteManager getMyFollow:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterFollow = NO;
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sourceFollow addObjectsFromArray:sourceAgent];
        }
        [ws.tableFollow reloadData];
        [ws.tableFollow.mj_footer endRefreshing];
    }];
}

/** 以下方法设置为Public */
- (void)getSourceIfEmpty_follow:(void (^)(BOOL finished))block {
    if (_isfirstLoadingFollow || _sourceFollow.count <= 0) {
        [self.tableFollow.mj_header beginRefreshing];
    }
}

#pragma mark - <PWRefreshBaseTableViewDelegate>

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getRemoteSourceFollow];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooterFollow) {
        [self getMoreRemoteSourceFollow];
    } else {
        [self.tableFollow.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - <DZNEmptyDataSetSource>
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {

    return [UIImage imageNamed:@"pie_empty"];
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"赶快去关注些大神吧";

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 100;
}

#pragma mark - <DZNEmptyDataSetDelegate>
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    /* 如果是第一次加载数据之前，那么即使数据源为空也不要显示emptyDataSet */
    if (_isfirstLoadingFollow) {
        return NO;
    }
    else{
        return YES;
    }
    
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - Gesture Event

- (void)longPressOnFollow:(UILongPressGestureRecognizer *)gesture {
        CGPoint location = [gesture locationInView:self.tableFollow];
        _selectedIndexPath_follow = [self.tableFollow indexPathForRowAtPoint:location];
        _selectedVM = _sourceFollow[_selectedIndexPath_follow.row];
        if (_selectedIndexPath_follow) {
            //关注  求p
            _selectedVM = _sourceFollow[_selectedIndexPath_follow.row];
            
            if (_selectedVM.type == PIEPageTypeAsk) {
                
                PIEEliteFollowAskTableViewCell* cell = [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
                CGPoint p = [gesture locationInView:cell];
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    //进入热门详情
                    [self showShareView:_selectedVM];
                }
            }
            
            //关注  作品
            else {
                PIEEliteFollowReplyTableViewCell* cell = [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
                CGPoint p = [gesture locationInView:cell];
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    [self showShareView:_selectedVM];
                }
            }
        }
    
}

- (void)tapGestureFollow:(UITapGestureRecognizer *)gesture {
        CGPoint location = [gesture locationInView:self.tableFollow];
        _selectedIndexPath_follow = [self.tableFollow indexPathForRowAtPoint:location];
        if (_selectedIndexPath_follow) {
            //关注  求p
            _selectedVM = _sourceFollow[_selectedIndexPath_follow.row];
            
            if (_selectedVM.type == PIEPageTypeAsk) {
                
                PIEEliteFollowAskTableViewCell* cell = [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
                CGPoint p = [gesture locationInView:cell];
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    //进入热门详情
                    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                    //                    _selectedVM.image = cell.theImageView.image;
                    vc.pageVM = _selectedVM;
                    [self presentViewController:vc animated:YES completion:nil];
                    
                    
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
                    self.psActionSheet.vm = _selectedVM;
                    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
                }
                else if (CGRectContainsPoint(cell.followView.frame, p)) {
                    [self follow:cell.followView];
                }
                else if (CGRectContainsPoint(cell.shareView.frame, p)) {
                    [self showShareView:_selectedVM];
                }
                
                else if (CGRectContainsPoint(cell.commentView.frame, p)) {
                    PIECommentViewController* vc = [PIECommentViewController new];
                    vc.shouldShowHeaderView = NO;
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
                PIEEliteFollowReplyTableViewCell* cell = [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
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
                    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                    //                    _selectedVM.image = cell.theImageView.image;
                    vc.pageVM = _selectedVM;
                    [self presentViewController:vc animated:YES completion:nil];
                    
                   
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
                    [self showShareView:_selectedVM];
                }
                else if (CGRectContainsPoint(cell.collectView.frame, p)) {
                    [self collect:cell.collectView shouldShowHud:NO];
                }
                else if (CGRectContainsPoint(cell.commentView.frame, p)) {
                    PIECommentViewController* vc = [PIECommentViewController new];
                    vc.vm = _selectedVM;
                    vc.shouldShowHeaderView = NO;
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

#pragma mark - Lazy loadings
- (PIERefreshTableView *)tableFollow
{
    if (_tableFollow == nil) {
        _tableFollow = [[PIERefreshTableView alloc] init];
        
        _tableFollow.dataSource           = self;
        _tableFollow.delegate             = self;
        _tableFollow.psDelegate           = self;
        _tableFollow.emptyDataSetSource   = self;
        _tableFollow.emptyDataSetDelegate = self;
        
        
        _tableFollow.estimatedRowHeight   = SCREEN_WIDTH+155;
        _tableFollow.rowHeight            = UITableViewAutomaticDimension;
        
        
        UINib* nib2 = [UINib nibWithNibName:askIndentifier bundle:nil];
        [self.tableFollow registerNib:nib2 forCellReuseIdentifier:askIndentifier];
        UINib* nib3 = [UINib nibWithNibName:replyIndentifier bundle:nil];
        [self.tableFollow registerNib:nib3 forCellReuseIdentifier:replyIndentifier];
        
        
    }
    
    return _tableFollow;
}


-(PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
    }
    return _psActionSheet;
}

-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}
@end
