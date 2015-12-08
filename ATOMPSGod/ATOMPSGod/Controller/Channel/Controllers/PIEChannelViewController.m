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




/**
 *  <PIEChannelBannerDelegate>: 处理bannerCell的两个button的点击（push到其他页面）
 */
@interface PIEChannelViewController (BannerCellDelegate)<PIEChannelBannerCellDelegate>

@end




@interface PIEChannelViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UITableView *tableView;
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
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];

    tableView.delegate   = self;
    tableView.dataSource = self;
   
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
