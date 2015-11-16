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
//#import "PIENotificationReplyTableViewCell.h"
//#import "PIENotificationLikeTableViewCell.h"
//#import "PIENotificationFollowTableViewCell.h"
//#import "PIENotificationCommentTableViewCell.h"

@interface PIENotificationSystemViewController ()<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isfirstLoading;

@end

@implementation PIENotificationSystemViewController
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    // Do any additional setup after loading the view.
    _source = [NSMutableArray array];
    _canRefreshFooter = YES;
    self.view = self.tableView;
    //    [self getDataSource];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    _isfirstLoading = YES;
    [self.tableView.header beginRefreshing];
}

#pragma mark - GetDataSource
- (void)getDataSource {
    _currentIndex = 1;
    [self.tableView.footer endRefreshing];
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
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - GetDataSource
- (void)getMoreDataSource {
    [self.tableView.header endRefreshing];
    _currentIndex++;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@"fold" forKey:@"type"];

    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        if (source.count>0) {
            [ws.source addObjectsFromArray:source];
            [ws.tableView reloadData];
            _canRefreshFooter = YES;
        }
        else {
            _canRefreshFooter = NO;
        }
        [self.tableView.footer endRefreshing];
    }];
}

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [self.tableView.footer endRefreshing];
    }
}
-(PIERefreshTableView *)tableView {
    if (!_tableView) {
        _tableView = [PIERefreshTableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.psDelegate = self;
//        UINib* nib  = [UINib nibWithNibName:@"PIENotificationCommentTableViewCell" bundle:nil];
        //        UINib* nib2 = [UINib nibWithNibName:@"PIENotificationLikeTableViewCell" bundle:nil];
//        UINib* nib3 = [UINib nibWithNibName:@"PIENotificationFollowTableViewCell" bundle:nil];
//        UINib* nib4 = [UINib nibWithNibName:@"PIENotificationReplyTableViewCell" bundle:nil];
                UINib* nib5 = [UINib nibWithNibName:@"PIENotificationSystemTableViewCell" bundle:nil];
//        [_tableView registerNib:nib  forCellReuseIdentifier:@"PIENotificationCommentTableViewCell"];
        //        [_tableView registerNib:nib2 forCellReuseIdentifier:@"PIENotificationLikeTableViewCell"];
//        [_tableView registerNib:nib3 forCellReuseIdentifier:@"PIENotificationFollowTableViewCell"];
        [_tableView registerNib:nib5 forCellReuseIdentifier:@"PIENotificationSystemTableViewCell"];
        //        [_tableView registerNib:nib5 forCellReuseIdentifier:@"PIENotificationSystemTableViewCell"];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (_source.count > indexPath.row) {
            PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
            PIENotificationSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationSystemTableViewCell"];
            [cell injectSauce:vm];
            return cell;
        }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat height = CGRectGetHeight([vm.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 52, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil]);
    return 80+height;
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