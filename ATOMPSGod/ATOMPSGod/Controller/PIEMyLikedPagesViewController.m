//
//  PIEMyLikedPagesViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/17/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyLikedPagesViewController.h"



#import "PIERefreshCollectionView.h"
#import "DDPageManager.h"
#import "PIETabBarController.h"
#import "AppDelegate.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEImageCollectionViewCell.h"
#import "PIECarouselViewController2.h"
#import "DDNavigationController.h"
#import "DeviceUtil.h"
@interface PIEMyLikedPagesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource,CHTCollectionViewDelegateWaterfallLayout,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;
@end

@implementation PIEMyLikedPagesViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark - Refresh
-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self getDataSource];
}
-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_collectionView.mj_footer endRefreshing];
    }
}



#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    [ws.collectionView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getLikedPages:param withBlock:^(NSMutableArray *resultArray) {
        ws.dataSource = resultArray;
        ws.isfirstLoading = NO;//should set to NO before reloadData
        [ws.collectionView reloadData];
        [ws.collectionView.mj_header endRefreshing];
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    [ws.collectionView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDPageManager getLikedPages:param withBlock:^(NSMutableArray *resultArray) {

        [ws.dataSource addObjectsFromArray:resultArray];

        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.collectionView.mj_footer endRefreshing];
        [ws.collectionView reloadData];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"我赞过的";
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(4, 6, 0, 6);
    layout.minimumColumnSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    layout.columnCount = 3;
    _collectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.view = _collectionView;
    _collectionView.toRefreshBottom = YES;
    _collectionView.toRefreshTop = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, TAB_HEIGHT*2.5, 0);
    UINib* nib = [UINib nibWithNibName:@"PIEImageCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIEImageCollectionViewCell"];
    _canRefreshFooter = YES;
    _dataSource = [NSMutableArray array];
    _isfirstLoading = YES;

    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIEImageCollectionViewCell" forIndexPath:indexPath];
    PIEPageVM *vm = _dataSource[indexPath.row];
    [cell injectSauce:vm];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
    vc.pageVM = [_dataSource objectAtIndex:indexPath.row];
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    [nav presentViewController:vc animated:YES completion:nil];
}



#pragma mark - DZNEmptyDataSetSource & delegate
#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有赞过别人哦";
    
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

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH) / 4 - 30;
    height = width;

    return CGSizeMake(width, height);
}
@end
