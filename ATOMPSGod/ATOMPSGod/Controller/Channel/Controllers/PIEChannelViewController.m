//
//  PIEChannelViewController.m
//  TUPAI-DEMO
//
//  Created by huangwei on 15/12/4.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import "PIEChannelViewController.h"
#import "PIEChannelTableViewCell.h"
#import "PIEChannelBannerCell.h"
#import "PIENewReplyViewController.h"
#import "PIENewAskViewController.h"
#import "PIERefreshTableView.h"
#import "PIEChannelViewModel.h"
#import "PIEChannelManager.h"
#import "PIEChannelDetailViewController.h"
#import "PIEChannelActivityViewController.h"
#import "DeviceUtil.h"

#import "ReactiveCocoa/ReactiveCocoa.h"


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


@interface PIEChannelViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray<PIEChannelViewModel *> *source;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) long long timeStamp;
@property (nonatomic, assign) BOOL stopRefreshFooter;
@end


@implementation PIEChannelViewController
#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTableView];
    [self setupData];
    [self setupRAC];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    label.text = @"图派";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
}
#pragma mark - UI components & data setup
- (void)setupTableView
{
    self.view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIEdgeInsets padding = UIEdgeInsetsMake(0,9, 0, 9);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)setupData {
    _source = [NSMutableArray array];

}

- (void)setupRAC{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:PIERefreshNavigationChannelFromTabBarNotification object:nil]
     subscribeNext:^(id x) {
         @strongify(self);
         if ([self.tableView.mj_header isRefreshing] == NO) {
             [self.tableView.mj_header beginRefreshing];
         }
    }];
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        
        PIEChannelViewModel *channelViewModel = _source[indexPath.row];
        
        [self pushNextViewControllerWithViewModel:channelViewModel];
        
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
        PIEChannelTableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:@"Channel_Cell"];
        cell.vm = [_source objectAtIndex:indexPath.row];
        cell.swipeView.delegate = self;
        cell.swipeView.dataSource = self;
        cell.swipeView.tag        = indexPath.row;
        cell.selectionStyle       = UITableViewCellSelectionStyleNone;
        [cell.swipeView reloadData];
        return cell;
    }
    return nil;

}


#pragma mark - Refresh methods
- (void)loadNewChannels
{

    // load new channels from server
    
    /*
     URL_ChannelHomeThreads
     /thread/home
     接受参数
     get:
     page:页面，默认为1
     size:页面数目，默认为10
     last_updated:最后下拉更新的时间戳（整数10位）
     */
    [self.tableView.mj_footer endRefreshing];
    _timeStamp                  = [[NSDate date] timeIntervalSince1970];
    _currentIndex               = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"]             = @1;
    params[@"size"]             = @5;
    params[@"last_updated"]     = @(_timeStamp);
    [params setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];

    [PIEChannelManager getSource_Channel:params block:^(NSMutableArray *array) {
        if (array.count) {
            [_source removeAllObjects];
            [_source addObjectsFromArray:array];
            
        } else {
            _stopRefreshFooter = YES;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreChannels
{

    [self.tableView.mj_header endRefreshing];
    _currentIndex ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(_currentIndex);
    params[@"size"] = @5;
    params[@"last_updated"] = @(_timeStamp);
    [params setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];

    
    [PIEChannelManager getSource_Channel:params block:^(NSMutableArray *array) {
        if (array.count) {
            [_source addObjectsFromArray: array];;
            [self.tableView reloadData];
        } else {
            _stopRefreshFooter = YES;
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma marmk - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshUp:(UITableView *)tableView{
    if (_stopRefreshFooter) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadMoreChannels];
    }
}

- (void)didPullRefreshDown:(UITableView *)tableView{
    [self loadNewChannels];
}

#pragma mark - 
#pragma mark - <PIEChannelBannerCellDelegate>
- (void)channelBannerCell:(PIEChannelBannerCell *)channelBannerCell
       didClickLeftButton:(UIButton *)button
{
    
    [self.navigationController
     pushViewController:[[PIENewAskViewController alloc] init]
     animated:YES];

}

- (void)channelBannerCell:(PIEChannelBannerCell *)channelBannerCell
      didClickRightButton:(UIButton *)button
{
    
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
        CGFloat swipeView_item_width = (swipeView.frame.size.width-8)/5;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, swipeView_item_width, swipeView_item_width-8)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, swipeView_item_width-8, swipeView_item_width-8)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
    }
    
    NSArray* threads = [_source objectAtIndex:swipeView.tag].threads;
    if (threads.count > index) {
        PIEPageVM* vm = [[_source objectAtIndex:swipeView.tag].threads objectAtIndex:index];
        for (UIView *subView in view.subviews) {
            if([subView isKindOfClass:[UIImageView class]]){
                UIImageView *imageView = (UIImageView *)subView;
                NSString* urlString = [vm.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION*0.2];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
                break;
            }
        }
    }
    return view;
}

#pragma mark - <SwipeViewDelegate>
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    PIEChannelViewModel *selectedChannelVM = _source[swipeView.tag];
    [self pushNextViewControllerWithViewModel:selectedChannelVM];
}


#pragma mark - Lazy loadings
-(PIERefreshTableView *)tableView {
    if (_tableView == nil) {
        _tableView                    = [[PIERefreshTableView alloc] init];
        _tableView.delegate           = self;
        _tableView.dataSource         = self;
        _tableView.psDelegate         = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerNib:[UINib nibWithNibName:@"PIEChannelTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"Channel_Cell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"PIEChannelBannerCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"Banner_Cell"];
        
    }
    return _tableView;
}

#pragma mark - private helper

/**
 *  根据ChannelViewModel，跳转到对应的ViewController中（活动or频道详情）
 *
 */
- (void)pushNextViewControllerWithViewModel:(PIEChannelViewModel *)channelViewModel
{
    if (channelViewModel.channelType == PIEChannelTypeChannel) {
        /* push to ChannelDetail */
        
        PIEChannelDetailViewController *channelDetailViewController =
        
        [[PIEChannelDetailViewController alloc] init];
        channelDetailViewController.currentChannelViewModel =
        channelViewModel;
        
        [self.navigationController
         pushViewController:channelDetailViewController
         animated:YES];
        
    }
    else if (channelViewModel.channelType == PIEChannelTypeActivity)
    {
        /* push to ChannelActivity */
        PIEChannelActivityViewController *channelActivityViewController =
        [[PIEChannelActivityViewController alloc] init];
        
        channelActivityViewController.currentChannelVM =
        channelViewModel;
        
        [self.navigationController
         pushViewController:channelActivityViewController
         animated:YES];
        
    }
    else
    {
        /* JSON parsing error! */
        
    }
 
}

@end
