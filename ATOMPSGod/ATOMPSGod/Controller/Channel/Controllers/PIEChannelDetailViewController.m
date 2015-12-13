//
//  PIEChannelDetailViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/8.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelDetailViewController.h"
#import "PIERefreshTableView.h"
#import "PIEChannelDetailLatestPSCell.h"
#import "SwipeView.h"
#import "PIEChannelDetailAskPSItemView.h"
#import "PIEChannelManager.h"

#import "PIEChannelViewModel.h"
#import "PIENewReplyTableCell.h"
#import "PIEShareView.h"
#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"
#import "PIECommentViewController.h"
#import "PIEReplyCollectionViewController.h"
#import "DDCollectManager.h"
#import "PIECameraViewController.h"
#import "PIENewAskMakeUpViewController.h"
/* Variables */
@interface PIEChannelDetailViewController ()
@property (nonatomic, strong) PIERefreshTableView           *tableView;
@property (nonatomic, strong) UIButton                      *takePhotoButton;

/** 该频道内最新求P */
@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *latestAskForPSSource;
/** 该频道内的用户PS作品 */
@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *usersPSSource;

/** timeStamp: 刷新数据的时候的时间（整数10位）*/
@property (nonatomic, assign) long long                     timeStamp;

/** 最新求P中的swipeView */
@property (nonatomic, strong) SwipeView *swipeView;

/** 点击弹出的分享页面 */
@property (nonatomic, strong) PIEShareView *shareView;

/** 用户选中的图片 */
@property (nonatomic, strong) PIEPageVM *selectedVM;

/** 用户点击的Cell的indexPath */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

/** 用户当前点击的Cell */
@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;

@end

/* Protocols */

@interface PIEChannelDetailViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIEChannelDetailViewController (PIERefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEChannelDetailViewController (SwipeView)
<SwipeViewDelegate, SwipeViewDataSource>
@end

@interface PIEChannelDetailViewController (SharingDelegate)
<PIEShareViewDelegate>
@end


@implementation PIEChannelDetailViewController

static NSString *  PIEDetailLatestPSCellIdentifier =
@"DetailLatestPSCellIdentifier";

static NSString *  PIEDetailNormalIdentifier =
@"PIEDetailNormalIdentifier";

static NSString * PIEDetailUsersPSCellIdentifier =
@"PIENewReplyTableCell";

#pragma mark - UI life cycles
/**
 *  不能直接用self.tableView替换掉self.view，而是让self.tableView和self.takePhotoButton
 同时成为self.view的子视图。
 */
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* setup source data */
    [self setupData];
    
    /* added as subviews & add autolayout constraints */
    [self configureTableView];
    [self configureTakePhotoButton];
    
    /* 设置可以区分reply cell中不同UI元素（头像，关注按钮，分享, etc.）的点击事件回调 */
    [self setupGestures];

    self.title = @"用PS搞创意";
    
    // pullDownToRefresh for the first time
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - <UITableViewDelegate>



#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.usersPSSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0)
    {
        /* first row */
        PIEChannelDetailLatestPSCell *detailLatestPSCell =
        [tableView dequeueReusableCellWithIdentifier:PIEDetailLatestPSCellIdentifier];
        
        // configure cell
        
        // --- set delegate & dataSource
        detailLatestPSCell.swipeView.delegate   = self;
        detailLatestPSCell.swipeView.dataSource = self;
        
        // ??? 实在是想不到更好地方法了。。。 (BUG AWARE!)
        self.swipeView = detailLatestPSCell.swipeView;
        return detailLatestPSCell;
    }
    else
    {
        PIENewReplyTableCell *cell =
        [tableView dequeueReusableCellWithIdentifier:PIEDetailUsersPSCellIdentifier];
        
        [cell injectSauce:_usersPSSource[indexPath.row]];
        
        return cell;
    }
    
}

#pragma mark - <PWRefreshBaseTableViewDelegate>

/**
 *  上拉加载
*/
- (void)didPullRefreshUp:(UITableView *)tableView
{

    [self loadMorePageViewModels];
}

/**
 *  下拉刷新
*/
- (void)didPullRefreshDown:(UITableView *)tableView
{

    [self loadNewPageViewModels];
}

#pragma mark - <SwipeViewDelegate>
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    
    CGFloat screenWidth         = [UIScreen mainScreen].bounds.size.width;
    CGFloat swipeViewItemWidth  = screenWidth * (180.0 / 750.0);
    CGFloat swipeViewItemHeight = screenWidth * (214.0 / 750.0);
    return CGSizeMake(swipeViewItemWidth, swipeViewItemHeight);
}

