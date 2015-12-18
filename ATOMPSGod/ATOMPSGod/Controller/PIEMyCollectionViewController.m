//
//  PIEMyCollectionViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyCollectionViewController.h"
#import "PIERefreshTableView.h"
#import "DDPageManager.h"
#import "PIEMyCollectionTableViewCell.h"
#import "PIECarouselViewController2.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
#import "DeviceUtil.h"
#import "PIECommentViewController.h"
@interface PIEMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong)  PIERefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyCollectionGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;

@end

@implementation PIEMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [PIERefreshTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.psDelegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview: _tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    UINib* nib = [UINib nibWithNibName:@"PIEMyCollectionTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"PIEMyCollectionTableViewCell"];
    _canRefreshFooter = YES;
    _currentPage = 1;
    _dataSource = [NSMutableArray array];
    _isfirstLoading = YES;
    [self.tableView.mj_header beginRefreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIEMyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIEMyCollectionTableViewCell"];
    if (!cell) {
        cell = [[PIEMyCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PIEMyCollectionTableViewCell"];
    }
    [cell injectSauce:[_dataSource objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PIEPageVM* vm = [_dataSource objectAtIndex:indexPath.row];
    if ([vm.replyCount integerValue] <= 0 && vm.type == PIEPageTypeAsk) {
        PIECommentViewController *vc_comment = [PIECommentViewController new];
        vc_comment.vm = vm;
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        DDNavigationController* nav2 = [[DDNavigationController alloc]initWithRootViewController:vc_comment];
        [nav presentViewController:nav2 animated:NO completion:nil];
    } else {
        PIECarouselViewController2* vc = [PIECarouselViewController2 new];
        vc.pageVM = vm;
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        [nav presentViewController:vc animated:NO completion:nil];
    }
}
-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
}

-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_tableView.mj_footer endRefreshing];
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
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getCollection:param withBlock:^(NSMutableArray *resultArray) {
        NSMutableArray* arrayAgent = [NSMutableArray new];
        for (PIEPageEntity *entity in resultArray) {
            PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
            [arrayAgent addObject:vm];
        }
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:arrayAgent];
        ws.isfirstLoading = NO;
        [ws.tableView reloadData];
        [ws.tableView.mj_header endRefreshing];
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    [ws.tableView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _currentPage++;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getCollection:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity *entity in resultArray) {
            PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
            [_dataSource addObject:vm];
        }
        [ws.tableView reloadData];
        [ws.tableView.mj_footer endRefreshing];
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat startContentOffsetY = scrollView.contentOffset.y;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (startContentOffsetY > scrollView.contentOffset.y ) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PIEMeScrollDown" object:nil];
        }
        else if (startContentOffsetY < scrollView.contentOffset.y)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PIEMeScrollUp" object:nil];
        }
    });
}

#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_isfirstLoading;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没收藏呢";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
