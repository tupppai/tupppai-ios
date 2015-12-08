//
//  PIEChannelViewController.m
//  TUPAI-DEMO
//
//  Created by huangwei on 15/12/4.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import "PIEChannelViewController.h"
#import "Masonry.h"
#import "PIEChannelTableViewCell.h"
#import "PIEChannelBannerCell.h"
#import "PIENewReplyViewController.h"
#import "PIENewAskMakeUpViewController.h"
#import "MJRefresh.h"
#import "PIERefreshTableView.h"

#import "DDBaseService.h"
#import "DDServiceConstants.h"


/**
 *  <PIEChannelBannerDelegate>: 处理bannerCell的两个button的点击（push到其他页面）
 */
@interface PIEChannelViewController (BannerCellDelegate)<PIEChannelBannerCellDelegate>

@end

@interface PIEChannelViewController (RefeshMethods)<PWRefreshBaseTableViewDelegate>

@end

@interface PIEChannelViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) PIERefreshTableView *tableView;
@end


@implementation PIEChannelViewController
#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self setupContainerView];
    
    [self setupTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI components setup

- (void)setupTableView
{
    PIERefreshTableView *tableView = [[PIERefreshTableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];

    tableView.delegate   = self;
    tableView.dataSource = self;
    
    tableView.psDelegate = self;
   
    tableView.estimatedRowHeight = 120;
    tableView.rowHeight = UITableViewAutomaticDimension;

    [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTableViewCell"
                                          bundle:nil]
    forCellReuseIdentifier:@"Channel_Cell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"PIEChannelBannerCell"
                                          bundle:nil]
    forCellReuseIdentifier:@"Banner_Cell"];
    
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 6, 0, 6);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
    
    
        
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
        PIEChannelBannerCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"Banner_Cell"];
        
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        return [tableView dequeueReusableCellWithIdentifier:@"Channel_Cell"];
    }

    
}


#pragma mark - Refresh methods
- (void)loadNewChannels
{
    NSLog(@"%s", __func__);

    // load new channels from server
    /*
     URL_ChannelHomeThreads
     /thread/home
     接受参数
     get:
     page:页面，默认为1
     size:页面数目，默认为10
     last_updated:最后下拉更新的时间戳（10位）
     
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @1;
    params[@"size"] = @5;
    
    [DDBaseService GET:params
                   url:URL_ChannelHomeThreads
                 block:^(id responseObject) {
                     NSLog(@"responseObject as followed: ");
                     NSLog(@"%@", responseObject);
                     [self.tableView.mj_header endRefreshing];
                 }];
    
    
    // add to viewModels
    
    
    
    // refresh tableView
    
    
    
    
}

- (void)loadMoreChannels
{
    NSLog(@"%s", __func__);

    // load more channels from server
    // add to view models
    // refresh tableView
    
    
}

#pragma marmk - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshUp:(UITableView *)tableView{
    [self loadMoreChannels];
}

- (void)didPullRefreshDown:(UITableView *)tableView{
    [self loadNewChannels];
}

#pragma mark - 
#pragma mark - <PIEChannelBannerCellDelegate>
- (void)channelBannerCell:(PIEChannelBannerCell *)channelBannerCell
       didClickLeftButton:(UIButton *)button
{
    NSLog(@"%s", __func__);
    
    [self.navigationController
     pushViewController:[[PIENewAskMakeUpViewController alloc] init]
     animated:YES];

}

- (void)channelBannerCell:(PIEChannelBannerCell *)channelBannerCell
      didClickRightButton:(UIButton *)button
{
    NSLog(@"%s", __func__);
    
    [self.navigationController
     pushViewController:[[PIENewReplyViewController alloc] init]
     animated:YES];

}


@end
