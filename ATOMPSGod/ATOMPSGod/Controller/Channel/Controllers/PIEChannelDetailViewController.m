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

/* Variables */
@interface PIEChannelDetailViewController ()
@property (nonatomic, strong)PIERefreshTableView *tableView;
@property (nonatomic, strong) UIButton *takePhotoButton;


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


#pragma mark - UI life cycles
/**
 *  不能直接用self.tableView替换掉self.view，而是让self.tableView和self.takePhotoButton
 同时成为self.view的子视图。
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* UI components setup */
    [self tableView];
    [self takePhotoButton];
    
    /* added as subviews & add autolayout constraints */
    [self configureTableView];
    [self configureTakePhotoButton];
    
    self.title = @"用PS搞创意";
    
}

#pragma mark - <UITableViewDelegate>


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
        
        return detailLatestPSCell;
    }
    else
    {
        UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:PIEDetailNormalIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"Cell-%zd", indexPath.row];
        return cell;
    }
}

#pragma mark - <PWRefreshBaseTableViewDelegate>

/**
 *  下拉刷新
*/
- (void)didPullRefreshUp:(UITableView *)tableView
{
    [self loadNewUserPSWorks];
}

/**
 *  上拉加载
*/
- (void)didPullRefreshDown:(UITableView *)tableView
{
    [self loadMoreUserPSWorks];
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
    return 10;
}

- (UIView *)swipeView:(SwipeView *)swipeView
   viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view =
        (PIEChannelDetailAskPSItemView *)
        [[NSBundle mainBundle] loadNibNamed:@"PIEChannelDetailAskPSItemView"
                                             owner:self options:nil][0];
    }
    
    return view;
}


#pragma mark - Refresh methods
- (void)loadMoreUserPSWorks
{
    NSLog(@"%s", __func__);
}


- (void)loadNewUserPSWorks
{
    NSLog(@"%s", __func__);
}

#pragma mark - Target-actions
- (void)takePhoto:(UIButton *)button
{
    NSLog(@"%s", __func__);
    
}


#pragma mark - lazy loadings
- (PIERefreshTableView *)tableView
{
    if (_tableView == nil) {
        // instantiate only for once
        _tableView = [[PIERefreshTableView alloc] init];
        
        // configurations
        // set delegate
        _tableView.delegate   = self;
        
        _tableView.dataSource = self;
        
        _tableView.psDelegate = self;
        
        // iOS 8+, self-sizing cell
        _tableView.estimatedRowHeight = 88;
        
        _tableView.rowHeight          = UITableViewAutomaticDimension;
        
        // register cells
        [_tableView
         registerNib:[UINib nibWithNibName:@"PIEChannelDetailLatestPSCell" bundle:nil]
         forCellReuseIdentifier:PIEDetailLatestPSCellIdentifier];
        
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:PIEDetailNormalIdentifier];
 
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
        
        // --- add target-actions
        [_takePhotoButton addTarget:self
                             action:@selector(takePhoto:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
    
}

#pragma mark - UI components configuration
- (void)configureTableView
{
    // added as subview
    [self.view addSubview:_tableView];
    
    // add constraints
    __weak typeof(self) weakSelf = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

- (void)configureTakePhotoButton
{
    // --- added as subViews
    [self.view addSubview:_takePhotoButton];
    
    // --- Autolayout constraints
    __weak typeof(self) weakSelf = self;
    [_takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-64);
    }];

}


@end
