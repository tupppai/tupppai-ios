//
//  ATOMMyWorkViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEMyReplyViewController.h"
//#import "ATOMMyWorkCollectionViewCell.h"
#import "DDDetailPageVC.h"


#import "ATOMReplyViewModel.h"
#import "PWRefreshFooterCollectionView.h"
#import "DDPageManager.h"
#import "PIETabBarController.h"
#import "AppDelegate.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEMyReplyCollectionViewCell.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEMyReplyViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation PIEMyReplyViewController



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
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getReply:param withBlock:^(NSMutableArray *resultArray) {
        NSMutableArray* arrayAgent = [NSMutableArray new];
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [arrayAgent addObject:vm];
        }
        [ws.dataSource removeAllObjects];
        [ws.dataSource addObjectsFromArray:arrayAgent];
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
    
    [DDPageManager getReply:param withBlock:^(NSMutableArray *resultArray) {
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [ws.dataSource addObject:vm];
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
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 10;
    
    _collectionView = [[PWRefreshFooterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.view = _collectionView;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = nil;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _collectionView.emptyDataSetSource = self;
    
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, TAB_HEIGHT*3, 0);
    UINib* nib = [UINib nibWithNibName:@"PIEMyReplyCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIEMyReplyCollectionViewCell"];
    _canRefreshFooter = YES;
    _dataSource = [NSMutableArray array];

    [self getDataSource];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEMyReplyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIEMyReplyCollectionViewCell" forIndexPath:indexPath];
    DDPageVM *vm = _dataSource[indexPath.row];
    [cell injectSauce:vm];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

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

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDPageVM* vm = [_dataSource objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH) /2 - 20;
    height = vm.imageHeight/vm.imageWidth * width;
    if (height > (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3) {
        height = (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3;
    }
    return CGSizeMake(width, height);
}



@end
