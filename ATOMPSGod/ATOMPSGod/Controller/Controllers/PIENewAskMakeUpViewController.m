//
//  PIENewAskMakeUpViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/7.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENewAskMakeUpViewController.h"
#import "PIERefreshCollectionView.h"
#import "PIEPageManager.h"
#import "PIENewAskCollectionCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEShareView.h"
#import "PIECarouselViewController2.h"
#import "PIECommentViewController.h"
#import "PIEFriendViewController.h"
#import "PIEActionSheet_PS.h"
#import "AppDelegate.h"
#import "MRNavigationBarProgressView.h"
#import "PIEUploadManager.h"

/* Variables */
@interface PIENewAskMakeUpViewController ()

@property (nonatomic, assign) BOOL                        isfirstLoadingAsk;
@property (nonatomic, strong) NSMutableArray              *sourceAsk;
@property (nonatomic, assign) NSInteger                   currentIndex_ask;
@property (nonatomic, assign) long long                   timeStamp_ask;
@property (nonatomic, assign) BOOL                        canRefreshFooter_ask;
@property (nonatomic, strong) PIERefreshCollectionView    *collectionView_ask;
@property (nonatomic, strong) PIEPageVM                   *selectedVM;
@property (nonatomic, strong) PIEShareView                *shareView;
@property (nonatomic, strong) PIEActionSheet_PS           *psActionSheet;
@property (nonatomic, strong) MRNavigationBarProgressView *progressView;

@end


/* Delegates */
@interface PIENewAskMakeUpViewController (CollectionView)
<UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>
@end

@interface PIENewAskMakeUpViewController (DZNEmptyDataSet)
<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@end

@interface PIENewAskMakeUpViewController (PWRefreshBaseCollectionView)
<PWRefreshBaseCollectionViewDelegate>
@end

@interface PIENewAskMakeUpViewController (ShareView)
<PIEShareViewDelegate>
@end

@implementation PIENewAskMakeUpViewController

static NSString *CellIdentifier2 = @"PIENewAskCollectionCell";

#pragma mark - UI life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view = self.collectionView_ask;
//    self.collectionView_ask.backgroundColor = [UIColor whiteColor];
    
    [self setupGestures];
    [self setupData];
    [self firstGetSourceIfEmpty_ask];
    [self setupNotifications];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - property first initiation
- (void) setupData {
    //set this before firstGetRemoteSource

    _canRefreshFooter_ask = YES;

    _isfirstLoadingAsk    = YES;

    _sourceAsk            = [NSMutableArray new];

    _currentIndex_ask     = 1;

}


#pragma mark - UI components setup

- (void)setupCollectionView_ask {
    
}

#pragma mark - Get DataSource from Server for the first time
- (void)firstGetSourceIfEmpty_ask {
    if (_sourceAsk.count <= 0 || _isfirstLoadingAsk) {
        [self.collectionView_ask.mj_header beginRefreshing];
    }
}

#pragma mark - Fetch data Ask
//获取服务器的最新数据
- (void)getRemoteAskSource:(void (^)(BOOL finished))block{
    
    
    [self.collectionView_ask.mj_footer endRefreshing];
    _currentIndex_ask = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    _timeStamp_ask = [[NSDate date] timeIntervalSince1970];
    
    /**
     *  参数：传递上次更新的时间
     *
     *  @param _timeStamp_ask 上次更新的shijian (NSDate now)
     */
    [param setObject:@(_timeStamp_ask) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    
    
    
    PIEPageManager *pageManager = [PIEPageManager new];
    
    __weak typeof(self) weakSelf = self;
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        weakSelf.isfirstLoadingAsk = NO;
        if (homepageArray.count) {
            weakSelf.sourceAsk = homepageArray;
            _canRefreshFooter_ask = YES;
        }
        else {
            _canRefreshFooter_ask = NO;
        }
        
        [weakSelf.collectionView_ask reloadData];
        [weakSelf.collectionView_ask.mj_header endRefreshing];
        
        // ???
        if (block) {
            block(YES);
        }
    }];
}

//拉至底层刷新
- (void)getMoreRemoteAskSource {

    __weak typeof(self) weakSelf = self;
 
    [weakSelf.collectionView_ask.mj_header endRefreshing];
    _currentIndex_ask++;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_timeStamp_ask) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(_currentIndex_ask) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    PIEPageManager *pageManager = [PIEPageManager new];
    
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        if (homepageArray.count) {
            [weakSelf.sourceAsk addObjectsFromArray:homepageArray];
            _canRefreshFooter_ask = YES;
        }
        else {
            _canRefreshFooter_ask = NO;
        }
        [weakSelf.collectionView_ask reloadData];
        [weakSelf.collectionView_ask.mj_footer endRefreshing];
    }];
}

#pragma mark - Refresh methods (Header & Footer)
- (void)loadNewData_ask {
    [self getRemoteAskSource:nil];
}

- (void)loadMoreData_ask {
    if (_canRefreshFooter_ask && !_collectionView_ask.mj_header.isRefreshing) {
        [self getMoreRemoteAskSource];
    } else {
        [_collectionView_ask.mj_footer endRefreshing];
    }
}



#pragma mark - <PWRefreshBaseCollectionViewDelegate>
-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self loadNewData_ask];
}

