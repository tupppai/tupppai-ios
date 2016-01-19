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
#import "PIERefreshFooterTableView.h"

@interface PIEMyFansViewController () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) PIERefreshFooterTableView *tableView;
//@property (nonatomic, strong) UIView *myFansView;
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
    self.view = self.tableView;
 
}
-(PIERefreshFooterTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PIERefreshFooterTableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.psDelegate = self;
        _tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 18, 0, 15);

        _tapMyFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyFansGesture:)];
        [_tableView addGestureRecognizer:_tapMyFansGesture];
    }
    return _tableView;
}
- (void) initValues {
    _isfirstLoading = YES;
    _canRefreshFooter = YES;
    _dataSource = [NSMutableArray array];

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
        PIEUserViewModel *viewModel = _dataSource[_selectedIndexPath.row];
        PIEFriendFansTableCell *cell = (PIEFriendFansTableCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p) || CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            PIEPageVM* vm = [PIEPageVM new];
            vm.userID = viewModel.model.uid;
            vm.username = viewModel.username;
            vm.avatarURL = viewModel.avatar;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        }
        
        else if (CGRectContainsPoint(cell.attentionButton.frame, p)) {
            cell.attentionButton.selected = !cell.attentionButton.selected;
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(cell.viewModel.model.uid) forKey:@"uid"];
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
        [_tableView.mj_footer endRefreshing];
    }
}

#pragma mark - GetDataSource

- (void)getDataSource {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@([DDUserManager currentUser].uid) forKeyedSubscript:@"uid"];
    [Hud activity:@"" inView:self.view];
    [DDUserManager getMyFans:param withBlock:^(NSArray *resultArray) {
        _isfirstLoading = NO;
        [Hud dismiss:self.view];
        [_dataSource removeAllObjects];
        for (PIEUserModel *model in resultArray) {
            PIEUserViewModel *vm = [[PIEUserViewModel alloc]initWithEntity:model];
            [_dataSource addObject:vm];
        }
        [_tableView reloadData];
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
    [DDUserManager getMyFans:param withBlock:^(NSArray *resultArray) {
        for (PIEUserModel *model in resultArray) {
            PIEUserViewModel *vm = [[PIEUserViewModel alloc]initWithEntity:model];
            [ws.dataSource addObject:vm];
        }
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.tableView.mj_footer endRefreshing];
        [ws.tableView reloadData];
    }];
}

@end
