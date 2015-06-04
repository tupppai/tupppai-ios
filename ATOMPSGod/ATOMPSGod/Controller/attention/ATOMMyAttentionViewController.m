//
//  ATOMMyAttentionViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyAttentionViewController.h"
#import "ATOMMyAttentionTableViewCell.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMShowAttention.h"
#import "ATOMCommonImage.h"
#import "ATOMCommonImageViewModel.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMNoDataView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyAttentionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *myAttentionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyAttentionGesture;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger canRefreshFooter;

@end

@implementation ATOMMyAttentionViewController

#pragma mark - Lazy Initialize

#pragma mark Refresh

- (void)configTableViewRefresh {
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewHotData)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
}

- (void)loadNewHotData {
    [_tableView.header endRefreshing];
}

- (void)loadMoreHotData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_tableView.footer endRefreshing];
    }
}

#pragma mark - GetDataSource

- (void)getDataSource {
    _currentPage = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    ATOMShowAttention *showAttention = [ATOMShowAttention new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [showAttention ShowAttention:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        [SVProgressHUD dismiss];
        if (resultArray.count) {
            [_dataSource removeAllObjects];
        }
        for (ATOMCommonImage *commonImage in resultArray) {
            ATOMCommonImageViewModel * viewModel = [ATOMCommonImageViewModel new];
            [viewModel setViewModelData:commonImage];
            [_dataSource addObject:viewModel];
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    }];
}

- (void)getMoreDataSource {
    _currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    ATOMShowAttention *showAttention = [ATOMShowAttention new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [showAttention ShowAttention:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMCommonImage *commonImage in resultArray) {
            ATOMCommonImageViewModel * viewModel = [ATOMCommonImageViewModel new];
            [viewModel setViewModelData:commonImage];
            [_dataSource addObject:viewModel];
        }
        if (resultArray.count == 0) {
            _canRefreshFooter = NO;
        } else {
            _canRefreshFooter = YES;
        }
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI {
    self.navigationItem.title = @"关注";
    _myAttentionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    self.view = _myAttentionView;
    _tableView = [[UITableView alloc] initWithFrame:_myAttentionView.bounds];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_myAttentionView addSubview:_tableView];
    _tapMyAttentionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyAttentionGesture:)];
    [_tableView addGestureRecognizer:_tapMyAttentionGesture];
    [self configTableViewRefresh];
    _canRefreshFooter = YES;
    _dataSource = [NSMutableArray array];
    [self getDataSource];
}

#pragma mark - Gesture Event

- (void)tapMyAttentionGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMMyAttentionTableViewCell *cell = (ATOMMyAttentionTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.userWorkImageView.frame, p)) {
//            NSLog(@"Click userWorkImageView");
            ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
            [self pushViewController:hdvc animated:YES];
        } else if (CGRectContainsPoint(cell.topView.frame, p)) {
            p = [gesture locationInView:cell.topView];
            if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
//                NSLog(@"Click userHeaderButton");
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                [self pushViewController:opvc animated:YES];
            } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
                p = [gesture locationInView:cell.userNameLabel];
                if (p.x <= 16 * 3) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    [self pushViewController:opvc animated:YES];
                }
            }
        } else {
            p = [gesture locationInView:cell.thinCenterView];
            if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
                cell.praiseButton.selected = !cell.praiseButton.selected;
            } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
                NSLog(@"Click shareButton");
            } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
                ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
                [self pushViewController:cdvc animated:YES];
            }
        }
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyAttentionCell";
    ATOMMyAttentionTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMyAttentionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMMyAttentionTableViewCell calculateCellHeightWith:_dataSource[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
































@end
