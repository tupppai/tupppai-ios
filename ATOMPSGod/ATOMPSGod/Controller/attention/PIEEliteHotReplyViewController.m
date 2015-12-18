//
//  PIEEliteHotReplyViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/17.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteHotReplyViewController.h"
#import "PIEActionSheet_PS.h"
#import "PIEShareView.h"
#import "PIEEliteViewController.h"
#import "SwipeView.h"
#import "PIEBannerViewModel.h"
#import "PIERefreshTableView.h"
#import "PIEWebViewViewController.h"
#import "SMPageControl.h"
#import "PIEEliteHotReplyTableViewCell.h"
#import "PIEEliteHotAskTableViewCell.h"
#import "DeviceUtil.h"
#import "PIEEliteManager.h"
#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"
#import "AppDelegate.h"
#import "PIECommentViewController.h"
#import "PIEReplyCollectionViewController.h"
#import "DDCollectManager.h"

/* Variables */
@interface PIEEliteHotReplyViewController ()

@property (nonatomic, strong) PIERefreshTableView *tableHot;

@property (nonatomic, strong) SwipeView *swipeView;

@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *sourceHot;

@property (nonatomic, strong) NSMutableArray<PIEBannerViewModel *> *sourceBanner;

@property (nonatomic, assign) BOOL isfirstLoadingHot;

@property (nonatomic, assign) NSInteger currentIndex_hot;

@property (nonatomic, assign) BOOL canRefreshFooterHot;

@property (nonatomic, assign)  long long timeStamp_hot;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath_hot;

@property (nonatomic, strong) PIEActionSheet_PS * psActionSheet;

@property (nonatomic, strong) PIEShareView * shareView;

@property (nonatomic, strong) PIEPageVM *selectedVM;

@property (nonatomic, strong) SMPageControl *pageControl_swipeView;

@end

/* Protocols */
@interface PIEEliteHotReplyViewController (TableView)
<UITableViewDelegate,UITableViewDataSource>
@end

@interface PIEEliteHotReplyViewController (RefreshBaseTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEEliteHotReplyViewController (PIEShareView)
<PIEShareViewDelegate>
@end

@interface PIEEliteHotReplyViewController (SwipeView)
<SwipeViewDelegate,SwipeViewDataSource>
@end

@interface PIEEliteHotReplyViewController (DZNEmptyDataSet)
<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@end

//@interface PIEEliteViewController (JGActionSheet)
//<JGActionSheetDelegate>
//@end

@implementation PIEEliteHotReplyViewController

static  NSString* hotReplyIndentifier = @"PIEEliteHotReplyTableViewCell";
static  NSString* hotAskIndentifier   = @"PIEEliteHotAskTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configTableViewHot];
    [self setupGestures];
    
    [self getSourceIfEmpty_hot:nil];
    [self getSourceIfEmpty_banner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_Elite" object:nil];
}

#pragma mark - data setup

- (void)configData {
    _canRefreshFooterHot    = YES;
    
    _currentIndex_hot       = 1;
    
    _isfirstLoadingHot      = YES;
    
    _sourceHot              = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_Elite" object:nil];
}



#pragma mark - UI components setup

- (void)configTableViewHot {
    
    _tableHot.dataSource = self;
    _tableHot.delegate = self;
    _tableHot.psDelegate = self;
    _tableHot.emptyDataSetDelegate = self;
    _tableHot.emptyDataSetSource = self;
    _tableHot.estimatedRowHeight = SCREEN_WIDTH+225;
    _tableHot.rowHeight = UITableViewAutomaticDimension;
    UINib* nib = [UINib nibWithNibName:hotReplyIndentifier bundle:nil];
    [_tableHot registerNib:nib forCellReuseIdentifier:hotReplyIndentifier];
    UINib* nib2 = [UINib nibWithNibName:hotAskIndentifier bundle:nil];
    [_tableHot registerNib:nib2 forCellReuseIdentifier:hotAskIndentifier];
    _swipeView.dataSource = self;
    _swipeView.delegate = self;
    
}

- (void)setupGestures {
    UITapGestureRecognizer* tapGestureHot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHot:)];
    [_tableHot addGestureRecognizer:tapGestureHot];
    
    UILongPressGestureRecognizer* longPressGestureHot = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnHot:)];
    [_tableHot addGestureRecognizer:longPressGestureHot];
   
    
}


#pragma mark - Notification methods
- (void)refreshHeader {
    if (_tableHot.mj_header.isRefreshing == false) {
        [ _tableHot.mj_header beginRefreshing];
    }
}

