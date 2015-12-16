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
//#import "UITableView+FDTemplateLayoutCell.h"
#import "PIEEliteManager.h"
#import "PIEFriendViewController.h"
#import "PIECommentViewController.h"
#import "PIECommentViewController2.h"

#import "DDCollectManager.h"
#import "PIEReplyCollectionViewController.h"
#import "AppDelegate.h"
//
#import "PIEShareView.h"
#import "PIEEliteFollowAskTableViewCell.h"
#import "PIEEliteFollowReplyTableViewCell.h"
#import "PIEEliteHotReplyTableViewCell.h"
#import "PIEEliteHotAskTableViewCell.h"
#import "PIESearchViewController.h"
#import "DDNavigationController.h"
#import "PIEWebViewViewController.h"
#import "PIEShareImageView.h"
#import "PIECarouselViewController2.h"
#import "PIEActionSheet_PS.h"
#import "DeviceUtil.h"

@interface PIEEliteViewController ()<UITableViewDelegate,UITableViewDataSource,PWRefreshBaseTableViewDelegate,UIScrollViewDelegate,PIEShareViewDelegate,JGActionSheetDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,SwipeViewDelegate,SwipeViewDataSource>
@property (nonatomic, strong) PIEEliteScrollView *sv;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *sourceFollow;
@property (nonatomic, strong) NSMutableArray *sourceHot;
@property (nonatomic, strong) NSMutableArray *sourceBanner;

@property (nonatomic, assign) BOOL isfirstLoadingFollow;
@property (nonatomic, assign) BOOL isfirstLoadingHot;

@property (nonatomic, assign) NSInteger currentIndex_follow;
@property (nonatomic, assign) NSInteger currentIndex_hot;

@property (nonatomic, assign) BOOL canRefreshFooterFollow;
@property (nonatomic, assign) BOOL canRefreshFooterHot;

@property (nonatomic, assign)  long long timeStamp_follow;
@property (nonatomic, assign)  long long timeStamp_hot;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) PIEPageVM *selectedVM;
@property (nonatomic, strong)  PIEActionSheet_PS * psActionSheet;
@property (nonatomic, strong)  PIEShareView * shareView;

@end

@implementation PIEEliteViewController

static  NSString* askIndentifier = @"PIEEliteFollowAskTableViewCell";
static  NSString* replyIndentifier = @"PIEEliteFollowReplyTableViewCell";

static  NSString* hotReplyIndentifier = @"PIEEliteHotReplyTableViewCell";
static  NSString* hotAskIndentifier = @"PIEEliteHotAskTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self createNavBar];
    [self configSubviews];
    
    [self getSourceIfEmpty_hot:nil];
    [self getSourceIfEmpty_banner];
}
-(PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
    }
    return _psActionSheet;
}

