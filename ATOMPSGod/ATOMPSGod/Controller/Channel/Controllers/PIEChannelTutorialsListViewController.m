//
//  PIEChannelTutorialViewController.m
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialsListViewController.h"
#import "PIEChannelViewModel.h"
#import "PIEChannelTutorialModel.h"
#import "PIERefreshTableView.h"
#import "PIEChannelTutorialListCell.h"
#import "PIEChannelManager.h"
#import "LxDBAnything.h"
//#import "PIEChannelTutorialDetailViewController.h"
#import "PIEChannelTutorialContainerViewController.h"

@interface PIEChannelTutorialsListViewController ()
<
    /* Protocols */
    UITableViewDelegate, UITableViewDataSource,
    PWRefreshBaseTableViewDelegate
>

/* Variables */
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray<PIEChannelTutorialModel *> *source_tutorial;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation PIEChannelTutorialsListViewController

static NSString *PIEChannelTutorialListCellIdentifier =
@"PIEChannelTutorialListCell";

#pragma mark - UI life cycles
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor   = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupData];

    
    [self setupSubViews];
    
    [self.tableView.mj_header beginRefreshing];
    
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

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

#pragma mark - basic UI setup
- (void)setupNavBar
{
    self.navigationItem.title = self.currentChannelViewModel.title;
}

- (void)setupSubViews
{
    PIERefreshTableView *tableView = ({
        PIERefreshTableView *tableView = [[PIERefreshTableView alloc] init];
        
        tableView.delegate   = self;
        tableView.dataSource = self;
        tableView.psDelegate = self;
        
        tableView.showsVerticalScrollIndicator   = NO;
        tableView.showsHorizontalScrollIndicator = NO;
    
        
        tableView.estimatedRowHeight = 270;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialListCell"
                                              bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialListCellIdentifier];
        

        WS(weakSelf);
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
        
        tableView;
    });
    self.tableView = tableView;
    
}

#pragma mark - data setup
- (void)setupData
{
    _source_tutorial  = [NSMutableArray<PIEChannelTutorialModel *> new];

    _currentPageIndex = 1;
    
    _canRefreshFooter = YES;
    
}

#pragma mark - network request
- (void)loadNewTutorials{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _currentPageIndex = 1;
    
    params[@"page"] = @(_currentPageIndex);
    params[@"size"] = @(10);
    
    [PIEChannelManager
     getSource_channelTutorialList:params
     block:^(NSArray<PIEChannelTutorialModel *> *retArray) {
         
         if (retArray.count == 0) {
             _canRefreshFooter = NO;
         }else{
             _canRefreshFooter = YES;
         }
         
         [_tableView.mj_header endRefreshing];
         [_source_tutorial removeAllObjects];
         [_source_tutorial addObjectsFromArray:retArray];
         [_tableView reloadData];
     }
     failureBlock:^{
         [_tableView.mj_header endRefreshing];
     }];
}

- (void)loadMoreTutorials{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _currentPageIndex += 1;
    
    params[@"page"] = @(_currentPageIndex);
    params[@"size"] = @(10);
    
    [PIEChannelManager
     getSource_channelTutorialList:params
     block:^(NSArray<PIEChannelTutorialModel *> *retArray) {
         
         if (retArray.count < 10) {
             _canRefreshFooter = NO;
         }else{
             _canRefreshFooter = YES;
         }
         
         [_tableView.mj_footer endRefreshing];
         [_source_tutorial addObjectsFromArray:retArray];
         [_tableView reloadData];
         
     } failureBlock:^{
         [_tableView.mj_footer endRefreshing];
         
     }];
    
    
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIEChannelTutorialListCell *listCell = [tableView dequeueReusableCellWithIdentifier:PIEChannelTutorialListCellIdentifier];
    [listCell injectModel:_source_tutorial[indexPath.row]];
    
    return listCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _source_tutorial.count;
}


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    PIEChannelTutorialContainerViewController *tutorialContainerVC =
    [[PIEChannelTutorialContainerViewController alloc] init];
    
    tutorialContainerVC.currentTutorialModel = _source_tutorial[indexPath.row];
    
    [self.navigationController pushViewController:tutorialContainerVC animated:YES];
 
    
}


#pragma mark - <PWRefreshBaseDelegate>
- (void)didPullRefreshDown:(UITableView *)tableView{
    [self loadNewTutorials];
}

- (void)didPullRefreshUp:(UITableView *)tableView{
    if (_canRefreshFooter == YES) {
        [self loadMoreTutorials];
    }else{
        [Hud text:@"已经拉到底啦"];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}



@end
