//
//  HomeViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//
#import "PIENewViewController.h"
#import "AppDelegate.h"

#import "PIENewReplyTableCell.h"


#import "PIENewScrollView.h"
#import "PIEPageManager.h"
#import "PIEShareView.h"
#import "DDShareManager.h"
#import "DDCollectManager.h"
#import "JGActionSheet.h"
#import "HMSegmentedControl.h"
#import "PIECommentViewController.h"
//#import "UITableView+FDTemplateLayoutCell.h"
#import "PIECarouselViewController2.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIENewAskCollectionCell.h"
#import "PIEFriendViewController.h"
#import "PIEReplyCollectionViewController.h"

#import "MRNavigationBarProgressView.h"
#import "MRProgressView+AFNetworking.h"
#import "PIEUploadManager.h"
#import "PIENewActivityTableViewCell.h"
#import "PIEActionSheet_PS.h"

@interface PIENewViewController() < UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,PWRefreshBaseCollectionViewDelegate,PIEShareViewDelegate,JGActionSheetDelegate,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>


@property (nonatomic, assign) BOOL isfirstLoadingAsk;
@property (nonatomic, assign) BOOL isfirstLoadingReply;
@property (nonatomic, assign) BOOL isfirstLoadingActivity;

@property (nonatomic, strong) NSMutableArray *sourceAsk;
@property (nonatomic, strong) NSMutableArray *sourceReply;
@property (nonatomic, strong) NSMutableArray *sourceActivity;

@property (nonatomic, assign) NSInteger currentIndex_reply;
@property (nonatomic, assign) NSInteger currentIndex_ask;
@property (nonatomic, assign) NSInteger currentIndex_activity;

@property (nonatomic, assign)  long long timeStamp_ask;
@property (nonatomic, assign)  long long timeStamp_reply;
@property (nonatomic, assign)  long long timeStamp_activity;

@property (nonatomic, assign) BOOL canRefreshFooter_ask;
@property (nonatomic, assign) BOOL canRefreshFooter_reply;
@property (nonatomic, assign) BOOL canRefreshFooter_activity;

@property (nonatomic, weak) PIERefreshTableView *tableViewActivity;
@property (nonatomic, weak) PIERefreshCollectionView *collectionView_ask;
@property (nonatomic, weak) PIERefreshTableView *tableViewReply;
@property (nonatomic, strong) PIENewScrollView *scrollView;

@property (nonatomic, strong)  PIEActionSheet_PS * psActionSheet;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;
@property (nonatomic, strong) PIEPageVM *selectedVM;
@property (nonatomic, strong) PIEShareView *shareView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong)  MRNavigationBarProgressView* progressView;


@end

@implementation PIENewViewController

static NSString *CellIdentifier = @"PIENewReplyTableCell";
static NSString *CellIdentifier2 = @"PIENewAskCollectionCell";
static NSString *CellIdentifier3 = @"PIENewActivityTableViewCell";

- (void)updateStatus {
    if (_selectedIndexPath  && _scrollView.type == PIENewScrollTypeReply) {
        [_scrollView.tableReply reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self commonInit];
    [self shouldDoUploadJob];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"进入最新页面"];
//    self.navigationController.hidesBarsOnSwipe = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.hidesBarsOnSwipe = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateStatus];
    [MobClick endLogPageView:@"离开最新页面"];
    //tricks to display progressView  if vc re-appear
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_New" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadRightNow" object:nil];
    //compiler would call [super dealloc] automatically in ARC.
}


#pragma mark - init methods


- (void)commonInit {
    self.view = self.scrollView;
    [self setupNavBar];
    [self setupTable_activity];
    [self setupTable_reply];
    [self setupCollectionView_ask];
    [self setupGestures];
    [self setupData];
    [self firstGetSourceIfEmpty_ask];
    [self setupNotifications];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_New" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDoUploadJob) name:@"UploadRightNow" object:nil];
}
- (void) setupData {
    //set this before firstGetRemoteSource
    _canRefreshFooter_activity = YES;
    _canRefreshFooter_reply = YES;
    _canRefreshFooter_ask = YES;
    
    _isfirstLoadingActivity = YES;
    _isfirstLoadingAsk = YES;
    _isfirstLoadingReply = YES;
    
    _sourceActivity = [NSMutableArray new];
    _sourceAsk = [NSMutableArray new];
    _sourceReply = [NSMutableArray new];
}

