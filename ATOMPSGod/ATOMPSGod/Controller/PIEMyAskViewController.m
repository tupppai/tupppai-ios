//
//  PIEMyAskViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyAskViewController.h"
#import "PIERefreshCollectionView.h"
#import "DDPageManager.h"
#import "PIETabBarController.h"
#import "AppDelegate.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEMyAskCollectionViewCell.h"
#import "PIECarouselViewController.h"
#import "DDNavigationController.h"
@interface PIEMyAskViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource,CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation PIEMyAskViewController



#pragma mark - Refresh
-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self getDataSource];
}
-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_collectionView.footer endRefreshing];
    }
}



#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    [ws.collectionView.footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getAsk:param withBlock:^(NSMutableArray *resultArray) {
        NSMutableArray* arrayAgent = [NSMutableArray new];
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [arrayAgent addObject:vm];
        }
        [ws.dataSource removeAllObjects];
        [ws.dataSource addObjectsFromArray:arrayAgent];
        [ws.collectionView reloadData];
        [ws.collectionView.header endRefreshing];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    [ws.collectionView.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDPageManager getAsk:param withBlock:^(NSMutableArray *resultArray) {
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
    layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 5);
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 6;
    
    _collectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.view = _collectionView;
    _collectionView.toRefreshBottom = YES;
    _collectionView.toRefreshTop = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, TAB_HEIGHT*2.5, 0);
    UINib* nib = [UINib nibWithNibName:@"PIEMyAskCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIEMyAskCollectionViewCell"];
    _canRefreshFooter = YES;
    _dataSource = [NSMutableArray array];
    
    [self getDataSource];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEMyAskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIEMyAskCollectionViewCell" forIndexPath:indexPath];
    DDPageVM *vm = _dataSource[indexPath.row];
    [cell injectSauce:vm];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

//    PIECarousel2ViewController* vc = [PIECarousel2ViewController new];
//    vc.pageVM = [_dataSource objectAtIndex:indexPath.row];
//    DDNavigationController* nav2 = [[DDNavigationController alloc]initWithRootViewController:vc];
//    [nav presentViewController:nav2 animated:YES completion:nil];
    PIECarouselViewController* vc = [PIECarouselViewController new];
    vc.pageVM = [_dataSource objectAtIndex:indexPath.row];
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES ];
}



#pragma mark - DZNEmptyDataSetSource & delegate
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"ic_cry"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"快去求P吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    DDPageVM* vm = [_dataSource objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH) /2 - 20;
    height = width;
//    height = vm.imageHeight/vm.imageWidth * width;
//    if (height > (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3) {
//        height = (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3;
//    }
    return CGSizeMake(width, height);
}


@end
