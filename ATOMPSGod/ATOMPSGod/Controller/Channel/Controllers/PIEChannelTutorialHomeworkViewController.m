//
//  PIEChannelTutorialHomeworkViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/28/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialHomeworkViewController.h"
#import "PIEEliteFollowReplyTableViewCell.h"
#import "PIEPageManager.h"
#import "PIERefreshTableView.h"
#import "PIEChannelTutorialModel.h"

@interface PIEChannelTutorialHomeworkViewController ()
<
    UITableViewDelegate,UITableViewDataSource,
    PWRefreshBaseTableViewDelegate
>
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *source_homework;
@property (nonatomic, assign) NSInteger currentPageIndex;
@end

@implementation PIEChannelTutorialHomeworkViewController

static NSString *PIEEliteFollowReplyTableViewCellIdentifier = @"PIEEliteFollowReplyTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavBar];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UI components setup
- (void)setupNavBar{
    /* do nothing */
}

- (void)setupSubviews{
    PIERefreshTableView *tableView = ({
        PIERefreshTableView *tableView = [PIERefreshTableView new];
        
        tableView.delegate   = self;
        tableView.dataSource = self;
        tableView.psDelegate = self;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.estimatedRowHeight   = SCREEN_WIDTH+155;
        tableView.rowHeight            = UITableViewAutomaticDimension;
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEEliteFollowReplyTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:PIEEliteFollowReplyTableViewCellIdentifier];
        
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
    self.tableView = tableView;
}

#pragma mark - data setup
- (void)setupData{
    _source_homework  = [NSMutableArray<PIEPageVM *> new];

    _currentPageIndex = 1;
    
}

#pragma mark - network request
- (void)loadNewHomework{
    _currentPageIndex = 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"]   = @(_currentPageIndex);
    params[@"size"]   = @(10);
    params[@"ask_id"] = @(_currentTutorialModel.ask_id);
    
    PIEPageManager *manager = [[PIEPageManager alloc] init];
    [manager pullReplySource:params
                       block:^(NSMutableArray *retArray) {
                           [_source_homework removeAllObjects];
                           [_source_homework addObjectsFromArray:retArray];

                           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                               [_tableView.mj_header endRefreshing];
                               [_tableView reloadData];
                           }];
                       }];
}

- (void)loadMoreHomework{
    _currentPageIndex ++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"]   = @(_currentPageIndex);
    params[@"size"]   = @(10);
    params[@"ask_id"] = @(_currentTutorialModel.ask_id);
    
    PIEPageManager *manager = [[PIEPageManager alloc] init];
    [manager pullReplySource:params
                       block:^(NSMutableArray *retArray) {
                           [_source_homework addObjectsFromArray:retArray];
                           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                               [_tableView.mj_footer endRefreshing];
                               [_tableView reloadData];
                           }];
                       }];
}

#pragma mark - <UITableViewDelegate>
/** nothing yet */

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _source_homework.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIEEliteFollowReplyTableViewCell *replyCell =
    [tableView dequeueReusableCellWithIdentifier:PIEEliteFollowReplyTableViewCellIdentifier];
    
    [replyCell injectSauce:_source_homework[indexPath.row]];
    
    
    return replyCell;
}

#pragma mark - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshDown:(UITableView *)tableView{
    [self loadNewHomework];
}

- (void)didPullRefreshUp:(UITableView *)tableView{
    [self loadMoreHomework];
}

#pragma mark - lazy loadings



@end