- (void) PleaseDoTheUploadProcess {
    WS(ws);
    PIEUploadManager* manager = [PIEUploadManager new];
    [manager upload:^(CGFloat percentage,BOOL success) {
        [_progressView setProgress:percentage animated:YES];
        if (success) {
            if ([manager.type isEqualToString:@"ask"]) {
                ws.segmentedControl.selectedSegmentIndex=1;
                [ws.scrollView toggleWithType:PIENewScrollTypeAsk];
                [ws.scrollView.collectionViewAsk.mj_header beginRefreshing];
            } else if ([manager.type isEqualToString:@"reply"]) {
                ws.segmentedControl.selectedSegmentIndex=2;
                [ws.scrollView toggleWithType:PIENewScrollTypeReply];
                [ws.scrollView.tableReply.mj_header beginRefreshing];
            }
        }
    }];
}
- (void)setupTable_activity {
    _tableViewActivity = _scrollView.tableActivity;
    _tableViewActivity.delegate = self;
    _tableViewActivity.dataSource = self;
    _tableViewActivity.psDelegate = self;
    _tableViewActivity.emptyDataSetSource = self;
    _tableViewActivity.emptyDataSetDelegate = self;
    _tableViewActivity.estimatedRowHeight = SCREEN_WIDTH+145;
    _tableViewActivity.rowHeight = UITableViewAutomaticDimension;
    UINib* nib = [UINib nibWithNibName:CellIdentifier3 bundle:nil];
    [_tableViewActivity registerNib:nib forCellReuseIdentifier:CellIdentifier3];
    _tableViewActivity.estimatedRowHeight = SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT;
    _currentIndex_activity = 1;
}
- (void)setupTable_reply {
    _tableViewReply = _scrollView.tableReply;
    _tableViewReply.delegate = self;
    _tableViewReply.dataSource = self;
    _tableViewReply.psDelegate = self;
    _tableViewReply.emptyDataSetSource = self;
    _tableViewReply.emptyDataSetDelegate = self;
    _tableViewReply.estimatedRowHeight = SCREEN_WIDTH+145;
    _tableViewReply.rowHeight = UITableViewAutomaticDimension;
    UINib* nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [_tableViewReply registerNib:nib forCellReuseIdentifier:CellIdentifier];
    _tableViewReply.estimatedRowHeight = SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT;
    _tableViewReply.scrollsToTop = YES;
    _currentIndex_reply = 1;
}
- (void)setupCollectionView_ask {
    _collectionView_ask = _scrollView.collectionViewAsk;
    _collectionView_ask.dataSource = self;
    _collectionView_ask.delegate = self;
    _collectionView_ask.emptyDataSetDelegate = self;
    _collectionView_ask.emptyDataSetSource = self;
    _collectionView_ask.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:CellIdentifier2 bundle:nil];
    [_collectionView_ask registerNib:nib forCellWithReuseIdentifier:CellIdentifier2];
    _currentIndex_ask = 1;
}
- (void)setupGestures {
    UITapGestureRecognizer* tapGestureAsk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnAsk:)];
    UILongPressGestureRecognizer* longPressGestureAsk = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnAsk:)];
    
    UITapGestureRecognizer* tapGestureReply = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnReply:)];
    UILongPressGestureRecognizer* longPressGestureReply = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnReply:)];
    
    UITapGestureRecognizer* tapGestureActivity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnActivity:)];
    UILongPressGestureRecognizer* longPressGestureActivity = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnActivity:)];
    
    [_tableViewReply addGestureRecognizer:longPressGestureReply];
    [_tableViewReply addGestureRecognizer:tapGestureReply];
    [_collectionView_ask addGestureRecognizer:tapGestureAsk];
    [_collectionView_ask addGestureRecognizer:longPressGestureAsk];
    [_tableViewActivity addGestureRecognizer:tapGestureActivity];
    [_tableViewActivity addGestureRecognizer:longPressGestureActivity];
}



- (void)setupNavBar {
    self.navigationItem.titleView = self.segmentedControl;
}