#pragma mark - <SwipeViewDataSource>
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return _sourceBanner.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        CGFloat width = _swipeView.frame.size.width;
        CGFloat height = _swipeView.frame.size.height;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    PIEBannerViewModel* vm = [_sourceBanner objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            //            imageView.image = tabbar.avatarImage;
            //            NSLog(@"[DDUserManager currentUser].avatar]%@",[DDUserManager currentUser].avatar);
            [imageView setImageWithURL:[NSURL URLWithString:vm.imageUrl]];
        }
    }

    return view;
}

#pragma mark - <SwipeViewDelegate>
-(void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    _pageControl_swipeView.currentPage = swipeView.currentItemIndex;
}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    PIEWebViewViewController* vc = [PIEWebViewViewController new];
    vc.viewModel = [_sourceBanner objectAtIndex:index];
    [self.navigationController pushViewController:vc animated:YES];
}

// 以下方法没有被调用过
- (void)tapPageControl:(SMPageControl *)sender
{
    [_swipeView scrollToItemAtIndex:sender.currentPage duration:0.5];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceHot.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm = [_sourceHot objectAtIndex:indexPath.row];
    
    if (vm.type == PIEPageTypeAsk) {
        PIEEliteHotAskTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:hotAskIndentifier];
        [cell injectSauce:vm];
        return cell;
    }
    else {
        PIEEliteHotReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:hotReplyIndentifier];
        [cell injectSauce:vm];
        return cell;
    }
}


#pragma mark - <UITableViewDelegate>

/* nothing yet. */

#pragma mark - <PIEShareViewDelegate> and its related methods

- (void)shareViewDidShare:(PIEShareView *)shareView
{
    // refresh ui element on main thread after successful sharing, do nothing otherwise.
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateShareStatus];
    }];
}

- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}


// @optional的代理方法：仅在EliteViewController才有星星需要更新状态
- (void)shareViewDidCollect:(PIEShareView *)shareView
{
    /* 取得PIEEliteHotReplyTableViewCell的实例，修改星星的状态和个数 */
    PIEEliteHotReplyTableViewCell *cell =
    [_tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
    cell.collectView.highlighted  = _selectedVM.collected;
    cell.collectView.numberString = _selectedVM.collectCount;
}

/**
 *  用户点击了updateShareStatus之后（在弹出的窗口分享），刷新本页面ReplyCell的分享数
 */
- (void)updateShareStatus {
    
    // update view models; refresh UI element.
    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    
   if (_selectedIndexPath_hot != nil)
    {
        [_tableHot reloadRowsAtIndexPaths:@[_selectedIndexPath_hot]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

/** 分享当前pageVM对应的图片 */
- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
}


#pragma mark - <PWRefreshBaseTableViewDelegate>
-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getRemoteSourceHot:nil];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooterHot) {
        [self getMoreRemoteSourceHot];
    } else {
        [_tableHot.mj_footer endRefreshingWithNoMoreData];
    }

}

#pragma mark - <DZNEmptyDataSetSource> 

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"好伤心，再下拉刷新试试";
   
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
    if (_isfirstLoadingHot) {
        return NO;
    }
    else{
        return YES;
    }
    

}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - Gesture events
- (void)longPressOnHot:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableHot];
    _selectedIndexPath_hot = [_tableHot indexPathForRowAtPoint:location];
    if (_selectedIndexPath_hot) {
        //关注  求p
        _selectedVM = _sourceHot[_selectedIndexPath_hot.row];
        
        if (_selectedVM.type == PIEPageTypeAsk) {
            
            PIEEliteHotAskTableViewCell* cell = [_tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                [self showShareView:_selectedVM];
            }
        }
        //关注  作品
        
        else {
            PIEEliteHotReplyTableViewCell* cell = [_tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
            CGPoint p = [gesture locationInView:cell];
            //点击大图
            if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                [self showShareView:_selectedVM];
            }
            
        }
    }
}

