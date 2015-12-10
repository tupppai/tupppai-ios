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

/* Variables */
@interface PIEChannelDetailViewController ()
@property (nonatomic, strong) PIERefreshTableView           *tableView;
@property (nonatomic, strong) UIButton                      *takePhotoButton;

/** 该频道内最新求P */
@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *latestAskForPSSource;
/** 该频道内的用户PS作品 */
@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *usersPSSource;

/**  timeStamp: 刷新数据的时候的时间（整数10位）*/
@property (nonatomic, assign) long long                     timeStamp;

@property (nonatomic, strong) SwipeView *swipeView;

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
    
    /* UI components setup */
//    [self tableView];
//    [self takePhotoButton];
    
    /* setup source data */
    [self setupData];
    
    /* added as subviews & add autolayout constraints */
    [self configureTableView];
    [self configureTakePhotoButton];
    
    self.title = @"用PS搞创意";
    
    // pullToRefresh for the first time
    [self.tableView.mj_header beginRefreshing];
    
    
}

#pragma mark - <UITableViewDelegate>



#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s", __func__);

    return self.usersPSSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);

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
    NSLog(@"%s", __func__);

    [self loadMorePageViewModels];
}

/**
 *  下拉刷新
*/
- (void)didPullRefreshDown:(UITableView *)tableView
{
    NSLog(@"%s", __func__);

    [self loadNewPageViewModels];
}

#pragma mark - <SwipeViewDelegate>
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    NSLog(@"%s", __func__);

    
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
        view =
        [[NSBundle mainBundle] loadNibNamed:@"PIEChannelDetailAskPSItemView"
                                             owner:self options:nil][0];
    }
    
    // viewModel -> view
    NSURL *imageURL = [NSURL URLWithString:_latestAskForPSSource[index].imageURL];
    [view.imageView setImageWithURL:imageURL
                   placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    view.desc.text = _latestAskForPSSource[index].content;
    
    
    return view;
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
    params[@"channel_id"] = @(self.selectedChannelViewModel.ID);
    params[@"page"] = @(2);
    params[@"size"] = @(20);
    
    // --- Double -> Long long int
    _timeStamp = @([[NSDate date] timeIntervalSince1970]);
    params[@"last_updated"] = @(_timeStamp);
    
    __weak typeof(self) weakSelf = self;
    
    [PIEChannelManager
     getSource_pageViewModels:params
     latestAskForPSBlock:^(NSMutableArray<PIEPageVM *> *latestAskForPSResultArray) {
         [_latestAskForPSSource addObjectsFromArray:latestAskForPSResultArray];
     }
     usersPSBlock:^(NSMutableArray<PIEPageVM *> *usersPSResultArray) {
         [_usersPSSource addObjectsFromArray:usersPSResultArray];
     }
     completion:^{
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [weakSelf.tableView.mj_footer endRefreshing];
         }];
         [weakSelf.tableView reloadData];
         //             [weakSelf.swipeView reloadData];
         
     }];
}


- (void)loadNewPageViewModels
{
    NSLog(@"%s", __func__);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel_id"]       = @(self.selectedChannelViewModel.ID);
    params[@"page"]             = @(1);
    params[@"size"]             = @(20);
    
    // --- Double -> Long long int
    _timeStamp                  = @([[NSDate date] timeIntervalSince1970]);
    params[@"last_updated"]     = @(_timeStamp);
    
    __weak typeof(self) weakSelf = self;
    [PIEChannelManager
     getSource_pageViewModels:params
     latestAskForPSBlock:^(NSMutableArray<PIEPageVM *> *latestAskForPSResultArray)
     {
         
         [_latestAskForPSSource removeAllObjects];
         [_latestAskForPSSource addObjectsFromArray:latestAskForPSResultArray];
     }
     usersPSBlock:^(NSMutableArray<PIEPageVM *> *usersPSResultArray)
     {
         [_usersPSSource removeAllObjects];
         [_usersPSSource addObjectsFromArray:usersPSResultArray];
     }
     completion:^{
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             
             [weakSelf.tableView.mj_header endRefreshing];
             
             [weakSelf.tableView reloadData];
             
             //!!! is weakSelf.swipeView non-nil?
             [weakSelf.swipeView reloadData];
         }];
     }
     ];
}

#pragma mark - Target-actions
- (void)takePhoto:(UIButton *)button
{
    NSLog(@"%s", __func__);
    
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
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-64);
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
        [_takePhotoButton setBackgroundImage:[UIImage imageNamed:@"pie_signup_close"]
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




@end
