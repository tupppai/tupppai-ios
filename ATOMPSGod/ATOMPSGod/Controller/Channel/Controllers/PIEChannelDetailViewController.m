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
@end

/* Delegates */

@interface PIEChannelDetailViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIEChannelDetailViewController (PIERefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end



@implementation PIEChannelDetailViewController

static NSString * const PIEDetailLatestPSCellIdentifier =
@"DetailLatestPSCellIdentifier";

static NSString * const PIEDetailNormalIdentifier =
@"PIEDetailNormalIdentifier";


#pragma mark - UI life cycles
- (void)loadView
{
    self.tableView = [[PIERefreshTableView alloc] init];
    self.view      = self.tableView;
    [self configurePIERefreshTableView:self.tableView];
}

- (void)viewDidLoad
{
    
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

@end