#pragma mark - methods


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
    if (_scrollView.type == PIENewScrollTypeReply && !_tableViewReply.mj_header.isRefreshing) {
        [_tableViewReply.mj_header beginRefreshing];
    } else if (_scrollView.type == PIENewScrollTypeAsk && !_collectionView_ask.mj_header.isRefreshing) {
        [_collectionView_ask.mj_header beginRefreshing];
    } else if (_scrollView.type == PIENewScrollTypeActivity && !_tableViewActivity.mj_header.isRefreshing) {
        [_tableViewActivity.mj_header beginRefreshing];
    }
}

#pragma mark - event response

- (void)help:(BOOL)shouldDownload {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_selectedVM.ID) forKey:@"target"];
    
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        NSLog(@"signProceeding");
        if (imageUrl != nil) {
            if (shouldDownload) {
                [DDService downloadImage:imageUrl withBlock:^(UIImage *image) {
                    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }];
            }
            else {
                NSLog(@"signProceeding2");
                [Hud text:@"添加成功\n在“进行中”等你下载咯!"];
            }
        }
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
    } else {
        [Hud text:@"下载成功\n我猜你会用美图秀秀来P?"];
    }
}

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



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int currentPage = (_scrollView.contentOffset.x + CGWidth(_scrollView.frame) * 0.1) / CGWidth(_scrollView.frame);
        if (currentPage == 0) {
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
            _scrollView.type = PIENewScrollTypeActivity;
            [self firstGetSourceIfEmpty_activity];
        } else if (currentPage == 1) {
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            _scrollView.type = PIENewScrollTypeAsk;
            [self firstGetSourceIfEmpty_ask];
        }
        else if (currentPage == 2) {
            [_segmentedControl setSelectedSegmentIndex:2 animated:YES];
            _scrollView.type = PIENewScrollTypeReply;
            [self firstGetSourceIfEmpty_Reply];
        }
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableViewReply == tableView) {
        return _sourceReply.count;
    }else if (_tableViewActivity == tableView) {
        return _sourceActivity.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableViewReply == tableView) {
        PIENewReplyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell injectSauce:_sourceReply[indexPath.row]];
        return cell;
    } else if (_tableViewActivity == tableView) {
        PIENewActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        [cell injectSauce:_sourceActivity[indexPath.row]];
        return cell;
    }
    else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_tableViewReply == tableView) {
//        return [tableView fd_heightForCellWithIdentifier:CellIdentifier  cacheByIndexPath:indexPath configuration:^(PIENewReplyTableCell *cell) {
//            [cell injectSauce:_sourceReply[indexPath.row]];
//        }];
//    } else if (_tableViewActivity == tableView) {
//        return [tableView fd_heightForCellWithIdentifier:CellIdentifier3  cacheByIndexPath:indexPath configuration:^(PIENewActivityTableViewCell *cell) {
//            [cell injectSauce:_sourceActivity[indexPath.row]];
//        }];
//    }
//    else {
//        return 0;
//    }
//}

#pragma mark - ATOMViewControllerDelegate


#pragma mark - GetDataSource from DB
//- (void)firstGetDataSourceFromDataBase {
//
//    _sourceAsk = [self fetchDBDataSourceWithHomeType:PIENewScrollTypeAsk];
//    [_collectionView_ask reloadData];
//
////    _sourceReply = [self fetchDBDataSourceWithHomeType:PIENewScrollTypeReply];
//}
#pragma mark - GetDataSource from Server
//-(NSMutableArray*)fetchDBDataSourceWithHomeType:(PIEHomeType) homeType {
//    DDHomePageManager *showHomepage = [DDHomePageManager new];
//    NSArray * homepageArray = [[showHomepage getHomeImagesWithHomeType:homeType] mutableCopy];
//    NSMutableArray* tableViewDataSource = [NSMutableArray array];
//    for (PIEPageEntity *homeImage in homepageArray) {
//        PIEPageVM *model = [PIEPageVM new];
//        [model setViewModelData:homeImage];
//        [tableViewDataSource addObject:model];
//    }
//    return tableViewDataSource;
//}
- (void)firstGetSourceIfEmpty_activity {
    if (_sourceActivity.count <= 0 || _isfirstLoadingActivity) {
        [self.tableViewActivity.mj_header beginRefreshing];
    }
}
- (void)firstGetSourceIfEmpty_ask {
    if (_sourceAsk.count <= 0 || _isfirstLoadingAsk) {
        [self.collectionView_ask.mj_header beginRefreshing];
    }
}
- (void)firstGetSourceIfEmpty_Reply {
    if (_sourceReply.count <= 0 || _isfirstLoadingReply) {
        [self.tableViewReply.mj_header beginRefreshing];
    }
}

//获取服务器的最新数据
- (void)getRemoteSource_activity:(void (^)(BOOL finished))block{
    WS(ws);
    [ws.scrollView.tableActivity.mj_footer endRefreshing];
    _currentIndex_activity = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    _timeStamp_activity = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_timeStamp_activity) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(1) forKey:@"page"];
