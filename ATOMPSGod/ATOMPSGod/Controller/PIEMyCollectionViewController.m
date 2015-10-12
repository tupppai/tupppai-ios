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
@interface PIEMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet RefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyCollectionGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@end

@implementation PIEMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UINib* nib = [UINib nibWithNibName:@"PIEMyCollectionTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"PIEMyCollectionTableViewCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    _dataSource = nil;
    _dataSource = [NSMutableArray array];
    _homeImageDataSource = nil;
    _homeImageDataSource = [NSMutableArray array];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getMyCollection:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [ws.homeImageDataSource addObject:vm];
            ATOMCollectionViewModel *collectionViewModel = [ATOMCollectionViewModel new];
            [collectionViewModel setViewModelData:entity];
            [ws.dataSource addObject:collectionViewModel];
        }
        _collectionView.dataSource = self;
        [ws.collectionView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@"new" forKey:@"type"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDMyCollectionManager getMyCollection:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity* entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [ws.homeImageDataSource addObject:vm];
            ATOMCollectionViewModel *collectionViewModel = [ATOMCollectionViewModel new];
            [collectionViewModel setViewModelData:entity];
            [ws.dataSource addObject:collectionViewModel];
        }
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.collectionView.footer endRefreshing];
        [ws.collectionView reloadData];
    }];
}
@end
