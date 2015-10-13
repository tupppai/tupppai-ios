//
//  ATOMMyCollectionViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyCollectionViewController.h"
#import "ATOMMyCollectionCollectionViewCell.h"
#import "DDDetailPageVC.h"


#import "ATOMCollectionViewModel.h"
#import "DDMyCollectionManager.h"
#import "PWRefreshFooterCollectionView.h"
#import "DDCommentVC.h"
#import "DDNavigationController.h"
#import "PIECarouselViewController.h"
#import "AppDelegate.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyCollectionGesture;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation ATOMMyCollectionViewController

static int padding = 2;
static float cellHeight;
static int collumnNumber = 2;
static float cellWidth;

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
    [DDMyCollectionManager getMyCollection:param withBlock:^(NSMutableArray *resultArray) {
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

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    cellWidth = (SCREEN_WIDTH - (collumnNumber - 1) *padding) / collumnNumber;
    cellHeight = cellWidth + 30;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding;
    flowLayout.minimumLineSpacing = padding;
    _collectionView = [[PWRefreshFooterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, TAB_HEIGHT*2, 0);
    self.view = _collectionView;
    _collectionView.dataSource = nil;
    _collectionView.emptyDataSetSource = self;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _cellIdentifier = @"MyCollectionCell";
    [_collectionView registerClass:[ATOMMyCollectionCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    _tapMyCollectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyCollectionGesture:)];
    [_collectionView addGestureRecognizer:_tapMyCollectionGesture];
    _canRefreshFooter = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self getDataSource];
}

#pragma mark - Gesture Event

- (void)tapMyCollectionGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        ATOMMyCollectionCollectionViewCell *cell = (ATOMMyCollectionCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        DDPageVM* model = _homeImageDataSource[indexPath.row];
        if (CGRectContainsPoint(cell.collectionImageView.frame, p)) {
            if (cell.viewModel.type == PIEPageTypeAsk) {
                if (cell.viewModel.totalPSNumber == 0) {
                    DDCommentVC* mvc = [DDCommentVC new];
                    mvc.vm = model;
                    [self.navigationController pushViewController:mvc animated:YES];
                } else {
                    DDDetailPageVC *hdvc = [DDDetailPageVC new];
                    hdvc.askVM = model;
                    hdvc.fold = 0;
                    [self.navigationController pushViewController:hdvc animated:YES];
                }
            } else {
                DDDetailPageVC *hdvc = [DDDetailPageVC new];
                hdvc.askVM = model;
                hdvc.fold = 1;
                [self.navigationController pushViewController:hdvc animated:YES];
            }
        } else if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {

        }   else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            //ATOMOtherPersonViewControlle *opvc = [//ATOMOtherPersonViewControlle new];
   
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMMyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PIECarouselViewController* vc = [PIECarouselViewController new];
    vc.pageVM = [_dataSource objectAtIndex:indexPath.row];
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES ];
}

//#pragma mark - DZNEmptyDataSetSource & delegate
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"ic_cry"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"你还没有任何收藏喔:-O";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
