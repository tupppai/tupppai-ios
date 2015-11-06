//
//  PIEMyAskViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyAskViewController.h"
#import "DDPageManager.h"
#import "PIETabBarController.h"
#import "AppDelegate.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEImageCollectionViewCell.h"
#import "PIECarouselViewController.h"
#import "DDNavigationController.h"
@interface PIEMyAskViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource,CHTCollectionViewDelegateWaterfallLayout,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;

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
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getAsk:param withBlock:^(NSMutableArray *resultArray) {
        NSMutableArray* arrayAgent = [NSMutableArray new];
        for (PIEPageEntity *entity in resultArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [arrayAgent addObject:vm];
        }
        [ws.dataSource removeAllObjects];
        [ws.dataSource addObjectsFromArray:arrayAgent];
        ws.isfirstLoading = NO;//should set to NO before reloadData
        [ws.collectionView reloadData];
        [ws.collectionView.header endRefreshing];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    [ws.collectionView.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
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
    [self.view addSubview: _collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.toRefreshBottom = YES;
    _collectionView.toRefreshTop = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    UINib* nib = [UINib nibWithNibName:@"PIEImageCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIEImageCollectionViewCell"];
    _canRefreshFooter = YES;
    _dataSource = [NSMutableArray array];
    _isfirstLoading = YES;
    [self getDataSource];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIEImageCollectionViewCell" forIndexPath:indexPath];
    DDPageVM *vm = _dataSource[indexPath.row];
    [cell injectSauce:vm];
    return cell;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat startContentOffsetY = scrollView.contentOffset.y;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (startContentOffsetY > scrollView.contentOffset.y ) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PIEMeScrollDown" object:nil];
        }
        else if (startContentOffsetY < scrollView.contentOffset.y)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PIEMeScrollUp" object:nil];
        }
    });
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    PIECarouselViewController* vc = [PIECarouselViewController new];
    vc.pageVM = [_dataSource objectAtIndex:indexPath.row];
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES ];
}



#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没发布过呢";
    
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
