//
//  ATOMMyUploadViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyUploadViewController.h"
#import "ATOMMyUploadCollectionViewCell.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMPageDetailViewController.h"
#import "ATOMShowAsk.h"
#import "ATOMHomeImage.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMAskViewModel.h"
#import "PWRefreshFooterCollectionView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyUploadViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate>

@property (nonatomic, strong) UIView *myUploadView;
@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@end

@implementation ATOMMyUploadViewController

static int padding6 = 6;
static float cellWidth;
static float cellHeight;
static int collumnNumber = 3;

#pragma mark - Refresh
-(void)didPullUpCollectionViewBottom {
    NSLog(@"didPullUpCollectionViewBottom");
    [self loadMoreData];
}
- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_collectionView.footer endRefreshing];
    }
    
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
//    [param setObject:@"new" forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowAsk *ShowMyAsk = [ATOMShowAsk new];
    [ShowMyAsk ShowMyAsk:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        for (ATOMHomeImage *homeImage in resultArray) {
            ATOMAskPageViewModel *homepageViewModel = [ATOMAskPageViewModel new];
            [homepageViewModel setViewModelData:homeImage];
            ATOMAskViewModel *askViewModel = [ATOMAskViewModel new];
            [askViewModel setViewModelData:homeImage];
            [ws.dataSource addObject:askViewModel];
            [ws.homeImageDataSource addObject:homepageViewModel];
        }
        [ws.collectionView reloadData];
    }];
}

- (void)getMoreDataSource {
    NSLog(@"getMoreDataSource");
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
//    [param setObject:@"new" forKey:@"type"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowAsk *ShowMyAsk = [ATOMShowAsk new];
    [ShowMyAsk ShowMyAsk:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        for (ATOMHomeImage *homeImage in resultArray) {
            ATOMAskPageViewModel *homepageViewModel = [ATOMAskPageViewModel new];
            [homepageViewModel setViewModelData:homeImage];
            ATOMAskViewModel *askViewModel = [ATOMAskViewModel new];
            [askViewModel setViewModelData:homeImage];
            [ws.dataSource addObject:askViewModel];
            [ws.homeImageDataSource addObject:homepageViewModel];
        }
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
            NSLog(@"canRefreshFooter = NO");
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.collectionView.footer endRefreshing];
        [ws.collectionView reloadData];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"我的求P";
    _myUploadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _myUploadView.backgroundColor = [UIColor whiteColor];
    cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *padding6) / 3;
    cellHeight = cellWidth;
    self.view = _myUploadView;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding6;
    flowLayout.minimumLineSpacing = padding6;
    _collectionView = [[PWRefreshFooterCollectionView alloc] initWithFrame:CGRectInset(_myUploadView.frame, padding6, padding6) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_myUploadView addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _cellIdentifier = @"MyUploadCell";
    [_collectionView registerClass:[ATOMMyUploadCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMMyUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    ATOMAskViewModel *model = _dataSource[indexPath.row];
    [cell.workImageView setImageWithURL:[NSURL URLWithString:model.imageURL]];
    cell.totalPSNumber = model.totalPSNumber;
    cell.colorType = 1;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ATOMAskViewModel *askViewModel = _dataSource[indexPath.row];
    ATOMAskPageViewModel *homepageViewModel = _homeImageDataSource[indexPath.row];
    if ([askViewModel.totalPSNumber integerValue] == 0) {
        ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
        rdvc.pageDetailViewModel = [homepageViewModel generatepageDetailViewModel];
        [self pushViewController:rdvc animated:YES];
    } else {
        ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
        hdvc.askPageViewModel = homepageViewModel;
        [self pushViewController:hdvc animated:YES];
    }
}


@end
