//
//  ATOMMyWorkViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEMyReplyViewController.h"


#import "PIERefreshCollectionView.h"
#import "DDPageManager.h"
#import "PIETabBarController.h"

#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEMyReplyCollectionViewCell.h"

#import "DDNavigationController.h"
#import "PIECarouselViewController2.h"
#import "DeviceUtil.h"

@interface PIEMyReplyViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;

//@property (nonatomic, assign)  BOOL shouldGetNewDataSourceWhenViewWillAppear;

@end

@implementation PIEMyReplyViewController



#pragma mark - Refresh

-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    [self loadMoreData];

}
-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self getDataSource];
}
- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [Hud text:@"已经拉到底啦"];
        [_collectionView.mj_footer endRefreshingWithNoMoreData];
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
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"]; 
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getReply:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshFooter = NO;
        }else{
            _canRefreshFooter = YES;
        }
        
        NSMutableArray* arrayAgent = [NSMutableArray new];
        for (PIEPageModel *entity in resultArray) {
            PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
            [arrayAgent addObject:vm];
        }
        [ws.dataSource removeAllObjects];
        [ws.dataSource addObjectsFromArray:arrayAgent];
        ws.isfirstLoading = NO;
        [ws.collectionView reloadData];
        [ws.collectionView.mj_header endRefreshing];
        
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    [ws.collectionView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@"hot" forKey:@"type"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDPageManager getReply:param withBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count < 15) {
            _canRefreshFooter = NO;
        } else {
            _canRefreshFooter = YES;
        }
        
        for (PIEPageModel *entity in resultArray) {
            PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
            [ws.dataSource addObject:vm];
        }
        [ws.collectionView.mj_footer endRefreshing];
        [ws.collectionView reloadData];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setupObservers];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupObservers {
    [[RACObserve([DDUserManager currentUser],replyNumber)
      skip:1]
     subscribeNext:^(id x) {
         [self.collectionView.mj_header beginRefreshing];
     }];
}


- (void)createUI {
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 10;
    
    _collectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview: _collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.toRefreshBottom = YES;
    _collectionView.toRefreshTop = YES;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    UINib* nib = [UINib nibWithNibName:@"PIEMyReplyCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIEMyReplyCollectionViewCell"];
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
    PIEMyReplyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIEMyReplyCollectionViewCell" forIndexPath:indexPath];
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
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_isfirstLoading;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没上传过呢";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm = [_dataSource objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH) /2 - 20;
    height = vm.imageRatio * width;
    height = MAX(150, height);
    height = MIN(SCREEN_HEIGHT/2, height);

    return CGSizeMake(width, height);
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


@end
