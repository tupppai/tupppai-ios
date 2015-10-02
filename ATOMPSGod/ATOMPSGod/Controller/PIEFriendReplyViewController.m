//
//  PIEFriendReplyViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendReplyViewController.h"
#import "DDOtherUserManager.h"
#import "RefreshTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PIEReplyTableCell.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self
static NSString *CellIdentifier = @"PIEReplyTableCell";

@interface PIEFriendReplyViewController ()<PWRefreshBaseTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) RefreshTableView *table;
@property (nonatomic, assign) BOOL canRefreshFooter;
@end

@implementation PIEFriendReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _source = [NSMutableArray array];
    _currentIndex = 1;
//    [self.view addSubview:self.table];
    self.view = self.table;

    [self getRemoteSource];
//    _tapGestureReply = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureReply:)];
//    [_table addGestureRecognizer:_tapGestureReply];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_table == tableView) {
        return _source.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_table == tableView) {
        PIEReplyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell injectSauce:_source[indexPath.row]];
        return cell;
    }
    else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_table == tableView) {
        return [tableView fd_heightForCellWithIdentifier:CellIdentifier  cacheByIndexPath:indexPath configuration:^(PIEReplyTableCell *cell) {
            [cell injectSauce:_source[indexPath.row]];
        }];
    } else {
        return 0;
    }
}

#pragma mark - GetDataSource
- (void)getRemoteSource {
    _currentIndex = 1;
    [_table.footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
        [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(1) forKey:@"page"];
    [DDOtherUserManager getFriendReply:param withBlock:^(NSMutableArray *returnArray) {
        NSMutableArray* arrayAgent = [NSMutableArray array];
        if (returnArray.count > 0) {
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [arrayAgent addObject:vm];
            }
            [_source removeAllObjects];
            [_source addObjectsFromArray:arrayAgent];
            [self.table reloadData];
            _canRefreshFooter = YES;
        } else {
            _canRefreshFooter = NO;
        }
        [self.table.header endRefreshing];
    }];
}

#pragma mark - GetDataSource
- (void)getMoreRemoteSource {
    _currentIndex++;
    [_table.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [DDOtherUserManager getFriendReply:param withBlock:^(NSMutableArray *returnArray) {
        NSMutableArray* arrayAgent = [NSMutableArray array];
        if (returnArray.count > 0) {
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [arrayAgent addObject:vm];
            }
            [_source addObjectsFromArray:arrayAgent];
            [self.table reloadData];
            _canRefreshFooter = YES;
        } else {
            _canRefreshFooter = NO;
        }
        [self.table.footer endRefreshing];
    }];
}

-(RefreshTableView *)table {
    if (!_table) {
        _table = [[RefreshTableView alloc] initWithFrame:CGRectZero];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.backgroundColor = [UIColor clearColor];
        _table.showsVerticalScrollIndicator = NO;
        _table.delegate = self;
        _table.dataSource = self;
        _table.psDelegate = self;
        UINib* nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [_table registerNib:nib forCellReuseIdentifier:CellIdentifier];
        _table.estimatedRowHeight = SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT;
        _table.scrollsToTop = YES;
    }
    return _table;
}
#pragma mark - Refresh

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getRemoteSource];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooter && !_table.header.isRefreshing) {
        [self getMoreRemoteSource];
    } else {
        [_table.footer endRefreshing];
    }
}


@end
