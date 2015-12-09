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
#import "PIEChannelViewModel.h"
#import "PIEChannelManager.h"
#import "PIEChannelDetailViewController.h"

/* Protocols */

@interface PIEChannelViewController (BannerCellDelegate)<PIEChannelBannerCellDelegate>
@end

@interface PIEChannelViewController (ChannelCellDelegate)<SwipeViewDelegate,SwipeViewDataSource>
@end

@interface PIEChannelViewController (RefreshBaseTableView)<PWRefreshBaseTableViewDelegate>
@end

@interface PIEChannelViewController (TableView)<UITableViewDelegate, UITableViewDataSource>
@end

/* Properties */

@interface PIEChannelViewController ()
@property (nonatomic, weak  ) UIView                                *containerView;
@property (nonatomic, strong) PIERefreshTableView                   *tableView;
@property (nonatomic, strong) NSMutableArray<PIEChannelViewModel *> *source;
@property (nonatomic, assign) NSInteger                             currentIndex;
@property (nonatomic, assign) long long                             timeStamp;
@end


@implementation PIEChannelViewController
#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableView];
    [self setupData];
    
    // load first data
    [self loadNewChannels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI components & data setup
- (void)setupTableView
{
    [self.view addSubview:self.tableView];
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 6, 0, 6);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
}

- (void)setupData {
    _source = [NSMutableArray array];

}
#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    
    if (indexPath.section != 0)
    {
        PIEChannelDetailViewController *channelDetailViewController =
        
        [[PIEChannelDetailViewController alloc] init];
        channelDetailViewController.selectedChannelViewModel =
        _source[indexPath.row];
        
        [self.navigationController
         pushViewController:channelDetailViewController
         animated:YES];
        
    }
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _source.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        PIEChannelBannerCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"Banner_Cell"];
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        PIEChannelTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Channel_Cell"];
        cell.vm = [_source objectAtIndex:indexPath.row];
//        cell.swipeView.delegate = self;
        cell.swipeView.dataSource = self;
        cell.swipeView.tag = indexPath.row;
        return cell;
    }
    return nil;

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
    [self.tableView.mj_footer endRefreshing];
    _timeStamp                  = [[NSDate date] timeIntervalSince1970];
    _currentIndex               = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"]             = @1;
    params[@"size"]             = @5;
    params[@"last_updated"]     = @(_timeStamp);

    [PIEChannelManager getSource_Channel:params block:^(NSMutableArray *array) {
        if (array.count) {
            
            // FIXME: 使用NSRange插入数组，而不是将数组全部清空
            // FIXME: tableView只reload最新加载的数据，而不是全部重载。 ([_source addObjectsFromBeginning:array])
            [_source removeAllObjects];
            [_source addObjectsFromArray:array];
            
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreChannels
{
    [self.tableView.mj_header endRefreshing];
    _currentIndex ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"]             = @(_currentIndex);
    params[@"size"]             = @5;
    params[@"last_updated"]     = @(_timeStamp);
    
    [PIEChannelManager getSource_Channel:params block:^(NSMutableArray *array) {
        if (array.count) {
            [_source addObjectsFromArray: array];;
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
    

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


#pragma mark - iCarousel(SwipeView) methods
#pragma mark - <SwipeViewDataSource>
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [_source objectAtIndex:swipeView.tag].threads.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        CGFloat width                = 40;
        view                         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        UIImageView* imageView       = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, width, width)];
        imageView.contentMode        = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 3.0;
        imageView.clipsToBounds      = YES;
        [view addSubview:imageView];
    }
    
    PIEPageVM* vm = [[_source objectAtIndex:swipeView.tag].threads objectAtIndex:index];
    for (UIView *subView in view.subviews) {
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            [imageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
        }
    }
    return view;
}

#pragma mark - <SwipeViewDelegate>
/*
    nothing yet.
 */


#pragma mark - Lazy loadings
-(PIERefreshTableView *)tableView {
    if (_tableView == nil) {
        _tableView                    = [[PIERefreshTableView alloc] init];
        _tableView.delegate           = self;
        _tableView.dataSource         = self;
        _tableView.psDelegate         = self;
        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight          = UITableViewAutomaticDimension;
        
        [_tableView registerNib:[UINib nibWithNibName:@"PIEChannelTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"Channel_Cell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"PIEChannelBannerCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"Banner_Cell"];
        
    }
    return _tableView;
}


@end
