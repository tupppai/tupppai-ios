//
//  ATOMMyFansViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyFansViewController.h"
#import "ATOMMyFansTableViewCell.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMShowFans.h"
#import "ATOMFans.h"
#import "ATOMFansViewModel.h"
#import "ATOMFollowModel.h"
#import "PWRefreshFooterTableView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyFansViewController () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate>

@property (nonatomic, strong) PWRefreshFooterTableView *tableView;
@property (nonatomic, strong) UIView *myFansView;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyFansGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSIndexPath* selectedIndexPath;

@end

@implementation ATOMMyFansViewController

#pragma mark - Refresh PWRefreshBaseTableViewDelegate

//- (void)configTableViewRefresh {
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//}
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
    ATOMShowFans *showFans = [ATOMShowFans new];
    [Util loadingHud:@"" inView:self.view];
    [showFans ShowFans:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        [Util dismissHud:self.view];
        for (ATOMFans *fans in resultArray) {
            ATOMFansViewModel *fansViewModel = [ATOMFansViewModel new];
            [fansViewModel setViewModelData:fans];
            [ws.dataSource addObject:fansViewModel];
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
    ATOMShowFans *showFans = [ATOMShowFans new];
    [showFans ShowFans:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        for (ATOMFans *fans in resultArray) {
            ATOMFansViewModel *fansViewModel = [ATOMFansViewModel new];
            [fansViewModel setViewModelData:fans];
            [ws.dataSource addObject:fansViewModel];
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

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = [NSString stringWithFormat:@"%@的粉丝", _uid ? _userName : @"我"];
    _myFansView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myFansView;
    _tableView = [[PWRefreshFooterTableView alloc] initWithFrame:_myFansView.bounds];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
//    _tableView.tableFooterView = [UIView new];
    [_myFansView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.psDelegate = self;
    _tapMyFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyFansGesture:)];
    [_tableView addGestureRecognizer:_tapMyFansGesture];
//    [self configTableViewRefresh];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - Click Event

#pragma mark - Gesture Event

- (void)tapMyFansGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    _selectedIndexPath = [_tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        ATOMFansViewModel *viewModel = _dataSource[_selectedIndexPath.row];
        ATOMMyFansTableViewCell *cell = (ATOMMyFansTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = viewModel.uid;
            opvc.userName = viewModel.userName;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.attentionButton.frame, p)) {
            cell.attentionButton.selected = !cell.attentionButton.selected;
            NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:@(cell.viewModel.uid),@"uid", nil];
            [ATOMFollowModel follow:param withType:cell.attentionButton.selected withBlock:^(NSError *error) {
                if (error) {
                    [Util TextHud:@"出现未知错误" inView:self.view];
                    cell.attentionButton.selected = !cell.attentionButton.selected;
                } else {
                    NSString* desc =  cell.attentionButton.selected?[NSString stringWithFormat:@"你关注了%@",cell.viewModel.userName]:[NSString stringWithFormat:@"你取消关注了%@",cell.viewModel.userName];
                    [Util TextHud:desc inView:self.view];
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
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyFansCell";
    ATOMMyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMyFansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
    
}



@end