#pragma mark - <SwipeViewDataSource>
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    NSLog(@"%s", __func__);

    return self.latestAskForPSSource.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView
   viewForItemAtIndex:(NSInteger)index
          reusingView:(PIEChannelDetailAskPSItemView *)view
{
    NSLog(@"%s", __func__);

    if (view == nil)
    {
        NSInteger height = swipeView.frame.size.height;
        view = [[PIEChannelDetailAskPSItemView alloc]initWithFrame:CGRectMake(0, 0, height, height)];
    }
    
    // viewModel -> view
    NSURL *imageURL = [NSURL URLWithString:_latestAskForPSSource[index].imageURL];
    [view.imageView setImageWithURL:imageURL
                   placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    view.label.text = _latestAskForPSSource[index].content;
    
    return view;
}


#pragma mark - Sharing-related method
#pragma mark - methods on Sharing<ATOMShareViewDelegate>
- (void)updateShareStatus {
    
    /**
     *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面的点赞数和分享数（两个页面的UI元素的同步）
     */
    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    [self updateStatus];
}

- (void)showShareView {
    [self.shareView show];
    
}

/**
 *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面的点赞数和分享数
 */
- (void)updateStatus {
    if (_selectedIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Gesture Event - 识别PIENewReplyCell中的不同元素(头像，关注按钮，etc.)的点击事件

- (void)setupGestures {
    UITapGestureRecognizer* tapGestureReply =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnReply:)];
    UILongPressGestureRecognizer* longPressGestureReply =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnReply:)];
    [self.tableView addGestureRecognizer:longPressGestureReply];
    [self.tableView addGestureRecognizer:tapGestureReply];
    
}

- (void)tapOnReply:(UITapGestureRecognizer *)gesture {
    
    PIELog(@"%s", __func__);

    CGPoint location = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if (_selectedIndexPath.row == 0) {
        PIENewAskMakeUpViewController* vc = [PIENewAskMakeUpViewController new];
        vc.channelVM = _currentChannelViewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if (_selectedIndexPath) {
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM = self.usersPSSource[_selectedIndexPath.row];
        CGPoint p = [gesture locationInView:_selectedReplyCell];
        
        //点击小图
        if (CGRectContainsPoint(_selectedReplyCell.thumbView.frame, p)) {
            CGPoint pp = [gesture locationInView:_selectedReplyCell.thumbView];
            if (CGRectContainsPoint(_selectedReplyCell.thumbView.leftView.frame,pp)) {
                [_selectedReplyCell animateThumbScale:PIEAnimateViewTypeLeft];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.thumbView.rightView.frame,pp)) {
                [_selectedReplyCell animateThumbScale:PIEAnimateViewTypeRight];
            }
        }
        //点击大图
        else  if (CGRectContainsPoint(_selectedReplyCell.theImageView.frame, p)) {
            //进入热门详情
            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
            _selectedVM.image = _selectedReplyCell.theImageView.image;
            vc.pageVM = _selectedVM;
            [self presentViewController:vc animated:YES completion:nil];
            //                [self.navigationController pushViewController:vc animated:YES];
        }
        //点击头像
        else if (CGRectContainsPoint(_selectedReplyCell.avatarView.frame, p)) {
            PIEFriendViewController * friendVC = [PIEFriendViewController new];
            friendVC.pageVM = _selectedVM;
            [self.navigationController pushViewController:friendVC animated:YES];
        }
        //点击用户名
        else if (CGRectContainsPoint(_selectedReplyCell.nameLabel.frame, p)) {
            PIEFriendViewController * friendVC = [PIEFriendViewController new];
            friendVC.pageVM = _selectedVM;
            [self.navigationController pushViewController:friendVC animated:YES];
        }
        //            else if (CGRectContainsPoint(_selectedReplyCell.collectView.frame, p)) {
        //                //should write this logic in viewModel
        ////                [self collect:_selectedReplyCell.collectView shouldShowHud:NO];
        //                [self collect];
        //            }
        else if (CGRectContainsPoint(_selectedReplyCell.likeView.frame, p)) {
            [self likeReply];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.followView.frame, p)) {
            [self followReplier];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.shareView.frame, p)) {
            [self showShareView];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.commentView.frame, p)) {
            PIECommentViewController* vc = [PIECommentViewController new];
            vc.vm = _selectedVM;
            vc.shouldShowHeaderView = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.allWorkView.frame, p)) {
            PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
            vc.pageVM = _selectedVM;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
- (void)longPressOnReply:(UILongPressGestureRecognizer *)gesture {
    
    PIELog(@"%s", __func__);
    
    CGPoint location   = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM        = self.usersPSSource[_selectedIndexPath.row];
        CGPoint p          = [gesture locationInView:_selectedReplyCell];
        
        //点击大图
        if (CGRectContainsPoint(_selectedReplyCell.theImageView.frame, p)) {
            [self showShareView];
        }
    }
    
    
}