- (void)tapGestureHot:(UITapGestureRecognizer *)gesture {
        CGPoint location = [gesture locationInView:_tableHot];
        _selectedIndexPath_hot = [_tableHot indexPathForRowAtPoint:location];
        if (_selectedIndexPath_hot) {
            //关注  求p
            _selectedVM = _sourceHot[_selectedIndexPath_hot.row];
            
            if (_selectedVM.type == PIEPageTypeAsk) {
                
                PIEEliteHotAskTableViewCell* cell = [_tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
                CGPoint p = [gesture locationInView:cell];
                //点击小图
                //点击大图
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
                
                else if ((CGRectContainsPoint(cell.commentView.frame, p))||(CGRectContainsPoint(cell.commentLabel1.frame, p))||(CGRectContainsPoint(cell.commentLabel2.frame, p)) ) {
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
            
            
            else {
                PIEEliteHotReplyTableViewCell* cell = [_tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
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
                // 点赞
                else if (CGRectContainsPoint(cell.likeView.frame, p)) {
                    [self like:cell.likeView];
                }
                // 关注
                else if (CGRectContainsPoint(cell.followView.frame, p)) {
                    [self follow:cell.followView];
                }
                // 分享
                else if (CGRectContainsPoint(cell.shareView.frame, p)) {
                    [self showShareView:_selectedVM];
                }
                // 收藏
                else if (CGRectContainsPoint(cell.collectView.frame, p)) {
                    [self collect:cell.collectView shouldShowHud:NO];
                }
                else if ((CGRectContainsPoint(cell.commentView.frame, p))||(CGRectContainsPoint(cell.commentLabel1.frame, p))||(CGRectContainsPoint(cell.commentLabel2.frame, p)) ) {                    PIECommentViewController* vc = [PIECommentViewController new];
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

#pragma mark - Gesture actions

/** Cell点击 － 点赞 */
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

#pragma mark - Fetch _source data
- (void)getRemoteSourceBanner {
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    
    /*
     BUG FIXED: 这里要判断设备的机型分别@2x，@3x，否则返回的图片PPI不够。
     */
    if ([DeviceUtil hardware] == IPHONE_6_PLUS ||
        [DeviceUtil hardware] == IPHONE_6S_PLUS) {
        [param setObject:@(SCREEN_WIDTH_3x) forKey:@"width"];
    }
    else{
        [param setObject:@(SCREEN_WIDTH_2x) forKey:@"width"];
    }
    
    //    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [PIEEliteManager getBannerSource:param withBlock:^(NSMutableArray *array) {
        _sourceBanner = array;
        _pageControl_swipeView.numberOfPages = _sourceBanner.count;
        [_swipeView reloadData];
    }];
}

/** getSourceIfEmpty_xxx 这两个方法给我一种匪夷所思的感觉 */
- (void)getSourceIfEmpty_banner {
    if (_sourceBanner.count <= 0) {
        [self getRemoteSourceBanner];
    }
}

- (void)getSourceIfEmpty_hot:(void (^)(BOOL finished))block {
    if (_isfirstLoadingHot || _sourceHot.count <= 0) {
        [_tableHot.mj_header beginRefreshing];
    }
}

- (void)getRemoteSourceHot:(void (^)(BOOL finished))block {
    __weak typeof(self) weakSelf = self;
    
    [_tableHot.mj_footer endRefreshing];
    _currentIndex_hot = 1;
    _timeStamp_hot = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_hot) forKey:@"last_updated"];
    
    /*
     BUG FIXED: 这里要判断设备的机型分别@2x，@3x，否则返回的图片PPI不够。
     */
    if ([DeviceUtil hardware] == IPHONE_6_PLUS ||
        [DeviceUtil hardware] == IPHONE_6S_PLUS) {
        [param setObject:@(SCREEN_WIDTH_3x) forKey:@"width"];
    }
    else{
        [param setObject:@(SCREEN_WIDTH_2x) forKey:@"width"];
    }
    
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(8) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        weakSelf.isfirstLoadingHot = NO;
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            [weakSelf.sourceHot removeAllObjects];
            [weakSelf.sourceHot addObjectsFromArray:returnArray];
        }
        [weakSelf.tableHot reloadData];
        [weakSelf.tableHot.mj_header endRefreshing];
        if (block) {
            block(YES);
        }
    }];
}

- (void)getMoreRemoteSourceHot {
    __weak typeof(self) weakSelf = self;
    [_tableHot.mj_header endRefreshing];
    _currentIndex_hot ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_hot) forKey:@"last_updated"];
    
    /*
     BUG FIXED: 这里要判断设备的机型分别@2x，@3x，否则返回的图片PPI不够。
     */
    if ([DeviceUtil hardware] == IPHONE_6_PLUS ||
        [DeviceUtil hardware] == IPHONE_6S_PLUS) {
        [param setObject:@(SCREEN_WIDTH_3x) forKey:@"width"];
    }
    else{
        [param setObject:@(SCREEN_WIDTH_2x) forKey:@"width"];
    }
    
    
    [param setObject:@(_currentIndex_hot) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            [weakSelf.sourceHot addObjectsFromArray:returnArray];
        }
        [weakSelf.tableHot reloadData];
        [weakSelf.tableHot.mj_footer endRefreshing];
    }];
}


#pragma mark - Lazy loadings

-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}

-(PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
    }
    return _psActionSheet;
}
@end
