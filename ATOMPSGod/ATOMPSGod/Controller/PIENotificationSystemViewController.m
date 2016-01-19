//
//  PIENotificationSystemViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/26/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationSystemViewController.h"
#import "PIERefreshTableView.h"
#import "PIENotificationManager.h"
#import "PIENotificationVM.h"
#import "PIENotificationSystemTableViewCell.h"

@interface PIENotificationSystemViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    PWRefreshBaseTableViewDelegate,
    DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate
>
@property (nonatomic, strong) NSMutableArray<PIENotificationVM *> *source;
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isfirstLoading;

@end

@implementation PIENotificationSystemViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    // Do any additional setup after loading the view.
    _source = [NSMutableArray<PIENotificationVM *> array];
    _canRefreshFooter = YES;
    _isfirstLoading = YES;
    
    self.view = self.tableView;
    //    [self getDataSource];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    [self.tableView.mj_header beginRefreshing];
}
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
#pragma mark - GetDataSource
- (void)getDataSource {
    _currentIndex = 1;
    [self.tableView.mj_footer endRefreshing];
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@"system" forKey:@"type"];

    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        _isfirstLoading = NO;
        if (source.count>0) {
            ws.source = [source mutableCopy];
            _canRefreshFooter = YES;
        }
        else {
            _canRefreshFooter = NO;
        }
        [ws.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - GetDataSource
- (void)getMoreDataSource {
    [self.tableView.mj_header endRefreshing];
    _currentIndex++;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@"system" forKey:@"type"];

    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        if (source.count < 15) {
            _canRefreshFooter = NO;
        }
        else {
            _canRefreshFooter = YES;
        }
        
        [ws.source addObjectsFromArray:source];
        [ws.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [Hud text:@"已经拉到底啦"];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
-(PIERefreshTableView *)tableView {
    if (!_tableView) {
        _tableView = [PIERefreshTableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.psDelegate = self;
        UINib* nib5 = [UINib nibWithNibName:@"PIENotificationSystemTableViewCell" bundle:nil];
        [_tableView registerNib:nib5 forCellReuseIdentifier:@"PIENotificationSystemTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 10);
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (_source.count > indexPath.row) {
            PIENotificationSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationSystemTableViewCell"];
            PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
            [cell injectSauce:vm];
            return cell;
        }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat height = CGRectGetHeight([vm.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 52, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil]);
    return 100+height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return _source.count;
}

#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无系统消息喔～";
    
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