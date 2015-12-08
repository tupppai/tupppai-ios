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

/* Variables */
@interface PIEChannelDetailViewController ()
@property (nonatomic, strong)PIERefreshTableView *tableView;
@property (nonatomic, strong) UIButton *takePhotoButton;

@end

/* Delegates */

@interface PIEChannelDetailViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIEChannelDetailViewController (PIERefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end



@implementation PIEChannelDetailViewController

static NSString *  PIEDetailLatestPSCellIdentifier =
@"DetailLatestPSCellIdentifier";

static NSString *  PIEDetailNormalIdentifier =
@"PIEDetailNormalIdentifier";


#pragma mark - UI life cycles
//- (void)loadView
//{
//    self.tableView = [[PIERefreshTableView alloc] init];
//    self.view      = self.tableView;
//    [self configurePIERefreshTableView:self.tableView];
//}


/**
 *  不能直接用self.tableView替换掉self.view，而是让self.tableView和self.takePhotoButton
 同时成为self.view的子视图。
 */

- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    /* add subView */
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.takePhotoButton];
    
    // --- add autolayout constraint on _takePhotoButton and _tableView
//    self.tableView.frame = self.view.bounds;
    // wtf is the bug? https://www.google.com.hk/?gws_rd=ssl#q=libc%2B%2Babi.dylib+terminate_handler+unexpectedly+threw+an+exception
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-64);
    }];
    
    
    
}



#pragma mark - Private helpers
- (void)configurePIERefreshTableView:(PIERefreshTableView *)tableView
{
    // set delegate
    tableView.delegate   = self;

    tableView.dataSource = self;

    tableView.psDelegate = self;
    
    // iOS 8+, self-sizing cell
    tableView.estimatedRowHeight = 88;
    
    tableView.rowHeight          = UITableViewAutomaticDimension;
    
    // register cells
    [tableView
     registerNib:[UINib nibWithNibName:@"PIEChannelDetailLatestPSCell" bundle:nil]
     forCellReuseIdentifier:PIEDetailLatestPSCellIdentifier];
    
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:PIEDetailNormalIdentifier];
    
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
        return detailLatestPSCell;
    }
    else
    {
        UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:PIEDetailNormalIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"Cell-%ld", indexPath.row];
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
        // set background image
        [_takePhotoButton setBackgroundImage:[UIImage imageNamed:@"pie_signup_close"]
                                    forState:UIControlStateNormal];
        
        // add target-actions
        [_takePhotoButton addTarget:self
                             action:@selector(takePhoto:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        // added as subViews
        // ... in viewDidLoad
        
        // Autolayout constraints
        // ... in viewDidLoad
        
    }
    return _takePhotoButton;
    
}


@end