- (void)bindProgressView {
    _progressView = [MRNavigationBarProgressView progressViewForNavigationController:self.navigationController];
    _progressView.progressTintColor = [UIColor pieYellowColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.hidesBarsOnSwipe = YES;
    [self bindProgressView];
    //update status of like button
    [self updateStatus];
    //make it always visible when coming back to this vc from other vc.
    [self.sv.swipeView reloadData];
    [MobClick beginLogPageView:@"进入首页"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.hidesBarsOnSwipe = NO;

    [MobClick endLogPageView:@"离开首页"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_isfirstLoadingHot) {
        if (_sv.type == PIEPageTypeEliteHot) {
            [self getSourceIfEmpty_hot:nil];
        } else {
            [self getSourceIfEmpty_follow:nil];
        }
        [self getSourceIfEmpty_banner];
    }
}
- (void)updateStatus {
    if (_selectedIndexPath) {
        if (_sv.type == PIEPageTypeEliteFollow) {
            [_sv.tableFollow reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else if (_sv.type == PIEPageTypeEliteHot) {
            [_sv.tableHot reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
#pragma mark - init methods

- (void)configData {
    _canRefreshFooterFollow = YES;
    _canRefreshFooterHot = YES;

    _currentIndex_follow = 1;
    _currentIndex_hot = 1;
    
    _isfirstLoadingFollow = YES;
    _isfirstLoadingHot = YES;
    
    _sourceFollow = [NSMutableArray new];
    _sourceHot = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_Elite" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_Elite" object:nil];
}
- (void)configSubviews {
    self.view = self.sv;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configTableViewFollow];
    [self configTableViewHot];
    [self setupGestures];
}
- (void)configTableViewFollow {
    _sv.tableFollow.dataSource = self;
    _sv.tableFollow.delegate = self;
    _sv.tableFollow.psDelegate = self;
    _sv.tableFollow.emptyDataSetSource = self;
    _sv.tableFollow.emptyDataSetDelegate = self;
    _sv.tableFollow.estimatedRowHeight = SCREEN_WIDTH+155;
    _sv.tableFollow.rowHeight = UITableViewAutomaticDimension;
    UINib* nib2 = [UINib nibWithNibName:askIndentifier bundle:nil];
    [_sv.tableFollow registerNib:nib2 forCellReuseIdentifier:askIndentifier];
    UINib* nib3 = [UINib nibWithNibName:replyIndentifier bundle:nil];
    [_sv.tableFollow registerNib:nib3 forCellReuseIdentifier:replyIndentifier];
}
- (void)configTableViewHot {
    
    _sv.tableHot.dataSource = self;
    _sv.tableHot.delegate = self;
    _sv.tableHot.psDelegate = self;
    _sv.tableHot.emptyDataSetDelegate = self;
    _sv.tableHot.emptyDataSetSource = self;
    _sv.tableHot.estimatedRowHeight = SCREEN_WIDTH+225;
    _sv.tableHot.rowHeight = UITableViewAutomaticDimension;
    UINib* nib = [UINib nibWithNibName:hotReplyIndentifier bundle:nil];
    [_sv.tableHot registerNib:nib forCellReuseIdentifier:hotReplyIndentifier];
    UINib* nib2 = [UINib nibWithNibName:hotAskIndentifier bundle:nil];
    [_sv.tableHot registerNib:nib2 forCellReuseIdentifier:hotAskIndentifier];
    _sv.swipeView.dataSource = self;
    _sv.swipeView.delegate = self;

}
- (void)setupGestures {
    
    UITapGestureRecognizer* tapGestureFollow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFollow:)];
    [_sv.tableFollow addGestureRecognizer:tapGestureFollow];
    UITapGestureRecognizer* tapGestureHot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHot:)];
    [_sv.tableHot addGestureRecognizer:tapGestureHot];
    UILongPressGestureRecognizer* longPressGestureHot = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnHot:)];
    [_sv.tableHot addGestureRecognizer:longPressGestureHot];
    UILongPressGestureRecognizer* longPressGestureFollow = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnFollow:)];
    [_sv.tableFollow addGestureRecognizer:longPressGestureFollow];
    
}


- (void)createNavBar {
    self.navigationItem.titleView = self.segmentedControl;
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"pie_search"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barBackButtonItem;
    
}


