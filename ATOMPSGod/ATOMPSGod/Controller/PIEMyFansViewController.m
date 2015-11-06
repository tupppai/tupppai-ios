//
//  PIEMyFansViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/28/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyFansViewController.h"
#import "PIEFriendFansTableCell.h"
#import "PIEFriendViewController.h"
#import "DDMyFansManager.h"
#import "PIEEntityFan.h"
#import "PIEFansViewModel.h"
#import "PIERefreshFooterTableView.h"
#import "DDService.h"


@interface PIEMyFansViewController () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) PIERefreshFooterTableView *tableView;
@property (nonatomic, strong) UIView *myFansView;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyFansGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSIndexPath* selectedIndexPath;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;
@end

@implementation PIEMyFansViewController


#pragma mark - UI
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    [self setupNavigationBar];
    [self setupViews];
    [self initValues];
    [self getDataSource];
}

- (void) setupNavigationBar {
    self.title = @"我的粉丝";
}
- (void) setupViews {
    _myFansView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myFansView;
    _tableView = [[PIERefreshFooterTableView alloc] initWithFrame:_myFansView.bounds];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_myFansView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.psDelegate = self;
    _tapMyFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyFansGesture:)];
    [_tableView addGestureRecognizer:_tapMyFansGesture];
}
- (void) initValues {
    _isfirstLoading = YES;
    _canRefreshFooter = YES;
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
        PIEFansViewModel *viewModel = _dataSource[_selectedIndexPath.row];
        PIEFriendFansTableCell *cell = (PIEFriendFansTableCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            DDPageVM* vm = [DDPageVM new];
            vm.userID = viewModel.uid;
            vm.username = viewModel.userName;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        }
        else if (CGRectContainsPoint(cell.attentionButton.frame, p)) {
            cell.attentionButton.selected = !cell.attentionButton.selected;
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(cell.viewModel.uid) forKey:@"uid"];
            if (!cell.attentionButton.selected) {
                [param setObject:@0 forKey:@"status"];
            }
            [DDService follow:param withBlock:^(BOOL success) {
                if (!success) {
                    cell.attentionButton.selected = !cell.attentionButton.selected;
                }
            }];
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
    PIEFriendFansTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PIEFriendFansTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"快去活跃一下就有粉丝咯～";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_isfirstLoading;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
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
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    _dataSource = nil;
    _dataSource = [NSMutableArray array];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@([DDUserManager currentUser].uid) forKeyedSubscript:@"uid"];
    [Hud activity:@"" inView:self.view];
    [DDMyFansManager getMyFans:param withBlock:^(NSMutableArray *resultArray) {
        ws.isfirstLoading = NO;
        [Hud dismiss:self.view];
        for (PIEEntityFan *fans in resultArray) {
            PIEFansViewModel *fansViewModel = [PIEFansViewModel new];
            [fansViewModel setViewModelData:fans];
            [ws.dataSource addObject:fansViewModel];
        }
        [ws.tableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@([DDUserManager currentUser].uid) forKeyedSubscript:@"uid"];
    [DDMyFansManager getMyFans:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEEntityFan *fans in resultArray) {
            PIEFansViewModel *fansViewModel = [PIEFansViewModel new];
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