#pragma mark - reply cell 中的点击事件：喜欢该P图，关注P图主。

/**
 *  点击事件： 喜欢这张P图
 */
-(void)likeReply {
    
    PIELog(@"%s", __func__);

    
    _selectedReplyCell.likeView.selected = !_selectedReplyCell.likeView.selected;
    [DDService toggleLike:_selectedReplyCell.likeView.selected ID:_selectedVM.ID type:_selectedVM.type  withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.liked = _selectedReplyCell.likeView.selected;
            if (_selectedReplyCell.likeView.selected) {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue + 1];
            } else {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue - 1];
            }
        } else {
            _selectedReplyCell.likeView.selected = !_selectedReplyCell.likeView.selected;
        }
    }];
}

/**
 *  关注这张P图的P图主
 */
-(void)followReplier {
    
    PIELog(@"%s", __func__);

    
    _selectedReplyCell.followView.highlighted = !_selectedReplyCell.followView.highlighted;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_selectedVM.userID) forKey:@"uid"];
    if (_selectedReplyCell.followView.highlighted) {
        [param setObject:@1 forKey:@"status"];
    }
    else {
        [param setObject:@0 forKey:@"status"];
    }
    [DDService follow:param withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.followed = _selectedReplyCell.followView.highlighted;
        } else {
            _selectedReplyCell.followView.highlighted = !_selectedReplyCell.followView.highlighted;
        }
    }];
}

#pragma mark - <PIEShareViewDelegate>
/*
    以下代理方法在用户点击了shareView中的8个button的其中一个（分享到新浪，微信，微博，etc.) 的时候被调用
 */

//sina
-(void)tapShare1 {
    PIELog(@"%s", __func__);

    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeSinaWeibo block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//qqzone
-(void)tapShare2 {
    PIELog(@"%s", __func__);

    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQZone block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//wechat moments
-(void)tapShare3 {
    PIELog(@"%s", __func__);

    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatMoments block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//wechat friends
-(void)tapShare4 {
    PIELog(@"%s", __func__);

    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatFriends block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
-(void)tapShare5 {
    PIELog(@"%s", __func__);

    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQFriends block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
    
}

-(void)tapShare6 {
    PIELog(@"%s", __func__);

    [DDShareManager copy:_selectedVM];
}
-(void)tapShare7 {
    PIELog(@"%s", __func__);

    
    self.shareView.vm = _selectedVM;
}
-(void)tapShare8 {
    PIELog(@"%s", __func__);

    
    //    if (_scrollView.type == PIENewScrollTypeAsk) {
    //        if (_selectedVM.type == PIEPageTypeAsk) {
    [self collect];
    //        }
    //    } else {
    //        if (_selectedVM.type == PIEPageTypeAsk) {
    //            [self collect];
    //        } else {
    //            PIENewReplyTableCell* cell = [_scrollView.tableReply cellForRowAtIndexPath:_selectedIndexPath];
    //            [self collect:cell.collectView shouldShowHud:YES];
    //        }
    //    }
    
}

-(void)tapShareCancel {
    PIELog(@"%s", __func__);

    [self.shareView dismiss];
}

#pragma mark - "收藏"相关操作， shareView中用户点击了"收藏"之后被调用
-(void)collect {
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



#pragma mark - data first setup
- (void)setupData
{
    _usersPSSource        = [NSMutableArray<PIEPageVM *> array];
    _latestAskForPSSource = [NSMutableArray<PIEPageVM *> array];
}

#pragma mark - Refresh methods
- (void)loadMorePageViewModels
{
    NSLog(@"%s", __func__);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel_id"] = @(self.currentChannelViewModel.ID);
    params[@"page"]       = @(2);
    params[@"size"]       = @(20);
    
    // --- Double -> Long long int
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"] = @(_timeStamp);
    
    __weak typeof(self) weakSelf = self;
    
    [PIEChannelManager
     getSource_pageViewModels:params
     resultBlock:^(NSMutableArray<PIEPageVM *> *latestAskForPSResultArray,
                   NSMutableArray<PIEPageVM *> *usersRepliesResultArray) {
         if (usersRepliesResultArray.count == 0) {
             [weakSelf.tableView.mj_footer endRefreshing];
         }
         else{
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [weakSelf.tableView reloadData];
                 [weakSelf.tableView.mj_footer endRefreshing];
             }];
         }
     }
     completion:^{
          // nothing.
     }];
    
}


- (void)loadNewPageViewModels
{
    NSLog(@"%s", __func__);
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"channel_id"]        = @(self.currentChannelViewModel.ID);
    params[@"page"]              = @(1);
    params[@"size"]              = @(20);

    // --- Double -> Long long int
    _timeStamp                   = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]      = @(_timeStamp);

    __weak typeof(self) weakSelf = self;
    [PIEChannelManager
     getSource_pageViewModels:params
     resultBlock:^(NSMutableArray<PIEPageVM *> *latestAskForPSResultArray,
                   NSMutableArray<PIEPageVM *> *usersRepliesResultArray) {
         if (usersRepliesResultArray.count != 0) {
             [_usersPSSource removeAllObjects];
             [_usersPSSource addObjectsFromArray:usersRepliesResultArray];
        
             [_latestAskForPSSource removeAllObjects];
             [_latestAskForPSSource addObjectsFromArray:latestAskForPSResultArray];
        }
     }completion:^{
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [weakSelf.tableView.mj_header endRefreshing];
             [weakSelf.tableView reloadData];
             
         }];
     }];
}