- (void) search {
    [self.navigationController pushViewController:[PIESearchViewController new] animated:YES];
}
- (void)refreshHeader {
    if (_sv.type == PIEPageTypeEliteFollow && !_sv.tableFollow.mj_header.isRefreshing) {
        [_sv.tableFollow.mj_header beginRefreshing];
    } else if (_sv.type == PIEPageTypeEliteHot && !_sv.tableHot.mj_header.isRefreshing) {
        [_sv.tableHot.mj_header beginRefreshing];
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
#pragma mark iCarousel methods


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return _sourceBanner.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        CGFloat width = _sv.swipeView.frame.size.width;
        CGFloat height = _sv.swipeView.frame.size.height;
        
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
    ;
    return view;
}
-(void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    _sv.pageControl_swipeView.currentPage = swipeView.currentItemIndex;
}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    PIEWebViewViewController* vc = [PIEWebViewViewController new];
    vc.viewModel = [_sourceBanner objectAtIndex:index];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tapPageControl:(SMPageControl *)sender
{
    [self.sv.swipeView scrollToItemAtIndex:sender.currentPage duration:0.5];
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
    } else if (tableView == _sv.tableHot) {
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
    return nil;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == _sv.tableFollow) {
//        PIEPageVM* vm = [_sourceFollow objectAtIndex:indexPath.row];
//        if (vm.type == PIEPageTypeAsk) {
//            return [tableView fd_heightForCellWithIdentifier:askIndentifier  cacheByIndexPath:indexPath configuration:^(PIEEliteFollowAskTableViewCell *cell) {
//                [cell injectSauce:[_sourceFollow objectAtIndex:indexPath.row]];
//            }];
//
//        }
//        else {
//            return [tableView fd_heightForCellWithIdentifier:replyIndentifier  cacheByIndexPath:indexPath configuration:^(PIEEliteFollowReplyTableViewCell *cell) {
//                [cell injectSauce:[_sourceFollow objectAtIndex:indexPath.row]];
//            }];
//        }
//    } else if (tableView == _sv.tableHot) {
//        PIEPageVM* vm = [_sourceHot objectAtIndex:indexPath.row];
//        if (vm.type == PIEPageTypeAsk) {
//            return [tableView fd_heightForCellWithIdentifier:hotAskIndentifier  cacheByIndexPath:indexPath configuration:^(PIEEliteHotAskTableViewCell *cell) {
//                [cell injectSauce:[_sourceHot objectAtIndex:indexPath.row]];
//            }];
//            
//        }
//        else {
//            return [tableView fd_heightForCellWithIdentifier:hotReplyIndentifier  cacheByIndexPath:indexPath configuration:^(PIEEliteHotReplyTableViewCell *cell) {
//                [cell injectSauce:[_sourceHot objectAtIndex:indexPath.row]];
//            }];
//        }
//
//    } else {
//        return 0;
//    }
//}
//



- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
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
-(void)collect:(PIEPageButton*) collectView shouldShowHud:(BOOL)shouldShowHud {
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

-(void)collectAsk {
    NSMutableDictionary *param = [NSMutableDictionary new];
    _selectedVM.collected = !_selectedVM.collected;
    if (_selectedVM.collected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:_selectedVM.type withID:_selectedVM.ID withBlock:^(NSError *error) {
        if (!error) {
            if (  _selectedVM.collected) {
                [Hud textWithLightBackground:@"收藏成功"];
            } else {
                [Hud textWithLightBackground:@"取消收藏成功"];
            }
        }   else {
            _selectedVM.collected = !_selectedVM.collected;
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


#pragma mark - ATOMShareViewDelegate

- (void)updateShareStatus {
    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    if (_selectedIndexPath) {
        if (_sv.type == PIEPageTypeEliteFollow) {
            [_sv.tableFollow reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            [_sv.tableHot reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }

}
- (void)shareViewDidShare:(PIEShareView *)shareView socialShareType:(ATOMShareType)shareType
{
    [DDShareManager postSocialShare2:_selectedVM
                 withSocialShareType:shareType
                               block:^(BOOL success) {
                                   [self updateShareStatus];
                               }];
}


- (void)shareViewDidPaste:(PIEShareView *)shareView
{

}

- (void)shareViewDidReportUnusualUsage:(PIEShareView *)shareView
{
}

- (void)shareViewDidCollect:(PIEShareView *)shareView
{
    
    
    // 下面是直接copy -tapShare8 的代码 = =
//    if (_sv.type == PIEPageTypeEliteHot) {
//        if (_selectedVM.type == PIEPageTypeAsk) {
//            [self collectAsk];
//        } else {
//            PIEEliteHotReplyTableViewCell* cell = [_sv.tableHot cellForRowAtIndexPath:_selectedIndexPath];
//            [self collect:cell.collectView shouldShowHud:YES];
//        }
//    } else {
//        if (_selectedVM.type == PIEPageTypeAsk) {
//            [self collectAsk];
//        } else {
//            PIEEliteFollowReplyTableViewCell* cell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
//            [self collect:cell.collectView shouldShowHud:YES];
//        }
//    }
//    // !!! BUG AWARE!!! TO-BE-REFACTORED 这里不能用shareView集成的collect方法来准确判断修改selected
//    //                                   的时机。只能这样凑合。
//    self.shareView.sheetView.icon8.selected = !self.shareView.sheetView.icon8.selected;
//
}

// 下面这块要怎么重构呢？为什么会出现一个不一样的收藏PageVM的逻辑……
-(void)tapShare8 {
//    if (_sv.type == PIEPageTypeEliteHot) {
//        if (_selectedVM.type == PIEPageTypeAsk) {
//            [self collectAsk];
//        } else {
//            PIEEliteHotReplyTableViewCell* cell = [_sv.tableHot cellForRowAtIndexPath:_selectedIndexPath];
//            [self collect:cell.collectView shouldShowHud:YES];
//        }
//    } else {
//        if (_selectedVM.type == PIEPageTypeAsk) {
//            [self collectAsk];
//        } else {
//            PIEEliteFollowReplyTableViewCell* cell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
//            [self collect:cell.collectView shouldShowHud:YES];
//        }
//    }

}

- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}


#pragma mark - getDataSource
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
        _sv.pageControl_swipeView.numberOfPages = _sourceBanner.count;
        [self.sv.swipeView reloadData];
    }];
}
- (void)getRemoteSourceFollow {
    WS(ws);
    [ws.sv.tableFollow.mj_footer endRefreshing];
    _currentIndex_follow = 1;
    _timeStamp_follow = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_follow) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH*2) forKey:@"width"];
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
        [ws.sv.tableFollow.mj_header endRefreshing];
        [ws.sv.tableFollow reloadData];
    }];
}

- (void)getMoreRemoteSourceFollow {
    WS(ws);
    [ws.sv.tableFollow.mj_header endRefreshing];
    _currentIndex_follow++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_follow) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH*2) forKey:@"width"];
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
        [ws.sv.tableFollow reloadData];
        [ws.sv.tableFollow.mj_footer endRefreshing];
    }];
}

