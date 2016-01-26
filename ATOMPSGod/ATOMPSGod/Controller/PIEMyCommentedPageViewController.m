//
//  PIEMyCommentedPageViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/17/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyCommentedPageViewController.h"
#import "PIERefreshTableView.h"
#import "PIEMyCommentedPageTableViewCell.h"
#import "PIECarouselViewController2.h"
#import "DDNavigationController.h"

#import "DDPageManager.h"
#import "PIECommentViewController.h"
#import "DeviceUtil.h"

@interface PIEMyCommentedPageViewController ()<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) PIERefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;

@end

@implementation PIEMyCommentedPageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.tableView;
    self.title = @"我评论过的";
    [self initData];
    [self.tableView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initData {
    _currentPage = 1;
    _canRefreshFooter = YES;
    _isfirstLoading = YES;
    _dataSource = [NSMutableArray new];
}

-(PIERefreshTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PIERefreshTableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.psDelegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        UINib* nib = [UINib nibWithNibName:@"PIEMyCommentedPageTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"PIEMyCommentedPageTableViewCell"];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIEMyCommentedPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIEMyCommentedPageTableViewCell"];
    [cell injectSauce:[_dataSource objectAtIndex:indexPath.row]];
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 82;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    PIECommentViewController* vc = [PIECommentViewController new];
    vc.vm = [_dataSource objectAtIndex:indexPath.row];
    [nav pushViewController:vc animated:YES ];

}
-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
}

-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    [ws.tableView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    
    //我评论过的界面的图片一般都已经cache ,可以任性使用。
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getCommentedPages:param withBlock:^(NSMutableArray *resultArray) {
        ws.isfirstLoading = NO;//should set to NO before reloadData
        if (resultArray.count <= 0) {
            ws.canRefreshFooter = NO;
        } else {
            _dataSource = resultArray;
            ws.canRefreshFooter = YES;
        }
        [ws.tableView reloadData];
        [ws.tableView.mj_header endRefreshing];

    }];
}

- (void)getMoreDataSource {
    WS(ws);
    [ws.tableView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _currentPage++;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getCommentedPages:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count <= 0) {
            ws.canRefreshFooter = NO;
        } else {
            [_dataSource addObjectsFromArray:resultArray];
            ws.canRefreshFooter = YES;
        }
        [ws.tableView reloadData];
        [ws.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有评论过别人哦";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_isfirstLoading;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
