//
//  ATOMInviteMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMsgInviteVC.h"
#import "ATOMInviteMessageTableViewCell.h"
#import "DDHotDetailVC.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "DDMsgInviteModel.h"
#import "ATOMInviteMessage.h"
#import "ATOMInviteMessageViewModel.h"
#import "ATOMHomeImage.h"
#import "DDAskPageVM.h"
#import "RefreshFooterTableView.h"
#import "DDCommentVC.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDMsgInviteVC () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *inviteMessageView;
@property (nonatomic, strong) RefreshFooterTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapInviteMessageGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation DDMsgInviteVC


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
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@"invite" forKey:@"type"];


    [DDMsgInviteModel getInviteMsg:param withBlock:^(NSMutableArray *inviteMessageArray) {
        for (ATOMInviteMessage *inviteMessage in inviteMessageArray) {
            ATOMInviteMessageViewModel *inviteMessageViewModel = [ATOMInviteMessageViewModel new];
            [inviteMessageViewModel setViewModelData:inviteMessage];
            [ws.dataSource addObject:inviteMessageViewModel];
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
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@"invite" forKey:@"type"];
    [DDMsgInviteModel getInviteMsg:param withBlock:^(NSMutableArray *inviteMessageArray) {
        for (ATOMInviteMessage *inviteMessage in inviteMessageArray) {
            ATOMInviteMessageViewModel *inviteMessageViewModel = [ATOMInviteMessageViewModel new];
            [inviteMessageViewModel setViewModelData:inviteMessage];
            [ws.dataSource addObject:inviteMessageViewModel];
        }
        if (inviteMessageArray.count == 0) {
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
    self.title = @"邀请通知";
//    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _inviteMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _inviteMessageView;
    _tableView = [[RefreshFooterTableView alloc] initWithFrame:_inviteMessageView.bounds];
    [_inviteMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.psDelegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tapInviteMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInviteMessageGesture:)];
    [_tableView addGestureRecognizer:_tapInviteMessageGesture];
    _canRefreshFooter = YES;
    _isFirst = YES;
    [self getDataSource];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    [_dataSource removeAllObjects];
}

#pragma mark - Gesture Event

- (void)tapInviteMessageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMInviteMessageViewModel *viewModel = _dataSource[indexPath.row];
        ATOMInviteMessageTableViewCell *cell = (ATOMInviteMessageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.workImageView.frame, p)) {
            if ([viewModel.homepageViewModel.totalPSNumber integerValue] == 0) {
                DDCommentPageVM* vm = [DDCommentPageVM new];
                [vm setCommonViewModelWithAsk:viewModel.homepageViewModel];
                DDCommentVC* mvc = [DDCommentVC new];
                mvc.vm = vm;
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
            opvc.userName = viewModel.userName;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = viewModel.uid;
            opvc.userName = viewModel.userName;
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
    ATOMInviteMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMInviteMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return  YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSInteger row = indexPath.row;
//        [_dataSource removeObjectAtIndex:row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
////        if (_dataSource.count == 0) {
////            self.view = self.noDataView;
////        }
//    }
//}

#pragma mark - DZNEmptyDataSetSource & delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有人邀请你,快去社区活跃一下吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor kTitleForEmptySource]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}



-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (_isFirst) {
        return NO;
    }
    return YES;
}



























@end
