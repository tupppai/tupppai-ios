//
//  ATOMTopicReplyMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMsgPostReplyVC.h"
#import "ATOMNoDataView.h"
#import "ATOMTopicReplyMessageTableViewCell.h"
#import "DDHotDetailVC.h"
#import "ATOMOtherPersonViewController.h"
#import "DDCommentVC.h"
#import "ATOMReplyMessage.h"
#import "ATOMReplyMessageViewModel.h"
#import "ATOMHomeImage.h"
#import "DDAskPageVM.h"
#import "ATOMShowReplyMessage.h"
#import "RefreshFooterTableView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDMsgPostReplyVC () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UIView *topicReplyMessageView;
@property (nonatomic, strong) RefreshFooterTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapTopicReplyMessageGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation DDMsgPostReplyVC


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
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@"reply" forKey:@"type"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowReplyMessage *showReplyMessage = [ATOMShowReplyMessage new];
    ////[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showReplyMessage ShowReplyMessage:param withBlock:^(NSMutableArray *replyMessageArray, NSError *error) {
        ////[SVProgressHUD dismiss];
        for (ATOMReplyMessage *replyMessage in replyMessageArray) {
            ATOMReplyMessageViewModel *replyMessageViewModel = [ATOMReplyMessageViewModel new];
            [replyMessageViewModel setViewModelData:replyMessage];
            [ws.dataSource addObject:replyMessageViewModel];
        }
        _tableView.dataSource = self;
        [[KShareManager mascotAnimator]dismiss];
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
    [param setObject:@"reply" forKey:@"type"];

    ATOMShowReplyMessage *showReplyMessage = [ATOMShowReplyMessage new];
    ////[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showReplyMessage ShowReplyMessage:param withBlock:^(NSMutableArray *replyMessageArray, NSError *error) {
        ////[SVProgressHUD dismiss];
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
//    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
//    rightButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _topicReplyMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _topicReplyMessageView;
    _tableView = [[RefreshFooterTableView alloc] initWithFrame:_topicReplyMessageView.bounds];
    [_topicReplyMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = nil;
    _tableView.emptyDataSetSource = self;
    _tableView.psDelegate = self;
    _tapTopicReplyMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopicReplyMessageGesture:)];
    [_tableView addGestureRecognizer:_tapTopicReplyMessageGesture];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    [_dataSource removeAllObjects];

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
                DDCommentVC* mvc = [DDCommentVC new];
                mvc.vm = [viewModel.homepageViewModel generatepageDetailViewModel];;
//                mvc.delegate = self;
                [self pushViewController:mvc animated:YES];
            } else {
                DDHotDetailVC *hdvc = [DDHotDetailVC new];
                hdvc.askVM = viewModel.homepageViewModel;
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
    if (_dataSource.count > 0) {
        cell.viewModel = _dataSource[indexPath.row];
    }
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
    }
}
#pragma mark - DZNEmptyDataSetSource & delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有人回复你喔,快去社区活跃一下吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor kTitleForEmptySource]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
