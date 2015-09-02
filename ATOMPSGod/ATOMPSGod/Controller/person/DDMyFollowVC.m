//
//  ATOMMyViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMyFollowVC.h"
#import "DDFollowTableCell.h"
#import "DDCommentHeaderView.h"
#import "ATOMMyConcernTableFooterView.h"
#import "ATOMOtherPersonViewController.h"
#import "DDFollow.h"
#import "ATOMConcernViewModel.h"
#import "DDFollowManager.h"
#import "RefreshTableView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDMyFollowVC () <UITableViewDataSource, UITableViewDelegate,PWRefreshBaseTableViewDelegate>

@property (nonatomic, strong) UIView *myConcernView;
@property (nonatomic, strong) RefreshTableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyConcernGesutre;
@property (nonatomic, strong) NSMutableArray *recommendDataSource;
@property (nonatomic, strong) NSMutableArray *myDataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isRefreshingHeader;
@end

@implementation DDMyFollowVC

#pragma mark - Refresh

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
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

#pragma mark - GetDataSource

- (void)getDataSource {
    if (_isRefreshingHeader) {
        return ;
    }
    _isRefreshingHeader = YES;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    _currentPage = 1;
//    [param setObject:@(_uid) forKeyedSubscript:@"uid"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDFollowManager getFollow:param withBlock:^(NSMutableArray *recommendArray, NSMutableArray *mineArray) {
        if (recommendArray.count != 0) {
            [ws.recommendDataSource removeAllObjects];
        }
        if (mineArray.count != 0) {
            [ws.myDataSource removeAllObjects];
        }
        for (DDFollow *concern in recommendArray) {
            ATOMConcernViewModel *concernViewModel = [ATOMConcernViewModel new];
            [concernViewModel setViewModelData:concern];
            [ws.recommendDataSource addObject:concernViewModel];
        }
        for (DDFollow *concern in mineArray) {
            ATOMConcernViewModel *concernViewModel = [ATOMConcernViewModel new];
            [concernViewModel setViewModelData:concern];
            [ws.myDataSource addObject:concernViewModel];
        }
        _tableView.dataSource = self;
        [ws.tableView.header endRefreshing];
        [ws.tableView reloadData];
        ws.isRefreshingHeader = NO;
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    ws.currentPage++;
    [param setObject:@(_uid) forKeyedSubscript:@"uid"];
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@(10) forKey:@"size"];
    [DDFollowManager getFollow:param withBlock:^(NSMutableArray *recommendConcernArray, NSMutableArray *myConcernArray) {
        for (DDFollow *concern in myConcernArray) {
            ATOMConcernViewModel *concernViewModel = [ATOMConcernViewModel new];
            [concernViewModel setViewModelData:concern];
            [ws.myDataSource addObject:concernViewModel];
        }
        if (myConcernArray.count == 0) {
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
    self.title = [NSString stringWithFormat:@"%@的关注", _uid ? _userName : @"我"];
    _myConcernView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myConcernView;
    _tableView = [[RefreshTableView alloc] initWithFrame:_myConcernView.bounds];
    [_myConcernView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = nil;
    _tableView.psDelegate = self;
    _tapMyConcernGesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyConcernGesutre:)];
    [_tableView addGestureRecognizer:_tapMyConcernGesutre];
    _recommendDataSource = [NSMutableArray array];
    _myDataSource = [NSMutableArray array];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - Click Event



#pragma mark - Gesture Event

- (void)tapMyConcernGesutre:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMConcernViewModel *model = (indexPath.section == 0) ? _recommendDataSource[indexPath.row] : _myDataSource[indexPath.row];
        DDFollowTableCell *cell = (DDFollowTableCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.attentionButton.frame, p)) {
                cell.attentionButton.selected = !cell.attentionButton.selected;
                NSMutableDictionary* param = [NSMutableDictionary new];
                [param setObject:@(cell.viewModel.uid) forKey:@"uid"];
                if (!cell.attentionButton.selected) {
                    [param setObject:@0 forKey:@"status"];
                }
                [DDService follow:param withBlock:^(BOOL success) {
                    if (!success) {
                        cell.attentionButton.selected = !cell.attentionButton.selected;
                    } else {
                        NSString* desc =  cell.attentionButton.selected?[NSString stringWithFormat:@"你关注了%@",cell.viewModel.userName]:[NSString stringWithFormat:@"你取消关注了%@",cell.viewModel.userName];
                        [Hud text:desc inView:self.view];
                    }
                }];
            } else {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = model.uid;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            }
        
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return kTableHeaderHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DDCommentHeaderView *headerView = [DDCommentHeaderView new];
    if (section == 0) {
        headerView.titleLabel.text = @"推荐关注";
    } else if (section == 1) {
        headerView.titleLabel.text = @"我的关注";
    }
    return headerView;
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _recommendDataSource.count;
    } else if (section == 1) {
        return _myDataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyConcernCell";
    DDFollowTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DDFollowTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.viewModel = _recommendDataSource[indexPath.row];
    } else {
        cell.viewModel = _myDataSource[indexPath.row];
    }
    return cell;
}


@end