#pragma mark - Target-actions
- (void)takePhoto:(UIButton *)button
{
    PIECameraViewController *pvc = [PIECameraViewController new];
    pvc.blurStyle = UIBlurEffectStyleDark;
    pvc.channelVM = _currentChannelViewModel;
    [self presentViewController:pvc animated:YES completion:nil];
    
}
#pragma mark - UI components configuration
- (void)configureTableView
{
    // added as subview
    [self.view addSubview:self.tableView];
    
//    // add constraints
//    __weak typeof(self) weakSelf = self;
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.view);
//    }];
}

- (void)configureTakePhotoButton
{
    // --- added as subViews
    [self.view addSubview:self.takePhotoButton];
    // --- Autolayout constraints
    __weak typeof(self) weakSelf = self;
    [_takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-11);
    }];
}



#pragma mark - lazy loadings
- (PIERefreshTableView *)tableView
{
    if (_tableView == nil) {
        // instantiate only for once
        _tableView = [[PIERefreshTableView alloc] initWithFrame:self.view.bounds];
        
        // configurations
        
//        _tableView.frame = self.view.bounds;
        
        // set delegate
        _tableView.delegate   = self;
        
        _tableView.dataSource = self;
        
        _tableView.psDelegate = self;
        
        // iOS 8+, self-sizing cell
        _tableView.estimatedRowHeight = 400;
        
        _tableView.rowHeight          = UITableViewAutomaticDimension;
        
        // register cells
        [_tableView
         registerNib:[UINib nibWithNibName:@"PIEChannelDetailLatestPSCell" bundle:nil]
         forCellReuseIdentifier:PIEDetailLatestPSCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:@"PIENewReplyTableCell"
                                               bundle:nil]
         forCellReuseIdentifier:PIEDetailUsersPSCellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    }
    return _tableView;
}

- (UIButton *)takePhotoButton
{
    if (_takePhotoButton == nil) {
        // instantiate only for once
        _takePhotoButton = [[UIButton alloc] init];
        
        /* Configurations */
        
        // --- set background image
        [_takePhotoButton setBackgroundImage:[UIImage imageNamed:@"pie_channelDetailTakePhotoButton"]
              forState:UIControlStateNormal];
        
        // --- add drop shadows
        _takePhotoButton.layer.shadowColor  = (__bridge CGColorRef _Nullable)
        ([UIColor colorWithWhite:0.0 alpha:0.5]);
        _takePhotoButton.layer.shadowOffset = CGSizeMake(0, 4);
        _takePhotoButton.layer.shadowRadius = 8.0;
        
        // --- add target-actions
        [_takePhotoButton addTarget:self
                             action:@selector(takePhoto:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
    
}

- (PIEShareView *)shareView
{
    if (_shareView == nil) {
        // instantiate only for once
        _shareView = [[PIEShareView alloc] init];
        
        _shareView.delegate = self;
    }
    return  _shareView;

}


@end
