//
//  ATOMMyCollectionViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyCollectionViewController.h"
#import "ATOMMyCollectionCollectionViewCell.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMHomeImage.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMCollectionViewModel.h"
#import "ATOMShowCollection.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *myWorkView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyCollectionGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation ATOMMyCollectionViewController

static int padding6 = 6;
static float cellHeight;
static int collumnNumber = 2;
static float cellWidth;

#pragma mark - Refresh

- (void)configCollectionViewRefresh {
    [_collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    [param setObject:@"new" forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowCollection *showCollection = [ATOMShowCollection new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showCollection ShowCollection:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMHomeImage *homeImage in resultArray) {
            ATOMHomePageViewModel *homepageViewModel = [ATOMHomePageViewModel new];
            [homepageViewModel setViewModelData:homeImage];
            [ws.homeImageDataSource addObject:homepageViewModel];
            ATOMCollectionViewModel *collectionViewModel = [ATOMCollectionViewModel new];
            [collectionViewModel setViewModelData:homeImage];
            [ws.dataSource addObject:collectionViewModel];
        }
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
    ATOMShowCollection *showCollection = [ATOMShowCollection new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showCollection ShowCollection:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMHomeImage *homeImage in resultArray) {
            ATOMHomePageViewModel *homepageViewModel = [ATOMHomePageViewModel new];
            [homepageViewModel setViewModelData:homeImage];
            [ws.homeImageDataSource addObject:homepageViewModel];
            ATOMCollectionViewModel *collectionViewModel = [ATOMCollectionViewModel new];
            [collectionViewModel setViewModelData:homeImage];
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

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"我的收藏";
    _myWorkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    cellWidth = (SCREEN_WIDTH - (collumnNumber - 1) *padding6) / collumnNumber;
    cellHeight = cellWidth + 50;
    self.view = _myWorkView;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding6;
    flowLayout.minimumLineSpacing = padding6;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(_myWorkView.frame, 0, 0) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithHex:0xededed];
    [_myWorkView addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _cellIdentifier = @"MyCollectionCell";
    [_collectionView registerClass:[ATOMMyCollectionCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    _tapMyCollectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyCollectionGesture:)];
    [_collectionView addGestureRecognizer:_tapMyCollectionGesture];
    [self configCollectionViewRefresh];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - Gesture Event

- (void)tapMyCollectionGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        ATOMMyCollectionCollectionViewCell *cell = (ATOMMyCollectionCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.collectionImageView.frame, p)) {
            ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
            hdvc.homePageViewModel = _homeImageDataSource[indexPath.row];
            [self pushViewController:hdvc animated:YES];
        } else if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        }
        
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMMyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

@end
