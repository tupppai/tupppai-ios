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
#import "DeviceUtil.h"
#import "PIECellIconStatusChangedNotificationKey.h"
#import "PIEPageManager.h"
/* Variables */
@interface PIEChannelDetailViewController ()
@property (nonatomic, strong) PIERefreshTableView           *tableView;
@property (nonatomic, strong) UIButton                      *takePhotoButton;

/** 该频道内最新求P */
@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *source_ask;
/** 该频道内的用户PS作品 */
@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *source_reply;

/** timeStamp: 刷新数据的时候的时间（整数10位）*/
@property (nonatomic, assign) long long                     timeStamp;
@property (nonatomic, assign) NSInteger                     currentPage_Reply;

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

@property (nonatomic, strong) MASConstraint *takePhotoButtonConstraint;

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
    
    /* setup NSNotificationCenter observer */
    [self setupNotificationObserver];
    
    /* added as subviews & add autolayout constraints */
    [self configureTableView];
    [self configureTakePhotoButton];
    
    /* 设置可以区分reply cell中不同UI元素（头像，关注按钮，分享, etc.）的点击事件回调 */
    [self setupGestures];
    
    self.title = self.currentChannelViewModel.title;
    
    [self getSource_Ask];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PIESharedIconStatusChangedNotification
                                                  object:nil];
}

#pragma mark - NSNotification Observer Setup
- (void)setupNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateShareStatus)
                                                 name:PIESharedIconStatusChangedNotification
                                               object:nil];
}

#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self.takePhotoButtonConstraint setOffset:50.0];
                         [self.takePhotoButton layoutIfNeeded];
                     }];
    
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.takePhotoButtonConstraint setOffset:-12];
    [UIView animateWithDuration:0.2
                          delay:1.0
         usingSpringWithDamping:0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                     }];

}




#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.source_reply.count;
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
        
        [cell injectSauce:_source_reply[indexPath.row]];
        
        return cell;
    }
    
}

#pragma mark - <PWRefreshBaseTableViewDelegate>

/**
 *  上拉加载
 */
- (void)didPullRefreshUp:(UITableView *)tableView
{
    
    [self getMoreSource_Reply];
}

/**
 *  下拉刷新
 */
- (void)didPullRefreshDown:(UITableView *)tableView
{
    
    [self getSource_Reply];
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
    
    
    return self.source_ask.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView
   viewForItemAtIndex:(NSInteger)index
          reusingView:(PIEChannelDetailAskPSItemView *)view
{
    
    if (view == nil)
    {
        NSInteger height = swipeView.frame.size.height;
        view = [[PIEChannelDetailAskPSItemView alloc]initWithFrame:CGRectMake(0, 0, height, height)];
    }
    
    NSString* urlString = [_source_ask[index].imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION*0.25];
    NSURL *imageURL = [NSURL URLWithString:urlString];
    [view.imageView sd_setImageWithURL:imageURL
                      placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    view.label.text = _source_ask[index].content;
    
    return view;
}


#pragma mark - <PIEShareViewDelegate> and related methods

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


- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
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
    
    
    
    CGPoint location = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if (_selectedIndexPath.row == 0) {
        PIENewAskMakeUpViewController* vc = [PIENewAskMakeUpViewController new];
        vc.channelVM = _currentChannelViewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if (_selectedIndexPath) {
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM = self.source_reply[_selectedIndexPath.row];
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
//            [PIEPageManager love:_selectedReplyCell.likeView viewModel:_selectedVM revert:NO];
            [_selectedVM love:NO];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.followView.frame, p)) {
            [self followReplier];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.shareView.frame, p)) {
            [self showShareView:_selectedVM];
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
    
    
    
    CGPoint location   = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM        = self.source_reply[_selectedIndexPath.row];
        CGPoint p          = [gesture locationInView:_selectedReplyCell];
        
        //点击大图
        if (CGRectContainsPoint(_selectedReplyCell.theImageView.frame, p)) {
            [self showShareView:_selectedVM];
        }        else if (CGRectContainsPoint(_selectedReplyCell.likeView.frame, p)) {
//            [PIEPageManager love:_selectedReplyCell.likeView viewModel:_selectedVM revert:YES];
            [_selectedVM love:YES];
        }

    }
    
    
}

#pragma mark - reply cell 中的点击事件：喜欢该P图，关注P图主。


/**
 *  关注这张P图的P图主
 */
-(void)followReplier {
    
    
    
    
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
            
            [Hud text:@"网络异常，请稍后重试"];
        }
        
        if (_selectedReplyCell.followView.highlighted) {
            [Hud text:@"关注成功"];
        }else{
            [Hud text:@"已取消关注"];
        }
    }];
}






#pragma mark - data first setup
- (void)setupData
{
    _source_reply        = [NSMutableArray<PIEPageVM *> array];
    _source_ask = [NSMutableArray<PIEPageVM *> array];
}


/**
 *  what the hell is this?
 */
- (void)getSource_Ask {
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"category_id"]        = @(self.currentChannelViewModel.ID);
    params[@"page"]              = @(1);
    params[@"size"]              = @(10);
    params[@"type"]              = @"ask";
    [params setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    
    [PIEChannelManager getSource_channelPages:params resultBlock:^(NSMutableArray<PIEPageVM *> *pageArray) {
        [_source_ask removeAllObjects];
        [_source_ask addObjectsFromArray:pageArray];
    } completion:^{
        [self.swipeView reloadData];
        
    }];
}
- (void)getSource_Reply {
    WS(ws);
    _currentPage_Reply = 1;
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"category_id"]        = @(self.currentChannelViewModel.ID);
    params[@"page"]              = @(1);
    params[@"size"]              = @(20);
    params[@"type"]              = @"reply";
    _timeStamp                   = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]      = @(_timeStamp);
    [params setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    
    [PIEChannelManager getSource_channelPages:params resultBlock:^(NSMutableArray<PIEPageVM *> *pageArray) {
        [_source_reply removeAllObjects];
        [_source_reply addObjectsFromArray:pageArray];
    } completion:^{
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView reloadData];
    }];
}
- (void)getMoreSource_Reply {
    WS(ws);
    _currentPage_Reply++;
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"category_id"]        = @(self.currentChannelViewModel.ID);
    params[@"page"]              = @(_currentPage_Reply);
    params[@"size"]              = @(20);
    params[@"type"]              = @"reply";
    params[@"last_updated"]      = @(_timeStamp);
    [params setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [PIEChannelManager getSource_channelPages:params resultBlock:^(NSMutableArray<PIEPageVM *> *pageArray) {
        [_source_reply addObjectsFromArray:pageArray];
    } completion:^{
        [ws.tableView.mj_footer endRefreshing];
        [ws.tableView reloadData];
    }];
}

#pragma mark - Notification methods

/**
 *  用户点击了updateShareStatus之后（在弹出的窗口完成分享），刷新本页面的分享数（UI元素的同步）
 */
- (void)updateShareStatus {
    
    /*
     _vm.shareCount ++ 这个副作用集中发生在PIEShareView之中。
     
     */
    //    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    
    //    [self updateStatus]; 将刷新UI的这个方法挪到这里来
    if (_selectedIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
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
        self.takePhotoButtonConstraint =
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-12);
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
