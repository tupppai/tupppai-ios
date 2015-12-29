//
//  ATOMOtherPersonConcernViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEMyFollowViewController.h"
#import "PIEFriendFollowingTableCell.h"
#import "PIEFriendViewController.h"
#import "PIERefreshFooterTableView.h"

@interface PIEMyFollowViewController () < UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) PIERefreshFooterTableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapConcernGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;

@end

@implementation PIEMyFollowViewController

#pragma mark - Refresh
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    [self loadMoreData];
}

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"我的关注";
    _canRefreshFooter = YES;
    _isfirstLoading = YES;
    [self.view addSubview:self.tableView];
    [self getDataSource];
}

-(PIERefreshFooterTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PIERefreshFooterTableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 18, 0, 15);
        _tableView.psDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tapConcernGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcernGesture:)];
        [_tableView addGestureRecognizer:_tapConcernGesture];
    }
    return _tableView;
}
#pragma mark - Click Event

#pragma mark - Gesture Event

- (void)tapConcernGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        PIEUserViewModel *viewModel = _dataSource[indexPath.row];
        PIEFriendFollowingTableCell *cell = (PIEFriendFollowingTableCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            PIEPageVM* vm = [PIEPageVM new];
            vm.userID = viewModel.model.uid;
            vm.username = viewModel.username;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.attentionButton.frame, p)) {
            cell.attentionButton.selected = !cell.attentionButton.selected;
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(cell.viewModel.model.uid) forKey:@"uid"];
            if (!cell.attentionButton.selected) {
                [param setObject:@0 forKey:@"status"];
            }
            [DDService follow:param withBlock:^(BOOL success) {
                if (!success) {
                    cell.attentionButton.selected = !cell.attentionButton.selected;
                }
            }];
            
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConcernCell";
    PIEFriendFollowingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PIEFriendFollowingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有关注的人，快去关注些大神吧";
    
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

#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    _dataSource = nil;
    _dataSource = [NSMutableArray array];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@([DDUserManager currentUser].uid) forKeyedSubscript:@"uid"];
    [Hud activity:@"" inView:self.view];
    [DDUserManager getMyFollows:param withBlock:^(NSArray *recommend,NSArray* resultArray) {
        [Hud dismiss:self.view];
        for (PIEUserModel *model in resultArray) {
            PIEUserViewModel *vm = [[PIEUserViewModel alloc]initWithEntity:model];
            [ws.dataSource addObject:vm];
        }
        ws.isfirstLoading = NO;
        [ws.tableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    ws.currentPage++;
    [param setObject:@([DDUserManager currentUser].uid) forKeyedSubscript:@"uid"];
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDUserManager getMyFollows:param withBlock:^(NSArray *recommend,NSArray* resultArray) {
        for (PIEUserModel *model in resultArray) {
            PIEUserViewModel *vm = [[PIEUserViewModel alloc]initWithEntity:model];
            [ws.dataSource addObject:vm];
        }
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.tableView.mj_footer endRefreshing];
        [ws.tableView reloadData];
    }];
}

@end

