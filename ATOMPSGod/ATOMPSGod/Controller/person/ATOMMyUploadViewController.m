//
//  ATOMMyUploadViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyUploadViewController.h"
#import "ATOMMyUploadCollectionViewCell.h"
#import "DDDetailPageVC.h"
#import "DDCommentVC.h"
#import "PIEPageEntity.h"
#import "DDPageVM.h"
#import "ATOMAskViewModel.h"
#import "PWRefreshFooterCollectionView.h"
#import "DDMyAskManager.h"
#import "DDMyReplyManager.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyUploadViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UIView *myUploadView;
@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@end

@implementation ATOMMyUploadViewController

static int padding = 2;
static float cellWidth;
static float cellHeight;
static int collumnNumber = 3;

#pragma mark - Refresh
-(void)didPullUpCollectionViewBottom:(PWRefreshFooterCollectionView *)collectionView {
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
    [[KShareManager mascotAnimator]show];
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
    [DDMyAskManager getMyAsk:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            ATOMAskViewModel *askViewModel = [ATOMAskViewModel new];
            [askViewModel setViewModelData:entity];
            [ws.dataSource addObject:askViewModel];
            [ws.homeImageDataSource addObject:vm];
        }
        [[KShareManager mascotAnimator]dismiss];
        ws.collectionView.dataSource = self;
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
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    [DDMyAskManager getMyAsk:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            ATOMAskViewModel *askViewModel = [ATOMAskViewModel new];
            [askViewModel setViewModelData:entity];
            [ws.dataSource addObject:askViewModel];
            [ws.homeImageDataSource addObject:vm];
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
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"我的求P";
    _myUploadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _myUploadView.backgroundColor = [UIColor whiteColor];
    cellWidth = (SCREEN_WIDTH - (collumnNumber + 2) *padding) / 3;
    cellHeight = cellWidth;
    self.view = _myUploadView;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding;
    flowLayout.minimumLineSpacing = padding;
    _collectionView = [[PWRefreshFooterCollectionView alloc] initWithFrame:CGRectInset(_myUploadView.frame, padding, padding) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_myUploadView addSubview:_collectionView];
    _collectionView.emptyDataSetSource = self;
    _collectionView.dataSource = nil;
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
    [cell.workImageView setImageWithURL:[NSURL URLWithString:model.imageURL]placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
    cell.totalPSNumber = model.totalPSNumber;
    cell.colorType = 1;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMAskViewModel *askViewModel = _dataSource[indexPath.row];
    DDPageVM *homepageViewModel = _homeImageDataSource[indexPath.row];
    if ([askViewModel.totalPSNumber integerValue] == 0) {
        
        DDCommentVC* mvc = [DDCommentVC new];
        mvc.vm = [homepageViewModel generatepageDetailViewModel];;
//        mvc.delegate = self;
        [self pushViewController:mvc animated:YES];

    } else {
        DDDetailPageVC *hdvc = [DDDetailPageVC new];
        hdvc.fold = 0;
        hdvc.askVM = homepageViewModel;
        [self pushViewController:hdvc animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetSource & delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"快去上传你的照片，让大神来帮你PS吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
