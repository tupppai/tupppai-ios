//
//  ATOMMyFansViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMFansViewController.h"
#import "DDFansTableCell.h"
#import "ATOMOtherPersonViewController.h"
#import "DDMyFansManager.h"
#import "ATOMFans.h"
#import "ATOMFansViewModel.h"
#import "RefreshFooterTableView.h"
#import "DDService.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMFansViewController () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) RefreshFooterTableView *tableView;
@property (nonatomic, strong) UIView *myFansView;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyFansGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSIndexPath* selectedIndexPath;

@end

@implementation ATOMFansViewController


#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"推荐关注" style:UIBarButtonItemStylePlain target:self action:@selector(showRecommendation)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    self.title = [NSString stringWithFormat:@"%@的粉丝", _uid ? _userName : @"我"];
    _myFansView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myFansView;
    _tableView = [[RefreshFooterTableView alloc] initWithFrame:_myFansView.bounds];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
//    _tableView.tableFooterView = [UIView new];
    [_myFansView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.psDelegate = self;
    _tapMyFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyFansGesture:)];
    [_tableView addGestureRecognizer:_tapMyFansGesture];
//    [self configTableViewRefresh];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - Click Event
-(void) showRecommendation {
    [Util showWeAreWorkingOnThisFeature];
}
#pragma mark - Gesture Event

- (void)tapMyFansGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    _selectedIndexPath = [_tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        ATOMFansViewModel *viewModel = _dataSource[_selectedIndexPath.row];
        DDFansTableCell *cell = (DDFansTableCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
        CGPoint p = [gesture locationInView:cell];
//        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
//            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
//            opvc.userID = viewModel.uid;
//            opvc.userName = viewModel.userName;
//            [self pushViewController:opvc animated:YES];
//        }
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
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyFansCell";
    DDFansTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DDFansTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    NSString *text = @"一个粉丝都没有😂";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - Refresh PWRefreshBaseTableViewDelegate

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
    [Hud activity:@"" inView:self.view];
    [DDMyFansManager getMyFans:param withBlock:^(NSMutableArray *resultArray) {
        [Hud dismiss:self.view];
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
    [DDMyFansManager getMyFans:param withBlock:^(NSMutableArray *resultArray) {
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

@end
