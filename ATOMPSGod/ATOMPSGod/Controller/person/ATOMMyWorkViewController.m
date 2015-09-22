//
//  ATOMMyWorkViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyWorkViewController.h"
#import "ATOMMyWorkCollectionViewCell.h"
#import "DDDetailPageVC.h"
//#import "ATOMShowReply.h"
#import "PIEPageEntity.h"
#import "DDPageVM.h"
#import "ATOMReplyViewModel.h"
#import "PWRefreshFooterCollectionView.h"
#import "DDMyReplyManager.h"
#import "DDTabBarController.h"
#import "AppDelegate.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyWorkViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ATOMMyWorkViewController

static int padding6 = 6;
static float cellWidth;
static float cellHeight = 150;
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

    [param setObject:@(15) forKey:@"size"];
    [DDMyReplyManager getMyReply:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity *homeImage in resultArray) {
            DDPageVM *homepageViewModel = [DDPageVM new];
            homepageViewModel.ID = homeImage.askID;
            [ws.homeImageDataSource addObject:homepageViewModel];
            ATOMReplyViewModel *replyViewModel = [ATOMReplyViewModel new];
            replyViewModel.imageURL = homeImage.imageURL;
            [ws.dataSource addObject:replyViewModel];
        }
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
    [param setObject:@"hot" forKey:@"type"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDMyReplyManager getMyReply:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity *homeImage in resultArray) {
            DDPageVM *homepageViewModel = [DDPageVM new];
            [homepageViewModel setViewModelData:homeImage];
            ATOMReplyViewModel *replyViewModel = [ATOMReplyViewModel new];
            [replyViewModel setViewModelData:homeImage];
            [ws.dataSource addObject:replyViewModel];
            [ws.homeImageDataSource addObject:homepageViewModel];
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
    self.title = @"我的作品";
    cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *padding6) / 3;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding6;
    flowLayout.minimumLineSpacing = padding6;
    _collectionView = [[PWRefreshFooterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.view = _collectionView;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = nil;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _cellIdentifier = @"MyWorkCell";
    [_collectionView registerClass:[ATOMMyWorkCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    _canRefreshFooter = YES;
    _collectionView.emptyDataSetSource = self;
    [self getDataSource];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMMyWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    ATOMReplyViewModel *model = _dataSource[indexPath.row];
    [cell.workImageView setImageWithURL:[NSURL URLWithString:model.imageURL]placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DDDetailPageVC *hdvc = [DDDetailPageVC new];
    hdvc.askVM = _homeImageDataSource[indexPath.row];
    DDTabBarController* vc = (DDTabBarController *)[[AppDelegate APP]window].rootViewController;
    UINavigationController* nav = (UINavigationController*)vc.selectedViewController ;
    [nav pushViewController:hdvc animated:YES];
}



#pragma mark - DZNEmptyDataSetSource & delegate
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"ic_cry"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"快去帮助众生PS,成为PS大神吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}




@end