- (void)getSourceIfEmpty_banner {
    if (_sourceBanner.count <= 0) {
        [self getRemoteSourceBanner];
    }
}

- (void)getSourceIfEmpty_hot:(void (^)(BOOL finished))block {
    if (_isfirstLoadingHot || _sourceHot.count <= 0) {
        [_sv.tableFollow.mj_header endRefreshing];
        [_sv.tableHot.mj_header beginRefreshing];
    }
}
- (void)getSourceIfEmpty_follow:(void (^)(BOOL finished))block {
    if (_isfirstLoadingFollow || _sourceFollow.count <= 0) {
        [_sv.tableHot.mj_header endRefreshing];
        [_sv.tableFollow.mj_header beginRefreshing];
    }
}

- (void)getRemoteSourceHot:(void (^)(BOOL finished))block {
    WS(ws);
    [ws.sv.tableHot.mj_footer endRefreshing];
    _currentIndex_hot = 1;
    _timeStamp_hot = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_hot) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH*2) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(8) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        ws.isfirstLoadingHot = NO;
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            [ws.sourceHot removeAllObjects];
            [ws.sourceHot addObjectsFromArray:returnArray];
        }
        [ws.sv.tableHot reloadData];
        [ws.sv.tableHot.mj_header endRefreshing];
        if (block) {
            block(YES);
        }
    }];
}
- (void)getMoreRemoteSourceHot {
    WS(ws);
    [ws.sv.tableHot.mj_header endRefreshing];
    _currentIndex_hot ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_hot) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH*2) forKey:@"width"];
    [param setObject:@(_currentIndex_hot) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            [ws.sourceHot addObjectsFromArray:returnArray];
        }
        [ws.sv.tableHot reloadData];
        [ws.sv.tableHot.mj_footer endRefreshing];
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
            [_sv.tableFollow.mj_footer endRefreshingWithNoMoreData];
        }
    } else {
        if (_canRefreshFooterHot) {
            [self getMoreRemoteSourceHot];
        } else {
            [_sv.tableHot.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _sv) {
        int currentPage = (scrollView.contentOffset.x + CGWidth(scrollView.frame) * 0.1) / CGWidth(scrollView.frame);
        if (currentPage == 0) {
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
            _sv.type = PIEPageTypeEliteHot;
            [self getSourceIfEmpty_hot:nil];
        } else if (currentPage == 1) {
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            _sv.type = PIEPageTypeEliteFollow;
            [self getSourceIfEmpty_follow:nil];
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




#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text ;
    if (scrollView == _sv.tableHot) {
        text = @"好伤心，再下拉刷新试试";
    } else if (scrollView == _sv.tableFollow) {
        text = @"赶快去关注些大神吧";
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (scrollView == _sv.tableHot) {
        return !_isfirstLoadingHot;
    } else if (scrollView == _sv.tableFollow) {
        return !_isfirstLoadingFollow;
    }
    return NO;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 100;
}
#pragma mark - Gesture Event

- (void)longPressOnFollow:(UILongPressGestureRecognizer *)gesture {
    if (_sv.type == PIEPageTypeEliteFollow) {
        CGPoint location = [gesture locationInView:_sv.tableFollow];
        _selectedIndexPath = [_sv.tableFollow indexPathForRowAtPoint:location];
        _selectedVM = _sourceFollow[_selectedIndexPath.row];
        if (_selectedIndexPath) {
            //关注  求p
            _selectedVM = _sourceFollow[_selectedIndexPath.row];
            
            if (_selectedVM.type == PIEPageTypeAsk) {
                
                PIEEliteFollowAskTableViewCell* cell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
                CGPoint p = [gesture locationInView:cell];
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    //进入热门详情
                    [self showShareView:_selectedVM];
                }
            }
            
            //关注  作品
            else {
                PIEEliteFollowReplyTableViewCell* cell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
                CGPoint p = [gesture locationInView:cell];
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    [self showShareView:_selectedVM];
                }
            }
        }
    }
}
- (void)tapGestureFollow:(UITapGestureRecognizer *)gesture {
    if (_sv.type == PIEPageTypeEliteFollow) {
        CGPoint location = [gesture locationInView:_sv.tableFollow];
        _selectedIndexPath = [_sv.tableFollow indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            //关注  求p
            _selectedVM = _sourceFollow[_selectedIndexPath.row];
            
            if (_selectedVM.type == PIEPageTypeAsk) {
                
                PIEEliteFollowAskTableViewCell* cell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
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
                PIEEliteFollowReplyTableViewCell* cell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
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
}
- (void)longPressOnHot:(UILongPressGestureRecognizer *)gesture {
    if (_sv.type == PIEPageTypeEliteHot) {
        CGPoint location = [gesture locationInView:_sv.tableHot];
        _selectedIndexPath = [_sv.tableHot indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            //关注  求p
            _selectedVM = _sourceHot[_selectedIndexPath.row];
            
            if (_selectedVM.type == PIEPageTypeAsk) {
                
                PIEEliteHotAskTableViewCell* cell = [_sv.tableHot cellForRowAtIndexPath:_selectedIndexPath];
                CGPoint p = [gesture locationInView:cell];
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    [self showShareView:_selectedVM];
                }
            }
            //关注  作品
            
            else {
                PIEEliteHotReplyTableViewCell* cell = [_sv.tableHot cellForRowAtIndexPath:_selectedIndexPath];
                CGPoint p = [gesture locationInView:cell];
                //点击大图
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    [self showShareView:_selectedVM];
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
                
                PIEEliteHotAskTableViewCell* cell = [_sv.tableHot cellForRowAtIndexPath:_selectedIndexPath];
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
}

-(HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        WS(ws);
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"热门",@"关注"]];
        _segmentedControl.frame = CGRectMake(0, 120, 200, 45);
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.6], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (index == 0) {
                [ws.sv toggleWithType:PIEPageTypeEliteHot];
                [ws getSourceIfEmpty_hot:nil];
            }
            else {
                [ws.sv toggleWithType:PIEPageTypeEliteFollow];
                [ws getSourceIfEmpty_follow:nil];
            }
        }];
        
    }
    return _segmentedControl;
}

@end
