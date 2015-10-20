//
//  ATOMOtherPersonConcernViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEFriendFollowingViewController.h"
#import "PIEFriendFollowingTableCell.h"
#import "PIEFriendViewController.h"
#import "DDFollowManager.h"
#import "DDFollow.h"
#import "DDService.h"
#import "ATOMConcernViewModel.h"
#import "PIERefreshFooterTableView.h"


@interface PIEFriendFollowingViewController () < UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) PIERefreshFooterTableView *tableView;
@property (nonatomic, strong) UIView *concernView;
@property (nonatomic, strong) UITapGestureRecognizer *tapConcernGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PIEFriendFollowingViewController

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
        [_tableView.footer endRefreshing];
    }
}


#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = [NSString stringWithFormat:@"%@的关注", _userName];
    _concernView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _concernView;
    _tableView = [[PIERefreshFooterTableView alloc] initWithFrame:_concernView.bounds];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _tableView.tableFooterView = [UIView new];
    [_concernView addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.psDelegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tapConcernGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcernGesture:)];
    [_tableView addGestureRecognizer:_tapConcernGesture];
    _canRefreshFooter = YES;
    _isFirst = YES;
    [self getDataSource];
}

#pragma mark - Click Event

#pragma mark - Gesture Event

- (void)tapConcernGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMConcernViewModel *viewModel = _dataSource[indexPath.row];
        PIEFriendFollowingTableCell *cell = (PIEFriendFollowingTableCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            DDPageVM* vm = [DDPageVM new];
            vm.userID = viewModel.uid;
            vm.username = viewModel.userName;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.attentionButton.frame, p)) {
            cell.attentionButton.selected = !cell.attentionButton.selected;
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(cell.viewModel.uid) forKey:@"uid"];
            if (!cell.attentionButton.selected) {
                    [param setObject:@0 forKey:@"status"];
                }
            [DDService follow:param withBlock:^(BOOL success) {
                    if (!success) {
                        cell.attentionButton.selected = !cell.attentionButton.selected;
                    }
//                    else {
//                        NSString* desc =  cell.attentionButton.selected?[NSString stringWithFormat:@"你关注了%@",cell.viewModel.userName]:[NSString stringWithFormat:@"你取消关注了%@",cell.viewModel.userName];
//                        [Hud text:desc inView:self.view];
//                    }
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
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有关注任何人,快去社区活跃吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (_isFirst) {
        return NO;
    }
    return YES;
}

#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    _dataSource = nil;
    _dataSource = [NSMutableArray array];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(_uid) forKeyedSubscript:@"uid"];
    [Hud activity:@"" inView:self.view];
    [DDFollowManager getFollow:param withBlock:^(NSMutableArray *recommend,NSMutableArray* resultArray) {
        [Hud dismiss:self.view];
        for (DDFollow *concern in resultArray) {
            ATOMConcernViewModel *concernViewModel = [ATOMConcernViewModel new];
            [concernViewModel setViewModelData:concern];
            [ws.dataSource addObject:concernViewModel];
        }
        _isFirst = NO;
        [ws.tableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    ws.currentPage++;
    [param setObject:@(_uid) forKey:@"uid"];
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDFollowManager getFollow:param withBlock:^(NSMutableArray *resultArray,NSMutableArray* recommend) {
        for (DDFollow *concern in resultArray) {
            ATOMConcernViewModel *concernViewModel = [ATOMConcernViewModel new];
            [concernViewModel setViewModelData:concern];
            [ws.dataSource addObject:concernViewModel];
        }
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.tableView.footer endRefreshing];
        [ws.tableView reloadData];
    }];
}

@end

