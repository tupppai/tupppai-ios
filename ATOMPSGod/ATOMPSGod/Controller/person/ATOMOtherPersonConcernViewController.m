//
//  ATOMOtherPersonConcernViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherPersonConcernViewController.h"
#import "ATOMMyConcernTableViewCell.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMShowConcern.h"
#import "ATOMConcern.h"
#import "ATOMConcernViewModel.h"
#import "RefreshFooterTableView.h"
#import "ATOMFollowModel.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMOtherPersonConcernViewController () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate>

@property (nonatomic, strong) RefreshFooterTableView *tableView;
@property (nonatomic, strong) UIView *concernView;
@property (nonatomic, strong) UITapGestureRecognizer *tapConcernGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation ATOMOtherPersonConcernViewController

#pragma mark - Refresh

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
    ATOMShowConcern *showConcern = [ATOMShowConcern new];
    [Util loadingHud:@"" inView:self.view];
    [showConcern ShowOtherConcern:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        [Util dismissHud:self.view];
         for (ATOMConcern *concern in resultArray) {
            ATOMConcernViewModel *concernViewModel = [ATOMConcernViewModel new];
            [concernViewModel setViewModelData:concern];
            [ws.dataSource addObject:concernViewModel];
        }
        [ws.tableView.header endRefreshing];
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
    ATOMShowConcern *showConcern = [ATOMShowConcern new];
    [showConcern ShowOtherConcern:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        for (ATOMConcern *concern in resultArray) {
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

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = [NSString stringWithFormat:@"%@的关注", _userName];
    _concernView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _concernView;
    _tableView = [[RefreshFooterTableView alloc] initWithFrame:_concernView.bounds];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _tableView.tableFooterView = [UIView new];
    [_concernView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.psDelegate = self;
    _tapConcernGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcernGesture:)];
    [_tableView addGestureRecognizer:_tapConcernGesture];
//    [self configTableViewRefresh];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - Click Event

#pragma mark - Gesture Event

- (void)tapConcernGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMConcernViewModel *viewModel = _dataSource[indexPath.row];
        ATOMMyConcernTableViewCell *cell = (ATOMMyConcernTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
//        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
//            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
//            opvc.userID = viewModel.uid;
//            opvc.userName = viewModel.userName;
//            [self pushViewController:opvc animated:YES];
//        } else
        
            if (CGRectContainsPoint(cell.attentionButton.frame, p)) {
            cell.attentionButton.selected = !cell.attentionButton.selected;
            NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:@(cell.viewModel.uid),@"uid", nil];
            [ATOMFollowModel follow:param withType:cell.attentionButton.selected withBlock:^(NSError *error) {
                if (error) {
                    cell.attentionButton.selected = !cell.attentionButton.selected;
                } else {
                    NSString* desc =  cell.attentionButton.selected?[NSString stringWithFormat:@"你关注了%@",cell.viewModel.userName]:[NSString stringWithFormat:@"你取消关注了%@",cell.viewModel.userName];
                    [Util TextHud:desc inView:self.view];
                }
            }];

            }  else {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = viewModel.uid;
                opvc.userName = viewModel.userName;
                [self pushViewController:opvc animated:YES];
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
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConcernCell";
    ATOMMyConcernTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMyConcernTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
    
}



@end

