//
//  PIEProceedingDoneViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/14.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingDoneViewController.h"
#import "PIERefreshCollectionView.h"
#import "PIEDoneCollectionViewCell.h"
#import "PIECarouselViewController.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
#import "PIEProceedingManager.h"


/* Private Variables */
@interface PIEProceedingDoneViewController ()

@property (nonatomic, assign) BOOL isfirstLoadingDone;
@property (nonatomic, strong) NSMutableArray *sourceDone;
@property (nonatomic, assign) NSInteger currentIndex_Done;
@property (nonatomic, assign)  long long timeStamp_done;
@property (nonatomic, assign) BOOL canRefreshDoneFooter;
@property (nonatomic, strong) PIERefreshCollectionView *doneCollectionView;

@end

/* Protocols */
@interface PIEProceedingDoneViewController (CollectionView)
<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@end

@interface PIEProceedingDoneViewController (RefreshingCollectionView)
<PWRefreshBaseCollectionViewDelegate>
@end

@interface PIEProceedingDoneViewController (DZNEmptyDataSet)
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@end

@implementation PIEProceedingDoneViewController


#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refreshing Methods
- (void)getSourceIfEmpty_done {
    if (_sourceDone.count <= 0 || _isfirstLoadingDone) {
        [self.doneCollectionView.mj_header beginRefreshing];
    }
}

#pragma mark - UI components setup

// --- 考虑改写为懒加载
- (void)initDone {
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 10;
    _doneCollectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT) collectionViewLayout:layout];
    _doneCollectionView.toRefreshBottom = YES;
    _doneCollectionView.backgroundColor = [UIColor clearColor];
    _doneCollectionView.toRefreshTop = YES;
    _doneCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)configDoneCollectionView {
    self.doneCollectionView.dataSource           = self;
    self.doneCollectionView.delegate             = self;
    self.doneCollectionView.psDelegate           = self;
    self.doneCollectionView.emptyDataSetSource   = self;
    self.doneCollectionView.emptyDataSetDelegate = self;
    UINib* nib = [UINib nibWithNibName:@"PIEDoneCollectionViewCell" bundle:nil];
    [self.doneCollectionView registerNib:nib forCellWithReuseIdentifier:@"PIEDoneCollectionViewCell"];
}

#pragma mark - setup Data
- (void)configData
{
    _canRefreshDoneFooter = YES;
    
    _isfirstLoadingDone = YES;
    
    _currentIndex_Done = 1;
    
    _sourceDone = [NSMutableArray new];
}

#pragma mark - Gesture Events
- (void)setupGestures
{
    // nothing yet.
}

#pragma mark - <PWRefreshBaseCollectionViewDelegate>
-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
        [self getRemoteSourceDone];
}

-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    if (_canRefreshDoneFooter) {
        [self getMoreRemoteSourceDone];
    } else {
        [_doneCollectionView.mj_footer endRefreshing];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return _sourceDone.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEDoneCollectionViewCell *cell =
    (PIEDoneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIEDoneCollectionViewCell"
                                  forIndexPath:indexPath];
    [cell injectSauce:[_sourceDone objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PIECarouselViewController* vc = [PIECarouselViewController new];
    vc.pageVM = [_sourceDone objectAtIndex:indexPath.row];
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES ];
}

#pragma mark - <CHTCollectionViewDelegateWaterfallLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm = [_sourceDone objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width         = (SCREEN_WIDTH) /2 - 20;
    height        = vm.imageHeight/vm.imageWidth * width;
    height        = MAX(150, height);
    height        = MIN(SCREEN_HEIGHT/2, height);
    return CGSizeMake(width, height);
}

#pragma mark - Network fetching data

- (void)getRemoteSourceDone {
    WS(ws);
    [ws.doneCollectionView.mj_footer endRefreshing];
    _currentIndex_Done         = 1;
    _timeStamp_done            = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(1) forKey:@"page"];
    //    [param setObject:@(SCREEN_WIDTH/2) forKey:@"width"];
    [param setObject:@(_timeStamp_done) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    
    [PIEProceedingManager getMyDone:param withBlock:^(NSMutableArray *resultArray) {
        ws.isfirstLoadingDone = NO;
        if (resultArray.count == 0) {
            _canRefreshDoneFooter = NO;
        } else {
            _canRefreshDoneFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:homeImage];
                [sourceAgent addObject:vm];
            }
            
            [ws.sourceDone removeAllObjects];
            [ws.sourceDone addObjectsFromArray:sourceAgent];
        }
        [ws.doneCollectionView.mj_header endRefreshing];
        [ws.doneCollectionView reloadData];
    }];
}

- (void)getMoreRemoteSourceDone {
    WS(ws);
    [ws.doneCollectionView.mj_header endRefreshing];
    _currentIndex_Done++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex_Done) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH/2) forKey:@"width"];
    [param setObject:@(_timeStamp_done) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    
    [PIEProceedingManager getMyDone:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshDoneFooter = NO;
        } else {
            _canRefreshDoneFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sourceDone addObjectsFromArray:sourceAgent];
        }
        [ws.doneCollectionView.mj_footer endRefreshing];
        [ws.doneCollectionView reloadData];
    }];
}

#pragma mark - <DZNEmptyDataSetSource & delegate>
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"还没内容呀，加把劲啊啊啊马上来上传";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_isfirstLoadingDone;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


@end