//    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    
    
    [ws.scrollView.tableActivity.mj_header endRefreshing];
    ws.isfirstLoadingActivity = NO;
    [ws.tableViewActivity reloadData];
    _canRefreshFooter_activity = NO;
    
//    PIEPageManager *pageManager = [PIEPageManager new];
//    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
//        ws.isfirstLoadingActivity = NO;
//        if (homepageArray.count) {
//            ws.sourceActivity = homepageArray;
//            _canRefreshFooter_activity = YES;
//        }
//        else {
//            _canRefreshFooter_activity = NO;
//        }
//        [ws.tableViewActivity reloadData];
//        [ws.tableViewActivity.mj_header endRefreshing];
//        if (block) {
//            block(YES);
//        }
//    }];
}
//拉至底层刷新
- (void)getMoreRemoteSource_activity {
    WS(ws);
    [ws.tableViewActivity.mj_header endRefreshing];
    _currentIndex_ask++;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_timeStamp_ask) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(_currentIndex_ask) forKey:@"page"];
//    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        if (homepageArray.count) {
            [ws.sourceActivity addObjectsFromArray:homepageArray];
            _canRefreshFooter_activity = YES;
        }
        else {
            _canRefreshFooter_activity = NO;
        }
        [ws.tableViewActivity reloadData];
        [ws.tableViewActivity.mj_footer endRefreshing];
    }];
}

//获取服务器的最新数据
- (void)getRemoteAskSource:(void (^)(BOOL finished))block{
    WS(ws);
    [ws.scrollView.collectionViewAsk.mj_footer endRefreshing];
    _currentIndex_ask = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    _timeStamp_ask = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_timeStamp_ask) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        ws.isfirstLoadingAsk = NO;
        if (homepageArray.count) {
            ws.sourceAsk = homepageArray;
            _canRefreshFooter_ask = YES;
        }
        else {
            _canRefreshFooter_ask = NO;
        }
        [ws.collectionView_ask reloadData];
        [ws.scrollView.collectionViewAsk.mj_header endRefreshing];
        if (block) {
            block(YES);
        }
    }];
}

//拉至底层刷新
- (void)getMoreRemoteAskSource {
    WS(ws);
    [ws.scrollView.collectionViewAsk.mj_header endRefreshing];
    _currentIndex_ask++;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_timeStamp_ask) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(_currentIndex_ask) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        if (homepageArray.count) {
            [ws.sourceAsk addObjectsFromArray:homepageArray];
            _canRefreshFooter_ask = YES;
        }
        else {
            _canRefreshFooter_ask = NO;
        }
        [ws.collectionView_ask reloadData];
        [ws.scrollView.collectionViewAsk.mj_footer endRefreshing];
    }];
}

- (void)getRemoteReplySource {
    WS(ws);
    _currentIndex_reply = 1;
    [_tableViewReply.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary new];
    _timeStamp_reply = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_timeStamp_reply) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
//    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];

    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullReplySource:param block:^(NSMutableArray *array) {
        ws.isfirstLoadingReply = NO;
        if (array.count) {
                ws.sourceReply = array;
                _canRefreshFooter_reply = YES;
        }
        else {
            _canRefreshFooter_reply = NO;
        }
        [ws.tableViewReply reloadData];
        [ws.tableViewReply.mj_header endRefreshing];
    }];
}