-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    [self loadMoreData_ask];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceAsk.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PIENewAskCollectionCell *cell =
    (PIENewAskCollectionCell *)
    [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2
                                              forIndexPath:indexPath];
    
    
    [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - <CHTCollectionViewDelegateWaterfallLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm = [_sourceAsk objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width         = (SCREEN_WIDTH - 20) / 2.0;
    height        = vm.imageHeight/vm.imageWidth * width + 129 + (29+20);
    height        = MAX(200,height);
    height        = MIN(SCREEN_HEIGHT/1.5, height);
    return CGSizeMake(width, height);
}


#pragma mark - Gesture Event

- (void)setupGestures {
    UITapGestureRecognizer* tapGestureAsk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnAsk:)];
    UILongPressGestureRecognizer* longPressGestureAsk = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnAsk:)];
    
    [_collectionView_ask addGestureRecognizer:tapGestureAsk];
    [_collectionView_ask addGestureRecognizer:longPressGestureAsk];
}


- (void)longPressOnAsk:(UILongPressGestureRecognizer *)gesture {

    CGPoint location = [gesture locationInView:_collectionView_ask];
    NSIndexPath *indexPath = [_collectionView_ask indexPathForItemAtPoint:location];
    if (indexPath) {
        PIENewAskCollectionCell* cell= (PIENewAskCollectionCell *)[_collectionView_ask cellForItemAtIndexPath:indexPath];
        _selectedVM = _sourceAsk[indexPath.row];
        CGPoint p = [gesture locationInView:cell];
        //点击大图
        if (CGRectContainsPoint(cell.leftImageView.frame, p) || CGRectContainsPoint(cell.rightImageView.frame, p)) {
            [self showShareView];
        }
    }
    
}

- (void)tapOnAsk:(UITapGestureRecognizer *)gesture {
        CGPoint location = [gesture locationInView:_collectionView_ask];
        NSIndexPath *indexPath = [_collectionView_ask indexPathForItemAtPoint:location];
        if (indexPath) {
            PIENewAskCollectionCell*  cell = (PIENewAskCollectionCell *)[_collectionView_ask cellForItemAtIndexPath:indexPath];
            _selectedVM                    = _sourceAsk[indexPath.row];
            CGPoint p                      = [gesture locationInView:cell];
            
            //点击大图
            if (CGRectContainsPoint(cell.leftImageView.frame, p) || CGRectContainsPoint(cell.rightImageView.frame, p)) {
                if (![_selectedVM.replyCount isEqualToString:@"0"]) {
                    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                    vc.pageVM                      = _selectedVM;
                    [self presentViewController:vc animated:YES completion:nil];
                } else {
                    PIECommentViewController* vc = [PIECommentViewController new];
                    vc.vm                        = _selectedVM;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            //点击头像
            else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self.navigationController pushViewController:friendVC animated:YES];
            }
            
            //点击用户名
            else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self.navigationController pushViewController:friendVC animated:YES];
            }
            //点击帮p
            else if (CGRectContainsPoint(cell.bangView.frame, p)) {
                self.psActionSheet.vm = _selectedVM;
                
                // TODO: REFACTOR 创建单例，而不是AppDelegate
                [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
            }
        }
}

#pragma mark - Notification methods
- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_New" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDoUploadJob) name:@"UploadRightNow" object:nil];
}

- (void)shouldDoUploadJob {
    _progressView = [MRNavigationBarProgressView progressViewForNavigationController:self.navigationController];
    _progressView.progressTintColor = [UIColor pieYellowColor];
    
    BOOL should = [[NSUserDefaults standardUserDefaults]
                   boolForKey:@"shouldDoUploadJob"];
    if (should) {
        [self PleaseDoTheUploadProcess];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"shouldDoUploadJob"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)refreshHeader {
    if (_collectionView_ask.mj_header.isRefreshing == false) {
        [_collectionView_ask.mj_header beginRefreshing];
    }
}

- (void) PleaseDoTheUploadProcess {
    __weak typeof(self) weakSelf = self;
    PIEUploadManager* manager = [PIEUploadManager new];
    [manager upload:^(CGFloat percentage,BOOL success) {
        [_progressView setProgress:percentage animated:YES];
        if (success) {
            if ([manager.type isEqualToString:@"ask"]) {
                [weakSelf.collectionView_ask.mj_header beginRefreshing];
            }
        }
    }];
}

/**
 *  Remove ovservers from NSNotificationCenter
 */
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_New" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadRightNow" object:nil];
    //compiler would call [super dealloc] automatically in ARC.
}

#pragma mark - methods on Sharing<ATOMShareViewDelegate>


- (void)showShareView {
    [self.shareView show];
    
}


-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}


#pragma mark - Lazy loadings
-(PIERefreshCollectionView *)collectionView_ask {
    if (_collectionView_ask == nil) {
        // instantiate only for once
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
        layout.minimumColumnSpacing = 8;
        layout.minimumInteritemSpacing = 10;
        
        
        _collectionView_ask = [[PIERefreshCollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT) collectionViewLayout:layout];
        
        
        
        
        UINib* nib = [UINib nibWithNibName:CellIdentifier2 bundle:nil];
        [_collectionView_ask registerNib:nib forCellWithReuseIdentifier:CellIdentifier2];

        _collectionView_ask.dataSource           = self;
        _collectionView_ask.delegate             = self;
        _collectionView_ask.emptyDataSetDelegate = self;
        _collectionView_ask.emptyDataSetSource   = self;
        _collectionView_ask.psDelegate           = self;
        
        _collectionView_ask.toRefreshBottom              = YES;
        _collectionView_ask.backgroundColor              = [UIColor clearColor];
        _collectionView_ask.toRefreshTop                 = YES;
        _collectionView_ask.autoresizingMask             = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView_ask.showsVerticalScrollIndicator = NO;
        _collectionView_ask.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView_ask;

}


@end
