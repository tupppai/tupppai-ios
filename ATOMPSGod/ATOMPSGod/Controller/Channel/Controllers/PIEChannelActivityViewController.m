//
//  PIEChannelActivityViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/11.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelActivityViewController.h"
#import "PIERefreshTableView.h"
#import "PIENewReplyTableCell.h"
#import "PIEPageVM.h"
#import "PIEChannelViewModel.h"
#import "PIEChannelManager.h"


/* Variables */
@interface PIEChannelActivityViewController ()

/*Views*/
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, strong) UIButton            *goPsButton;

/** image from currentChannelVM */
@property (nonatomic, strong) UIButton            *headerBannerView;

/*ViewModels*/
@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *source_reply;
@property (nonatomic, strong) PIEPageVM                   *selectedVM;
@property (nonatomic, strong) PIEChannelViewModel         *currentChannelVM;

/* HTTP Request parameter */
@property (nonatomic, assign) long long timeStamp;

@end

/* Protocols */
@interface PIEChannelActivityViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIEChannelActivityViewController (RefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end


@implementation PIEChannelActivityViewController

static NSString *
PIEChannelActivityReplyCellIdentifier = @"pieacti";

static NSString *
PIEChannelActivityNormalCellIdentifier = @"PIEChannelActivityNormalCellIdentifier";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"#表情有灵气";
    
    // setup data
    [self setupData];
    
    // configure subviews
    [self configureTableView];
    [self configureGoPsButton];
    
    // load data for the first time.
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI components setup
- (void)configureTableView
{
    // add to subView
    [self.view addSubview:self.tableView];
    
    
    
    // set constraints
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
}


- (void)configureGoPsButton
{
    // add to subView
    [self.view addSubview:self.goPsButton];
    
    // set constraints
    [self.goPsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-64);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - data setup
- (void)setupData
{
    _source_reply = [[NSMutableArray<PIEPageVM *> alloc] init];
}

#pragma mark - <UITableViewDelegate>


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return  self.source_reply.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PIENewReplyTableCell *replyCell =
    [tableView dequeueReusableCellWithIdentifier:PIEChannelActivityReplyCellIdentifier];
    
    [replyCell injectSauce:_source_reply[indexPath.row]];
    
    return replyCell;
}
#pragma mark - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshUp:(UITableView *)tableView
{
    [self loadMoreReplies];
}

- (void)didPullRefreshDown:(UITableView *)tableView
{
    [self loadNewReplies];
}

#pragma mark - refreshing methods
- (void)loadNewReplies
{
    NSLog(@"%s", __func__);
    
    /*
     <h3 id="get_activity_threads">获取活动相关作品</h3>
     
     /thread/get_activity_threads
     URL_ChannelActivity
     接受参数
     get:
     activity_id:活动id (test: 1003)
     page:页面，默认为1
     size:页面数目，默认为10
     last_updated:最后下拉更新的时间戳（10位）
     */
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activity_id"]      = @(1003);
    params[@"page"]             = @(1);
    params[@"size"]             = @(10);
    _timeStamp                  = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]     = @(_timeStamp);
    
    __weak typeof(self) weakSelf = self;
    [PIEChannelManager
     getSource_pageViewModels:params
     repliesResult:^(NSMutableArray<PIEPageVM *> *repliesResultArray) {
         [_source_reply removeAllObjects];
         [_source_reply addObjectsFromArray:repliesResultArray];
         
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [weakSelf.tableView.mj_header endRefreshing];
             [weakSelf.tableView reloadData];
         }];
     }];
}

- (void)loadMoreReplies
{
    NSLog(@"%s", __func__);
    
    /*
     <h3 id="get_activity_threads">获取活动相关作品</h3>
     
     /thread/get_activity_threads
     URL_ChannelActivity
     接受参数
     get:
     activity_id:活动id (test: 1003)
     page:页面，默认为1
     size:页面数目，默认为10
     last_updated:最后下拉更新的时间戳（10位）
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activity_id"]      = @(1003);
    params[@"page"]             = @(2);
    params[@"size"]             = @(10);
    _timeStamp                  = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]     = @(_timeStamp);
    
    __weak typeof(self) weakSelf = self;
    [PIEChannelManager
     getSource_pageViewModels:params
     repliesResult:^(NSMutableArray<PIEPageVM *> *repliesResultArray) {
         if (repliesResultArray.count == 0) {
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [weakSelf.tableView.mj_footer endRefreshing];
             }];
         }
         else{
             [_source_reply addObjectsFromArray:repliesResultArray];
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [weakSelf.tableView.mj_footer endRefreshing];
                 [weakSelf.tableView reloadData];
             }];
         }
     }];
    
}

#pragma mark - Target-actions
- (void)goPSButtonClicked:(UIButton *)button
{
    NSLog(@"%s", __func__);

}

- (void)headerBannerViewClicked:(UIButton *)button
{
    NSLog(@"%s", __func__);

}

#pragma mark - Lazy loadings
- (PIERefreshTableView *)tableView
{
    if (_tableView == nil) {
        // instantiate only for once
        _tableView = [[PIERefreshTableView alloc] init];
        
        _tableView.delegate   = self;
        _tableView.psDelegate = self;
        _tableView.dataSource = self;
        
        // iOS 8+, self-sizing cell
        _tableView.estimatedRowHeight = 400;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        // add headerBannerView
        _tableView.tableHeaderView = self.headerBannerView;
        
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // register cells
        [_tableView registerNib:[UINib nibWithNibName:@"PIENewReplyTableCell"
                                               bundle:nil]
         forCellReuseIdentifier:PIEChannelActivityReplyCellIdentifier];
        
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:PIEChannelActivityNormalCellIdentifier];
    }
    
    
    return  _tableView;
}


- (UIButton *)headerBannerView
{
    if (_headerBannerView == nil) {
        // instantiate only for once
        _headerBannerView = [[UIButton alloc] init];
        
        // set background image("表情有灵气")
        [_headerBannerView
         setBackgroundImage:[UIImage imageNamed:@"pie_channelActivityBanner"]
         forState:UIControlStateNormal];
        
        // 取消点击变暗的效果
        _headerBannerView.adjustsImageWhenHighlighted = NO;
        
        // set frame
        _headerBannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (448.0 / 750.0)*SCREEN_WIDTH);
        
        // Target-actions
        [_headerBannerView addTarget:self
                              action:@selector(headerBannerViewClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerBannerView;
}

- (UIButton *)goPsButton
{
    if (_goPsButton == nil) {
        // instantiate only for once
        _goPsButton = [[UIButton alloc] init];
        
        // set background image (make-shift case)
        [_goPsButton setBackgroundImage:[UIImage imageNamed:@"moment"]
                               forState:UIControlStateNormal];
        
        
        
        // Target-actions
        [_goPsButton addTarget:self
                        action:@selector(goPSButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _goPsButton;

}

@end
