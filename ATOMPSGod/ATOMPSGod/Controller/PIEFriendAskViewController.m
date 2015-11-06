//
//  PIEFriendReplyViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendAskViewController.h"
#import "DDOtherUserManager.h"
#import "PIERefreshTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PIEFriendAskTableViewCell.h"
#import "DDPageManager.h"

@interface PIEFriendAskViewController ()<PWRefreshBaseTableViewDelegate,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) PIERefreshTableView *table;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;

@end

@implementation PIEFriendAskViewController
 NSString *cellIdentifier = @"PIEFriendAskTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _source = [NSMutableArray array];
    _currentIndex = 1;
    [self.view addSubview: self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    UINib* nib = [UINib nibWithNibName:@"PIEFriendAskTableViewCell" bundle:nil];
    [self.table registerNib:nib forCellReuseIdentifier:cellIdentifier];
    self.table.emptyDataSetSource = self;
    self.table.emptyDataSetDelegate = self;
    _isfirstLoading = YES;
    [self getRemoteSource];
    
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
        PIEFriendAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cell injectSource:_source[indexPath.row]];
        return cell;
    }
    else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_table == tableView) {
        return 168;
    } else {
        return 0;
    }
}

#pragma mark - GetDataSource
- (void)getRemoteSource {
    _currentIndex = 1;
    [_table.footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(1) forKey:@"page"];
    [DDPageManager getAskWithReplies:param withBlock:^(NSArray *returnArray) {
        _isfirstLoading = NO;
        if (returnArray.count > 0) {
            [_source removeAllObjects];
            [_source addObjectsFromArray:returnArray];
            _canRefreshFooter = YES;
        } else {
            _canRefreshFooter = NO;
        }
        [self.table reloadData];
        [self.table.header endRefreshing];
    }];
}

#pragma mark - GetDataSource
- (void)getMoreRemoteSource {
    _currentIndex++;
    [_table.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [DDPageManager getAskWithReplies:param withBlock:^(NSArray *returnArray) {
        if (returnArray.count > 0) {
            [_source addObjectsFromArray:returnArray];
            _canRefreshFooter = YES;
        } else {
            _canRefreshFooter = NO;
        }
        [self.table reloadData];
        [self.table.footer endRefreshing];
    }];
}

-(PIERefreshTableView *)table {
    if (!_table) {
        _table = [[PIERefreshTableView alloc] initWithFrame:CGRectZero];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _table.showsVerticalScrollIndicator = NO;
        _table.delegate = self;
        _table.dataSource = self;
        _table.psDelegate = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat startContentOffsetY = scrollView.contentOffset.y;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (startContentOffsetY > scrollView.contentOffset.y ) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PIEFriendScrollDown" object:nil];
        }
        else if (startContentOffsetY < scrollView.contentOffset.y)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PIEFriendScrollUp" object:nil];
        }
    });
}
#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"他竟然还没有求P哦～";
    
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

@end