- (void)getMoreRemoteReplySource {
    WS(ws);
    _currentIndex_reply ++;
    [_tableViewReply.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_timeStamp_reply) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
//    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentIndex_reply) forKey:@"page"];
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullReplySource:param block:^(NSMutableArray *array) {
        if (array.count) {
            [ws.sourceReply addObjectsFromArray:array] ;
            _canRefreshFooter_reply = YES;
        }
        else {
            _canRefreshFooter_reply = NO;
        }
        [ws.tableViewReply reloadData];
        [ws.tableViewReply.mj_footer endRefreshing];
    }];
}

- (void)updateShareStatus {
    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
        [self updateStatus];
}

#pragma mark - ATOMShareViewDelegate
//sina
-(void)tapShare1 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeSinaWeibo block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//qqzone
-(void)tapShare2 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQZone block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//wechat moments
-(void)tapShare3 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatMoments block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//wechat friends
-(void)tapShare4 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatFriends block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
-(void)tapShare5 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQFriends block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
    
}

-(void)tapShare6 {
    [DDShareManager copy:_selectedVM];
}
-(void)tapShare7 {
    self.shareView.vm = _selectedVM;
}
-(void)tapShare8 {
//    if (_scrollView.type == PIENewScrollTypeAsk) {
//        if (_selectedVM.type == PIEPageTypeAsk) {
            [self collect];
//        }
//    } else {
//        if (_selectedVM.type == PIEPageTypeAsk) {
//            [self collect];
//        } else {
//            PIENewReplyTableCell* cell = [_scrollView.tableReply cellForRowAtIndexPath:_selectedIndexPath];
//            [self collect:cell.collectView shouldShowHud:YES];
//        }
//    }

}

-(void)tapShareCancel {
    [self.shareView dismiss];
}


-(void)collect:(PIEPageButton*) collectView shouldShowHud:(BOOL)shouldShowHud {
    NSMutableDictionary *param = [NSMutableDictionary new];
    collectView.selected = !collectView.selected;
    if (collectView.selected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:_selectedVM.type withID:_selectedVM.ID withBlock:^(NSError *error) {
        if (!error) {
            if (shouldShowHud) {
                if (  collectView.selected) {
                    [Hud textWithLightBackground:@"收藏成功"];
                } else {
                    [Hud textWithLightBackground:@"取消收藏成功"];
                }
            }
            _selectedVM.collected = collectView.selected;
            _selectedVM.collectCount = collectView.numberString;
        }   else {
            collectView.selected = !collectView.selected;
        }
    }];
}

-(void)collect {
    NSMutableDictionary *param = [NSMutableDictionary new];
    _selectedVM.collected = !_selectedVM.collected;
    if (_selectedVM.collected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:_selectedVM.type withID:_selectedVM.ID withBlock:^(NSError *error) {
        if (!error) {
            if (  _selectedVM.collected) {
                [Hud textWithLightBackground:@"收藏成功"];
            } else {
                [Hud textWithLightBackground:@"取消收藏成功"];
            }
        }   else {
            _selectedVM.collected = !_selectedVM.collected;
        }
    }];
}

-(void)likeReply {
    _selectedReplyCell.likeView.selected = !_selectedReplyCell.likeView.selected;
    [DDService toggleLike:_selectedReplyCell.likeView.selected ID:_selectedVM.ID type:_selectedVM.type  withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.liked = _selectedReplyCell.likeView.selected;
            if (_selectedReplyCell.likeView.selected) {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue + 1];
            } else {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue - 1];
            }
        } else {
            _selectedReplyCell.likeView.selected = !_selectedReplyCell.likeView.selected;
        }
    }];
}

-(void)followReplier {
    _selectedReplyCell.followView.highlighted = !_selectedReplyCell.followView.highlighted;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_selectedVM.userID) forKey:@"uid"];
    if (_selectedReplyCell.followView.highlighted) {
        [param setObject:@1 forKey:@"status"];
    }
    else {
        [param setObject:@0 forKey:@"status"];
    }
    [DDService follow:param withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.followed = _selectedReplyCell.followView.highlighted;
        } else {
            _selectedReplyCell.followView.highlighted = !_selectedReplyCell.followView.highlighted;
        }
    }];
}



