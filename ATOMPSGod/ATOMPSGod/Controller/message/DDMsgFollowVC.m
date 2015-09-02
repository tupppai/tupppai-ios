//
//  ATOMConcernMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMsgFollowVC.h"
#import "ATOMConcernMessageTableViewCell.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMConcernMessage.h"
#import "ATOMConcernMessageViewModel.h"
#import "DDMsgFollowModel.h"
#import "RefreshFooterTableView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDMsgFollowVC () <UITableViewDataSource, UITableViewDelegate,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *concernMessageView;
@property (nonatomic, strong) RefreshFooterTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapConcernMessageGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger canRefreshFooter;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation DDMsgFollowVC


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
    [[KShareManager mascotAnimator]show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    _dataSource = nil;
    _dataSource = [NSMutableArray array];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@"follow" forKey:@"type"];

    [DDMsgFollowModel getFollowMsg:param withBlock:^(NSMutableArray *concernMessageArray) {
        for (ATOMConcernMessage *concernMessage in concernMessageArray) {
            ATOMConcernMessageViewModel *concernMessageViewModel = [ATOMConcernMessageViewModel new];
            [concernMessageViewModel setViewModelData:concernMessage];
            [ws.dataSource addObject:concernMessageViewModel];
        }
        [[KShareManager mascotAnimator]dismiss];
        [ws.tableView reloadData];
        _isFirst = NO;
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
    [param setObject:@"follow" forKey:@"type"];

    [DDMsgFollowModel getFollowMsg:param withBlock:^(NSMutableArray *concernMessageArray) {
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
//    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _concernMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _concernMessageView;
    _tableView = [[RefreshFooterTableView alloc] initWithFrame:_concernMessageView.bounds];
    [_concernMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.psDelegate = self;
    _tapConcernMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcernMessageGesture:)];
    [_tableView addGestureRecognizer:_tapConcernMessageGesture];
    _canRefreshFooter = YES;
    _isFirst = YES;
    [self getDataSource];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    [_dataSource removeAllObjects];
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

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return  YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSInteger row = indexPath.row;
//        [_dataSource removeObjectAtIndex:row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}

#pragma mark - DZNEmptyDataSetSource & delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有通知喔,快去社区活跃一下吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor kTitleForEmptySource]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (_isFirst) {
        NSLog(@"emptyDataSetShouldDisplay NO");

        return NO;
    }
    return YES;
}

@end
