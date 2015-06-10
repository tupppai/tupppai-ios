//
//  ATOMCommentMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentMessageViewController.h"
#import "ATOMCommentMessageViewModel.h"
#import "ATOMCommentMessageTableViewCell.h"
#import "ATOMNoDataView.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMShowCommentMessage.h"
#import "ATOMCommentMessage.h"
#import "ATOMCommentMessageViewModel.h"
#import "ATOMHomeImage.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMPageDetailViewController.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMCommentMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *commentMessageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ATOMNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentMessageGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation ATOMCommentMessageViewController

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
    ATOMShowCommentMessage *showCommentMessage = [ATOMShowCommentMessage new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showCommentMessage ShowCommentMessage:param withBlock:^(NSMutableArray *commentMessageArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMCommentMessage *commentMessage in commentMessageArray) {
            ATOMCommentMessageViewModel *commentMessageViewModel = [ATOMCommentMessageViewModel new];
            [commentMessageViewModel setViewModelData:commentMessage];
            [ws.dataSource addObject:commentMessageViewModel];
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
    ATOMShowCommentMessage *showCommentMessage = [ATOMShowCommentMessage new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showCommentMessage ShowCommentMessage:param withBlock:^(NSMutableArray *commentMessageArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMCommentMessage *commentMessage in commentMessageArray) {
            ATOMCommentMessageViewModel *commentMessageViewModel = [ATOMCommentMessageViewModel new];
            [commentMessageViewModel setViewModelData:commentMessage];
            [ws.dataSource addObject:commentMessageViewModel];
        }
        if (commentMessageArray.count == 0) {
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
    self.title = @"评论";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _commentMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _commentMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_commentMessageView.bounds];
    _tableView.tableFooterView = [UIView new];
    [_commentMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tapCommentMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentMessageGesture:)];
    [_tableView addGestureRecognizer:_tapCommentMessageGesture];
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

- (void)tapCommentMessageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMCommentMessageViewModel *viewModel = _dataSource[indexPath.row];
        ATOMCommentMessageTableViewCell *cell = (ATOMCommentMessageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.workImageView.frame, p)) {
            if ([viewModel.homepageViewModel.totalPSNumber integerValue] == 0) {
                //进入最新详情
                ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
                rdvc.askPageViewModel = viewModel.homepageViewModel;
                [self pushViewController:rdvc animated:YES];
            } else {
                //进入热门详情
                ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
                hdvc.askPageViewModel = viewModel.homepageViewModel;
                [self pushViewController:hdvc animated:YES];
            }
        } else if (CGRectContainsPoint(cell.replyContentLabel.frame, p)) {
            ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
            cdvc.type = viewModel.type;
            cdvc.ID = viewModel.homepageViewModel.imageID;
            [self pushViewController:cdvc animated:YES];
        } else if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
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
    static NSString *CellIdentifier = @"CommentMessageCell";
    ATOMCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMCommentMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.commentMessageViewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMCommentMessageTableViewCell calculateCellHeightWithModel:_dataSource[indexPath.row]];
}

























@end