#pragma mark - Refresh

- (void)loadNewData_reply {
    [self getRemoteReplySource];
}

- (void)loadMoreData_reply {
    if (_canRefreshFooter_reply && !_tableViewReply.mj_header.isRefreshing) {
        [self getMoreRemoteReplySource];
    } else {
        [_tableViewReply.mj_footer endRefreshing];
    }
}

- (void)loadNewData_activity {
    [self getRemoteSource_activity:nil];
}

- (void)loadMoreData_activity {
    if (_canRefreshFooter_activity && !_tableViewActivity.mj_header.isRefreshing) {
        [self getMoreRemoteSource_activity];
    } else {
        [_tableViewActivity.mj_footer endRefreshing];
    }
}
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

#pragma mark - PWRefreshBaseTableViewDelegate

-(void)didPullRefreshDown:(UITableView *)tableView{
    if (tableView == _tableViewReply) {
        [self loadNewData_reply];
    } else if (tableView == _tableViewActivity) {
        [self loadNewData_activity];
    }
}

-(void)didPullRefreshUp:(UITableView *)tableView {
    if (tableView == _tableViewReply) {
        [self loadMoreData_reply];
    } if (tableView == _tableViewActivity) {
        [self loadMoreData_activity];
    }
}

-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self loadNewData_ask];
}

-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    [self loadMoreData_ask];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceAsk.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIENewAskCollectionCell*cell =
    (PIENewAskCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2
                                                                      forIndexPath:indexPath];
    [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm =   [_sourceAsk objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH - 20) / 2.0;
    height = vm.imageHeight/vm.imageWidth * width + 129 + (29+20);
    height = MAX(200,height);
    height = MIN(SCREEN_HEIGHT/1.5, height);
    return CGSizeMake(width, height);
}

#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text ;
    if (scrollView == _scrollView.collectionViewAsk) {
        text = @"好伤心，再下拉刷新试试";
    } else if (scrollView == _scrollView.tableReply) {
        text = @"好伤心，再下拉刷新试试";
    } else if (scrollView == _scrollView.tableActivity) {
        text = @"我们的活动频道即将推出";
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (scrollView == _scrollView.collectionViewAsk) {
        return !_isfirstLoadingAsk;
    } else if (scrollView == _scrollView.tableReply) {
        return !_isfirstLoadingReply;
    } else if (scrollView == _scrollView.tableActivity) {
        return !_isfirstLoadingActivity;
    }
    return NO;
}
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 150;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - Getters and Setters

-(PIENewScrollView*)scrollView {
    if (!_scrollView) {
        _scrollView = [PIENewScrollView new];
        _scrollView.delegate =self;
    }
    return _scrollView;
}

- (PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
    }
    return _psActionSheet;
}


- (HMSegmentedControl*)segmentedControl {
    WS(ws);
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"活动",@"求P",@"作品"]];
        _segmentedControl.frame = CGRectMake(0, 120, SCREEN_WIDTH-40, 45);
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.6], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.selectedSegmentIndex = 1;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (index == 0) {
                [ws.scrollView toggleWithType:PIENewScrollTypeActivity];
                [ws firstGetSourceIfEmpty_activity];
            } else             if (index == 1) {
                [ws.scrollView toggleWithType:PIENewScrollTypeAsk];
                [ws firstGetSourceIfEmpty_ask];
            } else             if (index == 2) {
                [ws.scrollView toggleWithType:PIENewScrollTypeReply];
                [ws firstGetSourceIfEmpty_Reply];
            }
        }];
    }
    return _segmentedControl;
}

#pragma mark - Gesture Event

