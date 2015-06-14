//
//  ATOMTopicReplyMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMTopicReplyMessageViewController.h"
#import "ATOMNoDataView.h"
#import "ATOMTopicReplyMessageTableViewCell.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMPageDetailViewController.h"
#import "ATOMReplyMessage.h"
#import "ATOMReplyMessageViewModel.h"
#import "ATOMHomeImage.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMShowReplyMessage.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMTopicReplyMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topicReplyMessageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ATOMNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapTopicReplyMessageGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation ATOMTopicReplyMessageViewController

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
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowReplyMessage *showReplyMessage = [ATOMShowReplyMessage new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showReplyMessage ShowReplyMessage:param withBlock:^(NSMutableArray *replyMessageArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMReplyMessage *replyMessage in replyMessageArray) {
            ATOMReplyMessageViewModel *replyMessageViewModel = [ATOMReplyMessageViewModel new];
            [replyMessageViewModel setViewModelData:replyMessage];
            [ws.dataSource addObject:replyMessageViewModel];
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
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowReplyMessage *showReplyMessage = [ATOMShowReplyMessage new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showReplyMessage ShowReplyMessage:param withBlock:^(NSMutableArray *replyMessageArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMReplyMessage *replyMessage in replyMessageArray) {
            ATOMReplyMessageViewModel *replyMessageViewModel = [ATOMReplyMessageViewModel new];
            [replyMessageViewModel setViewModelData:replyMessage];
            [ws.dataSource addObject:replyMessageViewModel];
        }
        if (replyMessageArray.count == 0) {
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
    self.title = @"帖子通知";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    rightButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _topicReplyMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _topicReplyMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_topicReplyMessageView.bounds];
    _tableView.tableFooterView = [UIView new];
    [_topicReplyMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tapTopicReplyMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicReplyMessageGesture:)];
    [_tableView addGestureRecognizer:_tapTopicReplyMessageGesture];
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

- (void)tapTopicReplyMessageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMReplyMessageViewModel *viewModel = _dataSource[indexPath.row];
        ATOMTopicReplyMessageTableViewCell *cell = (ATOMTopicReplyMessageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.workImageView.frame, p)) {
            if ([viewModel.homepageViewModel.totalPSNumber integerValue] == 0) {
                ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
                rdvc.pageDetailViewModel = [viewModel.homepageViewModel generatepageDetailViewModel];
                [self pushViewController:rdvc animated:YES];
            } else {
                ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
                hdvc.askPageViewModel = viewModel.homepageViewModel;
                [self pushViewController:hdvc animated:YES];
            }
        } else if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = viewModel.uid;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = viewModel.uid;
            [self pushViewController:opvc animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InviteMessageCell";
    ATOMTopicReplyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMTopicReplyMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
