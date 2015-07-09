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
#import "ATOMAskPageViewModel.h"
#import "ATOMShowAttention.h"
#import "ATOMCommonImage.h"
#import "ATOMFollowPageViewModel.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMNoDataView.h"
#import "PWRefreshBaseTableView.h"
#import "PWPageDetailViewModel.h"
#import "ATOMPageDetailViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyAttentionViewController () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,ATOMViewControllerDelegate>

@property (nonatomic, strong) UIView *myAttentionView;
@property (nonatomic, strong) PWRefreshBaseTableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyAttentionGesture;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger canRefreshFooter;
@property (nonatomic, assign) ATOMMyAttentionTableViewCell* selectedCell;

@end

@implementation ATOMMyAttentionViewController

#pragma mark - Lazy Initialize

#pragma mark Refresh

//- (void)configTableViewRefresh {
//    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewHotData)];
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
//}

- (void)loadNewHotData {
    NSLog(@"loadNewHotData");
    [_tableView.header endRefreshing];
}

- (void)loadMoreHotData {
    NSLog(@"loadMoreHotData");

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
    [showAttention ShowAttention:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        if (resultArray.count) {
            [_dataSource removeAllObjects];
        }
        for (ATOMCommonImage *commonImage in resultArray) {
            ATOMFollowPageViewModel * viewModel = [ATOMFollowPageViewModel new];
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
    [showAttention ShowAttention:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        for (ATOMCommonImage *commonImage in resultArray) {
            ATOMFollowPageViewModel * viewModel = [ATOMFollowPageViewModel new];
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

-(void)viewDidAppear:(BOOL)animated {
}

- (void)createUI {
    self.navigationItem.title = @"关注";
    _myAttentionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    self.view = _myAttentionView;
    _tableView = [[PWRefreshBaseTableView alloc] initWithFrame:_myAttentionView.bounds];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.psDelegate = self;
    _tableView.dataSource = self;
    [_myAttentionView addSubview:_tableView];
    _tapMyAttentionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyAttentionGesture:)];
    [_tableView addGestureRecognizer:_tapMyAttentionGesture];
//    [self configTableViewRefresh];
    _canRefreshFooter = YES;
    _dataSource = [NSMutableArray array];
    [self getDataSource];
}

#pragma mark - Gesture Event

- (void)tapMyAttentionGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        _selectedCell = (ATOMMyAttentionTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:_selectedCell];
        
        //点击图片
        if (CGRectContainsPoint(_selectedCell.userWorkImageView.frame, p)) {
            ATOMPageDetailViewController* pdvc = [ATOMPageDetailViewController new];
            PWPageDetailViewModel *pageDetailViewModel = [PWPageDetailViewModel new];
            [pageDetailViewModel setCommonViewModelWithFollow:_dataSource[indexPath.row]];
            pdvc.pageDetailViewModel = pageDetailViewModel;
            pdvc.delegate = self;
            [self pushViewController:pdvc animated:true];
        } else if (CGRectContainsPoint(_selectedCell.topView.frame, p)) {
            p = [gesture locationInView:_selectedCell.topView];
            if (CGRectContainsPoint(_selectedCell.userHeaderButton.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                ATOMFollowPageViewModel* model =  (ATOMFollowPageViewModel*)_dataSource[indexPath.row];
                opvc.userID = model.userID;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            } else if (CGRectContainsPoint(_selectedCell.userNameLabel.frame, p)) {
                p = [gesture locationInView:_selectedCell.userNameLabel];
                if (p.x <= 16 * 3) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    [self pushViewController:opvc animated:YES];
                }
            }
        } else {
            p = [gesture locationInView:_selectedCell.thinCenterView];
            if (CGRectContainsPoint(_selectedCell.praiseButton.frame, p)) {
                [_selectedCell.praiseButton toggleLike];
                [_dataSource[indexPath.row] toggleLike];
            } else if (CGRectContainsPoint(_selectedCell.shareButton.frame, p)) {
                NSLog(@"Click shareButton");
            } else if (CGRectContainsPoint(_selectedCell.commentButton.frame, p)) {
                ATOMPageDetailViewController* pdvc = [ATOMPageDetailViewController new];
                PWPageDetailViewModel *pageDetailViewModel = [PWPageDetailViewModel new];
                [pageDetailViewModel setCommonViewModelWithFollow:_dataSource[indexPath.row]];
                pdvc.delegate = self;
                pdvc.pageDetailViewModel = pageDetailViewModel;
                [self pushViewController:pdvc animated:true];
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

#pragma mark - PWRefreshBaseTableViewDelegate
-(void)didPullRefreshDown:(UITableView *)tableView {
    NSLog(@"didPullRefreshDown");
    [self loadNewHotData];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    NSLog(@"didPullRefreshUp");
    [self loadMoreHotData];
}

#pragma mark - ATOMViewControllerDelegate
-(void)ATOMViewControllerDismissWithLiked:(BOOL)liked {
    [_selectedCell.praiseButton toggleLikeWhenSelectedChanged:liked];
}

























@end