- (void)tapOnReply:(UITapGestureRecognizer *)gesture {
    if (_scrollView.type == PIENewScrollTypeReply) {
        CGPoint location = [gesture locationInView:_tableViewReply];
        _selectedIndexPath = [_tableViewReply indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            _selectedReplyCell = [_tableViewReply cellForRowAtIndexPath:_selectedIndexPath];
            _selectedVM = _sourceReply[_selectedIndexPath.row];
            CGPoint p = [gesture locationInView:_selectedReplyCell];
            
            //点击小图
            if (CGRectContainsPoint(_selectedReplyCell.thumbView.frame, p)) {
                CGPoint pp = [gesture locationInView:_selectedReplyCell.thumbView];
                if (CGRectContainsPoint(_selectedReplyCell.thumbView.leftView.frame,pp)) {
                    [_selectedReplyCell animateThumbScale:PIEAnimateViewTypeLeft];
                }
                else if (CGRectContainsPoint(_selectedReplyCell.thumbView.rightView.frame,pp)) {
                    [_selectedReplyCell animateThumbScale:PIEAnimateViewTypeRight];
                }
            }
            //点击大图
            else  if (CGRectContainsPoint(_selectedReplyCell.theImageView.frame, p)) {
                //进入热门详情
                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                _selectedVM.image = _selectedReplyCell.theImageView.image;
                vc.pageVM = _selectedVM;
                [self presentViewController:vc animated:YES completion:nil];
//                [self.navigationController pushViewController:vc animated:YES];
            }
            //点击头像
            else if (CGRectContainsPoint(_selectedReplyCell.avatarView.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self.navigationController pushViewController:friendVC animated:YES];
            }
            //点击用户名
            else if (CGRectContainsPoint(_selectedReplyCell.nameLabel.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self.navigationController pushViewController:friendVC animated:YES];
            }
//            else if (CGRectContainsPoint(_selectedReplyCell.collectView.frame, p)) {
//                //should write this logic in viewModel
////                [self collect:_selectedReplyCell.collectView shouldShowHud:NO];
//                [self collect];
//            }
            else if (CGRectContainsPoint(_selectedReplyCell.likeView.frame, p)) {
                [self likeReply];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.followView.frame, p)) {
                [self followReplier];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.shareView.frame, p)) {
                [self showShareView];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.commentView.frame, p)) {
                PIECommentViewController* vc = [PIECommentViewController new];
                vc.vm = _selectedVM;
                vc.shouldShowHeaderView = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.allWorkView.frame, p)) {
                PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
                vc.pageVM = _selectedVM;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
- (void)longPressOnReply:(UILongPressGestureRecognizer *)gesture {
    if (_scrollView.type == PIENewScrollTypeReply) {
        CGPoint location = [gesture locationInView:_tableViewReply];
        _selectedIndexPath = [_tableViewReply indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            _selectedReplyCell = [_tableViewReply cellForRowAtIndexPath:_selectedIndexPath];
            _selectedVM = _sourceReply[_selectedIndexPath.row];
            CGPoint p = [gesture locationInView:_selectedReplyCell];
            
            //点击大图
            if (CGRectContainsPoint(_selectedReplyCell.theImageView.frame, p)) {
                [self showShareView];
            }
        }
    }
    
}
- (void)longPressOnAsk:(UILongPressGestureRecognizer *)gesture {
    if (_scrollView.type == PIENewScrollTypeAsk) {
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
}

- (void)tapOnAsk:(UITapGestureRecognizer *)gesture {
    if (_scrollView.type == PIENewScrollTypeAsk) {
        CGPoint location = [gesture locationInView:_collectionView_ask];
        NSIndexPath *indexPath = [_collectionView_ask indexPathForItemAtPoint:location];
        if (indexPath) {
       PIENewAskCollectionCell*  cell= (PIENewAskCollectionCell *)[_collectionView_ask cellForItemAtIndexPath:indexPath];
            _selectedVM = _sourceAsk[indexPath.row];
            CGPoint p = [gesture locationInView:cell];
            
            //点击大图
            if (CGRectContainsPoint(cell.leftImageView.frame, p) || CGRectContainsPoint(cell.rightImageView.frame, p)) {
                if (![_selectedVM.replyCount isEqualToString:@"0"]) {
                    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                    vc.pageVM = _selectedVM;
                    [self presentViewController:vc animated:YES completion:nil];
                } else {
                    PIECommentViewController* vc = [PIECommentViewController new];
                    vc.vm = _selectedVM;
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
                [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
            }
        }
    }
}

- (void)longPressOnActivity:(UILongPressGestureRecognizer *)gesture {
}
- (void)tapOnActivity:(UITapGestureRecognizer *)gesture {
}
@end
