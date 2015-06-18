//
//  ATOMConcernMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMConcernMessageViewController.h"
#import "ATOMConcernMessageTableViewCell.h"
#import "ATOMNoDataView.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMConcernMessage.h"
#import "ATOMConcernMessageViewModel.h"
#import "ATOMShowConcernMessage.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMConcernMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *concernMessageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ATOMNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapConcernMessageGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger canRefreshFooter;

@end

@implementation ATOMConcernMessageViewController

#pragma mark - Lazy Initialize

- (ATOMNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [ATOMNoDataView new];
    }
    return _noDataView;
}

#pragma mark - Refresh

- (void)configTableViewRefresh {
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_tableView.footer endRefreshing];
    }
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
    ATOMShowConcernMessage *showConcernMessage = [ATOMShowConcernMessage new];
    ////[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showConcernMessage ShowConcernMessage:param withBlock:^(NSMutableArray *concernMessageArray, NSError *error) {
        ////[SVProgressHUD dismiss];
        for (ATOMConcernMessage *concernMessage in concernMessageArray) {
            ATOMConcernMessageViewModel *concernMessageViewModel = [ATOMConcernMessageViewModel new];
            [concernMessageViewModel setViewModelData:concernMessage];
            [ws.dataSource addObject:concernMessageViewModel];
        }
        [ws.tableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowConcernMessage *showConcernMessage = [ATOMShowConcernMessage new];
    ////[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showConcernMessage ShowConcernMessage:param withBlock:^(NSMutableArray *concernMessageArray, NSError *error) {
        ////[SVProgressHUD dismiss];
        for (ATOMConcernMessage *concernMessage in concernMessageArray) {
            ATOMConcernMessageViewModel *concernMessageViewModel = [ATOMConcernMessageViewModel new];
            [concernMessageViewModel setViewModelData:concernMessage];
            [ws.dataSource addObject:concernMessageViewModel];
        }
        if (concernMessageArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.tableView.footer endRefreshing];
        [ws.tableView reloadData];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"关注通知";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _concernMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _concernMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_concernMessageView.bounds];
    _tableView.tableFooterView = [UIView new];
    [_concernMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tapConcernMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcernMessageGesture:)];
    [_tableView addGestureRecognizer:_tapConcernMessageGesture];
    [self configTableViewRefresh];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    [_dataSource removeAllObjects];
    if (_dataSource.count == 0) {
        self.view = self.noDataView;
    }
}

#pragma mark - Gesture Event

- (void)tapConcernMessageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMConcernMessageViewModel *viewModel = _dataSource[indexPath.row];
        ATOMConcernMessageTableViewCell *cell = (ATOMConcernMessageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = viewModel.uid;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            p = [gesture locationInView:cell.userNameLabel];
            if (p.x <= 16 * viewModel.userName.length) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = viewModel.uid;
                [self pushViewController:opvc animated:YES];
            }
        }
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConcernMessageCell";
    ATOMConcernMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMConcernMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = indexPath.row;
        [_dataSource removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (_dataSource.count == 0) {
            self.view = self.noDataView;
        }
    }
}

































@end
