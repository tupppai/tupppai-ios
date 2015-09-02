//
//  ATOMCommentMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMsgCommentVC.h"
#import "DDCommentMsgVM.h"
#import "ATOMCommentMessageTableViewCell.h"
#import "DDHotDetailVC.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "DDMsgCommentModel.h"
#import "DDCommentMsg.h"
#import "DDCommentMsgVM.h"
#import "ATOMHomeImage.h"
#import "DDAskPageVM.h"
#import "RefreshFooterTableView.h"

#import "DDCommentVC.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDMsgCommentVC () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *commentMessageView;
@property (nonatomic, strong)  RefreshFooterTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentMessageGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation DDMsgCommentVC


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



#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"评论";
//    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _commentMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _commentMessageView;
    _tableView = [[RefreshFooterTableView alloc] initWithFrame:_commentMessageView.bounds];
    [_commentMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.psDelegate = self;
    _tapCommentMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentMessageGesture:)];
    [_tableView addGestureRecognizer:_tapCommentMessageGesture];
    _canRefreshFooter = YES;
    [self getDataSource];
    _isFirst = YES;
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
//    [_dataSource removeAllObjects];
//    if (_dataSource.count == 0) {
//        self.view = self.noDataView;
//    }
}

#pragma mark - Gesture Event

- (void)tapCommentMessageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        DDCommentMsgVM *viewModel = _dataSource[indexPath.row];
        ATOMCommentMessageTableViewCell *cell = (ATOMCommentMessageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.workImageView.frame, p)) {
            if ([viewModel.homepageViewModel.totalPSNumber integerValue] == 0) {
                //进入最新详情
                DDCommentVC* mvc = [DDCommentVC new];
                mvc.vm = [viewModel.homepageViewModel generatepageDetailViewModel];
//                mvc.delegate = self;
                [self pushViewController:mvc animated:YES];

            } else {
                //进入热门详情
                DDHotDetailVC *hdvc = [DDHotDetailVC new];
                hdvc.askVM = viewModel.homepageViewModel;
                [self pushViewController:hdvc animated:YES];
            }
        } else if (CGRectContainsPoint(cell.replyContentLabel.frame, p)) {
            ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
            cdvc.type = viewModel.type;
            cdvc.ID = viewModel.homepageViewModel.ID;
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


#pragma mark - DZNEmptyDataSetSource & delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有人评论你,快去社区活跃一下吧";
    
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
    [param setObject:@"comment" forKey:@"type"];
    [DDMsgCommentModel getCommentMsg:param withBlock:^(NSMutableArray *commentMessageArray) {
        for (DDCommentMsg *commentMessage in commentMessageArray) {
            DDCommentMsgVM *commentMessageViewModel = [DDCommentMsgVM new];
            [commentMessageViewModel setViewModelData:commentMessage];
            [ws.dataSource addObject:commentMessageViewModel];
        }
        [[KShareManager mascotAnimator]dismiss];
        [ws.tableView reloadData];
        _isFirst = NO;
        NSLog(@"_isFirst NO");

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
    [param setObject:@"comment" forKey:@"type"];
    [DDMsgCommentModel getCommentMsg:param withBlock:^(NSMutableArray *commentMessageArray) {
        for (DDCommentMsg *commentMessage in commentMessageArray) {
            DDCommentMsgVM *commentMessageViewModel = [DDCommentMsgVM new];
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















@end
