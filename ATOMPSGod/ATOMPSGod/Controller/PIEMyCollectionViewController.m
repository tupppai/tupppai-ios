//
//  PIEMyCollectionViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyCollectionViewController.h"
#import "RefreshTableView.h"
#import "DDPageManager.h"
#import "PIEMyCollectionTableViewCell.h"
@interface PIEMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate>
@property (nonatomic, strong)  RefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyCollectionGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@end

@implementation PIEMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [RefreshTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.psDelegate = self;
    self.view = _tableView;
    UINib* nib = [UINib nibWithNibName:@"PIEMyCollectionTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"PIEMyCollectionTableViewCell"];
    _canRefreshFooter = YES;
    _currentPage = 1;
    _dataSource = [NSMutableArray array];
    [self getDataSource];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIEMyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIEMyCollectionTableViewCell"];
    if (!cell) {
        cell = [[PIEMyCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PIEMyCollectionTableViewCell"];
    }
    [cell injectSauce:[_dataSource objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
}

-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_tableView.footer endRefreshing];
    }
}
#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    [ws.tableView.footer endRefreshing];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];

    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getCollection:param withBlock:^(NSMutableArray *resultArray) {
        NSMutableArray* arrayAgent = [NSMutableArray new];
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [arrayAgent addObject:vm];
        }
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:arrayAgent];
        [ws.tableView reloadData];
        [ws.tableView.header endRefreshing];
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    [ws.tableView.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    _currentPage++;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getCollection:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [_dataSource addObject:vm];
        }
        [ws.tableView reloadData];
        [ws.tableView.footer endRefreshing];
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
    }];
}
@end
