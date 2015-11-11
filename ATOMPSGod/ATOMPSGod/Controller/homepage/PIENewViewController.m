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


#import "kfcHomeScrollView.h"
#import "PIEPageManager.h"
#import "PIEShareView.h"
#import "DDShareManager.h"
#import "DDCollectManager.h"
#import "JGActionSheet.h"
#import "ATOMReportModel.h"
#import "HMSegmentedControl.h"
#import "DDCommentVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PIECarouselViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIENewAskCollectionCell.h"
#import "PIEFriendViewController.h"
#import "PIEReplyCollectionViewController.h"

#import "MRNavigationBarProgressView.h"
#import "MRProgressView+AFNetworking.h"
#import "PIEUploadManager.h"

@interface PIENewViewController() < UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,PWRefreshBaseCollectionViewDelegate,PIEShareViewDelegate,JGActionSheetDelegate,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureReply;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureAsk;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureAsk;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureReply;

@property (nonatomic, assign) BOOL isfirstLoadingAsk;
@property (nonatomic, assign) BOOL isfirstLoadingReply;

@property (nonatomic, strong) NSMutableArray *sourceAsk;
@property (nonatomic, strong) NSMutableArray *sourceReply;

@property (nonatomic, assign) NSInteger currentHotIndex;
@property (nonatomic, assign) NSInteger currentAskIndex;
@property (nonatomic, strong) kfcHomeScrollView *scrollView;
@property (nonatomic, weak) PIERefreshCollectionView *askCollectionView;
@property (nonatomic, weak) PIERefreshTableView *hotTableView;
@property (nonatomic, assign) BOOL canRefreshReplyFooter;
@property (nonatomic, assign) BOOL canRefreshAskFooter;

@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;
@property (nonatomic, strong) DDPageVM *selectedVM;
@property (nonatomic, strong) PIEShareView *shareView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong)  MRNavigationBarProgressView* progressView;
@property (nonatomic, assign)  long long timeStamp_ask;
@property (nonatomic, assign)  long long timeStamp_reply;
@end

@implementation PIENewViewController

static NSString *CellIdentifier = @"PIENewReplyTableCell";
static NSString *CellIdentifier2 = @"PIENewAskCollectionCell";

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self shouldDoUploadJob];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"进入最新页面"];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self shouldNavToAskSegment];
//    [self shouldNavToHotSegment];
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
    [self createCustomNavigationBar];
    [self confighotTable];
    [self configAskView];
    [self setupGestures];
    //set this before firstGetRemoteSource
    _canRefreshReplyFooter = YES;
    _canRefreshAskFooter = YES;
    
    _isfirstLoadingAsk = YES;
    _isfirstLoadingReply = YES;
    
    _sourceAsk = [NSMutableArray new];
    _sourceReply = [NSMutableArray new];
    
    [self firstGetSourceIfEmpty_ask];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_New" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDoUploadJob) name:@"UploadRightNow" object:nil];
}

- (void) PleaseDoTheUploadProcess {
    WS(ws);
    PIEUploadManager* manager = [PIEUploadManager new];
    [manager upload:^(CGFloat percentage,BOOL success) {
        [_progressView setProgress:percentage animated:YES];
        if (success) {
            if ([manager.type isEqualToString:@"ask"]) {
                [ws.scrollView.collectionView.header beginRefreshing];
            } else if ([manager.type isEqualToString:@"reply"]) {
                [ws.scrollView.replyTable.header beginRefreshing];
            }
        }
    }];
}

- (void)confighotTable {
    _hotTableView = _scrollView.replyTable;
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    _hotTableView.psDelegate = self;
    _hotTableView.emptyDataSetSource = self;
    _hotTableView.emptyDataSetDelegate = self;
    UINib* nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [_hotTableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    _hotTableView.estimatedRowHeight = SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT;
    _hotTableView.scrollsToTop = YES;
    _currentHotIndex = 1;
}
- (void)setupGestures {
    _tapGestureReply = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureReply:)];
    [_hotTableView addGestureRecognizer:_tapGestureReply];
    _tapGestureAsk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAsk:)];
    [_askCollectionView addGestureRecognizer:_tapGestureAsk];
    
    _longPressGestureAsk = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnAsk:)];
    _longPressGestureReply = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnReply:)];

    [_askCollectionView addGestureRecognizer:_longPressGestureAsk];
    
    [_hotTableView addGestureRecognizer:_longPressGestureReply];

}

- (void)configAskView {
    _askCollectionView = _scrollView.collectionView;
    _askCollectionView.dataSource = self;
    _askCollectionView.delegate = self;
    _askCollectionView.emptyDataSetDelegate = self;
    _askCollectionView.emptyDataSetSource = self;
    _askCollectionView.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:CellIdentifier2 bundle:nil];
    [_askCollectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier2];
    _currentAskIndex = 1;
}

- (void)createCustomNavigationBar {
    self.navigationItem.titleView = self.segmentedControl;
}

#pragma mark - methods

//- (void)shouldNavToHotSegment {
//    BOOL shouldNav = [[NSUserDefaults standardUserDefaults]
//                      boolForKey:@"shouldNavToHotSegment"];
//    if (shouldNav) {
//        [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
//        [_scrollView toggleWithType:PIENewScrollTypeReply];
//        [_hotTableView.header beginRefreshing];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"shouldNavToHotSegment"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}


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
//- (void)shouldNavToAskSegment {
//    BOOL shouldNav = [[NSUserDefaults standardUserDefaults]
//                      boolForKey:@"shouldNavToAskSegment"];
//    if (shouldNav) {
//        [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
//        [_scrollView toggleWithType:PIENewScrollTypeAsk];
//        [_askCollectionView.header beginRefreshing];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"shouldNavToAskSegment"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}


- (void)refreshHeader {
    if (_scrollView.type == PIENewScrollTypeReply && ![_hotTableView.header isRefreshing]) {
        [_hotTableView.header beginRefreshing];
    } else if (_scrollView.type == PIENewScrollTypeAsk && ![_askCollectionView.header isRefreshing]) {
        [_askCollectionView.header beginRefreshing];
    }
}

#pragma mark - event response



- (void)help:(BOOL)shouldDownload {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_selectedVM.ID) forKey:@"target"];
    
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        if (imageUrl != nil) {
            if (shouldDownload) {
                [DDService downloadImage:imageUrl withBlock:^(UIImage *image) {
                    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }];
            }
            else {
                [Hud customText:@"添加成功\n在“进行中”等你下载咯!" inView:self.view];
            }
        }
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
    } else {
        [Hud customText:@"下载成功\n我猜你会用美图秀秀来P?" inView:self.view];
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
            _hotTableView.scrollsToTop = NO;
            _askCollectionView.scrollsToTop = YES;
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
            _scrollView.type = PIENewScrollTypeAsk;
            [self firstGetSourceIfEmpty_ask];
        } else if (currentPage == 1) {
            _hotTableView.scrollsToTop = YES;
            _askCollectionView.scrollsToTop = NO;
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            _scrollView.type = PIENewScrollTypeReply;
            [self firstGetSourceIfEmpty_Reply];
        }
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_hotTableView == tableView) {
        return _sourceReply.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hotTableView == tableView) {
        PIENewReplyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell injectSauce:_sourceReply[indexPath.row]];
        return cell;
    }
    else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hotTableView == tableView) {
        return [tableView fd_heightForCellWithIdentifier:CellIdentifier  cacheByIndexPath:indexPath configuration:^(PIENewReplyTableCell *cell) {
            [cell injectSauce:_sourceReply[indexPath.row]];
        }];
    } else {
        return 0;
    }
}

#pragma mark - ATOMViewControllerDelegate


#pragma mark - GetDataSource from DB
//- (void)firstGetDataSourceFromDataBase {
//
//    _sourceAsk = [self fetchDBDataSourceWithHomeType:PIENewScrollTypeAsk];
//    [_askCollectionView reloadData];
//
////    _sourceReply = [self fetchDBDataSourceWithHomeType:PIENewScrollTypeReply];
//}
#pragma mark - GetDataSource from Server
//-(NSMutableArray*)fetchDBDataSourceWithHomeType:(PIEHomeType) homeType {
//    DDHomePageManager *showHomepage = [DDHomePageManager new];
//    NSArray * homepageArray = [[showHomepage getHomeImagesWithHomeType:homeType] mutableCopy];
//    NSMutableArray* tableViewDataSource = [NSMutableArray array];
//    for (PIEPageEntity *homeImage in homepageArray) {
//        DDPageVM *model = [DDPageVM new];
//        [model setViewModelData:homeImage];
//        [tableViewDataSource addObject:model];
//    }
//    return tableViewDataSource;
//}

- (void)firstGetSourceIfEmpty_ask {
    if (_sourceAsk.count <= 0 || _isfirstLoadingAsk) {
        [self.askCollectionView.header beginRefreshing];
    }
}
- (void)firstGetSourceIfEmpty_Reply {
    if (_sourceReply.count <= 0 || _isfirstLoadingReply) {
        [self.hotTableView.header beginRefreshing];
    }
}
//获取服务器的最新数据
- (void)getRemoteAskSource:(void (^)(BOOL finished))block{
    WS(ws);
    [ws.scrollView.collectionView.footer endRefreshing];
    _currentAskIndex = 1;
    [_askCollectionView.footer endRefreshing];
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
            _canRefreshAskFooter = YES;
        }
        else {
            _canRefreshAskFooter = NO;
        }
        [ws.askCollectionView reloadData];
        [ws.scrollView.collectionView.header endRefreshing];
        if (block) {
            block(YES);
        }
    }];
}

//拉至底层刷新
- (void)getMoreRemoteAskSource {
    WS(ws);
    [ws.scrollView.collectionView.header endRefreshing];
    _currentAskIndex++;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_timeStamp_ask) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(_currentAskIndex) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        if (homepageArray.count) {
            [ws.sourceAsk addObjectsFromArray:homepageArray];
            _canRefreshAskFooter = YES;
        }
        else {
            _canRefreshAskFooter = NO;
        }
        [ws.askCollectionView reloadData];
        [ws.scrollView.collectionView.footer endRefreshing];
    }];
}

- (void)getRemoteReplySource {
    WS(ws);
    _currentHotIndex = 1;
    [_hotTableView.footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary new];
    _timeStamp_reply = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_timeStamp_reply) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];

    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullReplySource:param block:^(NSMutableArray *array) {
        ws.isfirstLoadingReply = NO;
        if (array.count) {
                ws.sourceReply = array;
                _canRefreshReplyFooter = YES;
        }
        else {
            _canRefreshReplyFooter = NO;
        }
        [ws.hotTableView reloadData];
        [ws.hotTableView.header endRefreshing];
    }];
}

- (void)getMoreRemoteReplySource {
    WS(ws);
    _currentHotIndex ++;
    [_hotTableView.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_timeStamp_reply) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentHotIndex) forKey:@"page"];
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullReplySource:param block:^(NSMutableArray *array) {
        if (array.count) {
            [ws.sourceReply addObjectsFromArray:array] ;
            _canRefreshReplyFooter = YES;
        }
        else {
            _canRefreshReplyFooter = NO;
        }
        [ws.hotTableView reloadData];
        [ws.hotTableView.footer endRefreshing];
    }];
}

#pragma mark - ATOMShareViewDelegate
//sina
-(void)tapShare1 {

    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeSinaWeibo ];
}
//qqzone
-(void)tapShare2 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQZone ];
}
//wechat moments
-(void)tapShare3 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatMoments ];
}
//wechat friends
-(void)tapShare4 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatFriends ];
}
-(void)tapShare5 {
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQFriends ];
}
-(void)tapShare6 {
    [DDShareManager copy:_selectedVM];
}
-(void)tapShare7 {
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
}
-(void)tapShare8 {
    if (_scrollView.type == PIENewScrollTypeAsk) {
        if (_selectedVM.type == PIEPageTypeAsk) {
            [self collectAsk];
        }
    } else {
        if (_selectedVM.type == PIEPageTypeAsk) {
            [self collectAsk];
        } else {
            PIENewReplyTableCell* cell = [_scrollView.replyTable cellForRowAtIndexPath:_selectedIndexPath];
            [self collect:cell.collectView shouldShowHud:YES];
        }
    }

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

-(void)collectAsk {
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

- (void)loadNewHotData {
    [self getRemoteReplySource];
}

- (void)loadMoreHotData {
    if (_canRefreshReplyFooter && !_hotTableView.header.isRefreshing) {
        [self getMoreRemoteReplySource];
    } else {
        [_hotTableView.footer endRefreshing];
    }
}


- (void)loadNewRecentData {
    [self getRemoteAskSource:nil];
}

- (void)loadMoreRecentData {
    if (_canRefreshAskFooter && !_askCollectionView.header.isRefreshing) {
        [self getMoreRemoteAskSource];
    } else {
        [_askCollectionView.footer endRefreshing];
    }
}

#pragma mark - PWRefreshBaseTableViewDelegate

-(void)didPullRefreshDown:(UITableView *)tableView{
    if (tableView == _hotTableView) {
        [self loadNewHotData];
    }
}

-(void)didPullRefreshUp:(UITableView *)tableView {
    if (tableView == _hotTableView) {
        [self loadMoreHotData];
    }
}

-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self loadNewRecentData];
}

-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    [self loadMoreRecentData];
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
//    [cell showPlaceHolderWithAllSubviews];
    [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDPageVM* vm =   [_sourceAsk objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH - 20) / 2.0;
    
//    text = @"abcd";
//    CGSize size1 = [text boundingRectWithSize:CGSizeMake(width,100) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;

//    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12], NSFontAttributeName, nil] context:NULL].size;
//    NSLog(@"size.height %zd",size.height);
    
//    NSString* text = vm.content;

//        NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12]};
//        
//        CGFloat messageLabelHeight = CGRectGetHeight([vm.content boundingRectWithSize:CGSizeMake(width, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil]);
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
    if (scrollView == _scrollView.collectionView) {
        text = @"你是不可能看到这段文字的\n如果你看到了\n这个时候......\n我们的服务器工程师正在卷文件走人";
    } else if (scrollView == _scrollView.replyTable) {
        text = @"你是不可能看到这段文字的\n如果你看到了\n这个时候......\n我们的服务器工程师正在卷文件走人";
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (scrollView == _scrollView.collectionView) {
        return !_isfirstLoadingAsk;
    } else if (scrollView == _scrollView.replyTable) {
        return !_isfirstLoadingReply;
    }
    return NO;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - Getters and Setters

-(kfcHomeScrollView*)scrollView {
    if (!_scrollView) {
        _scrollView = [kfcHomeScrollView new];
        _scrollView.delegate =self;
    }
    return _scrollView;
}

- (JGActionSheet *)psActionSheet {
    WS(ws);
    if (!_psActionSheet) {
        _psActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"下载图片帮P", @"添加至进行中",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:2];
        NSArray *sections = @[section];
        _psActionSheet = [JGActionSheet actionSheetWithSections:sections];
        _psActionSheet.delegate = self;
        [_psActionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_psActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 0:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws help:YES];
                    break;
                case 1:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws help:NO];
                    break;
                case 2:
                    [ws.psActionSheet dismissAnimated:YES];
                    break;
                default:
                    [ws.psActionSheet dismissAnimated:YES];
                    break;
            }
        }];
    }
    return _psActionSheet;
}

- (JGActionSheet *)reportActionSheet {
    WS(ws);
    if (!_reportActionSheet) {
        _reportActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"色情、淫秽或低俗内容", @"广告或垃圾信息",@"违反法律法规的内容"] buttonStyle:JGActionSheetButtonStyleDefault];
        NSArray *sections = @[section];
        _reportActionSheet = [JGActionSheet actionSheetWithSections:sections];
        _reportActionSheet.delegate = self;
        [_reportActionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_reportActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(ws.selectedVM.ID) forKey:@"target_id"];
            [param setObject:@(PIEPageTypeAsk) forKey:@"target_type"];
            UIButton* b = section.buttons[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 1:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 2:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                default:
                    [ws.reportActionSheet dismissAnimated:YES];
                    break;
            }
            [ATOMReportModel report:param withBlock:^(NSError *error) {
                UIView* view;
                if (ws.scrollView.type == PIENewScrollTypeReply) {
                    view = ws.hotTableView;
                } else  if (ws.scrollView.type == PIENewScrollTypeAsk) {
                    view = ws.askCollectionView;
                }
                if(!error) {
                    [Hud text:@"已举报" inView:view];
                }
                
            }];
        }];
    }
    return _reportActionSheet;
}



- (HMSegmentedControl*)segmentedControl {
    WS(ws);
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"求P",@"作品"]];
        _segmentedControl.frame = CGRectMake(0, 120, 200, 45);
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.6], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (index == 0) {
                [ws.scrollView toggleWithType:PIENewScrollTypeAsk];
                [ws firstGetSourceIfEmpty_ask];
            } else {
                [ws.scrollView toggleWithType:PIENewScrollTypeReply];
                [ws firstGetSourceIfEmpty_Reply];
            }
        }];
    }
    return _segmentedControl;
}

#pragma mark - Gesture Event

- (void)tapGestureReply:(UITapGestureRecognizer *)gesture {
    if (_scrollView.type == PIENewScrollTypeReply) {
        CGPoint location = [gesture locationInView:_hotTableView];
        _selectedIndexPath = [_hotTableView indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            _selectedReplyCell = [_hotTableView cellForRowAtIndexPath:_selectedIndexPath];
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
                PIECarouselViewController* vc = [PIECarouselViewController new];
                _selectedVM.image = _selectedReplyCell.theImageView.image;
                vc.pageVM = _selectedVM;
                [self.navigationController pushViewController:vc animated:YES];
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
            else if (CGRectContainsPoint(_selectedReplyCell.collectView.frame, p)) {
                //should write this logic in viewModel
                [self collect:_selectedReplyCell.collectView shouldShowHud:NO];
            }
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
                DDCommentVC* vc = [DDCommentVC new];
                vc.vm = _selectedVM;
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
        CGPoint location = [gesture locationInView:_hotTableView];
        _selectedIndexPath = [_hotTableView indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            _selectedReplyCell = [_hotTableView cellForRowAtIndexPath:_selectedIndexPath];
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
        CGPoint location = [gesture locationInView:_askCollectionView];
        NSIndexPath *indexPath = [_askCollectionView indexPathForItemAtPoint:location];
        if (indexPath) {
           PIENewAskCollectionCell* cell= (PIENewAskCollectionCell *)[_askCollectionView cellForItemAtIndexPath:indexPath];
            _selectedVM = _sourceAsk[indexPath.row];
            CGPoint p = [gesture locationInView:cell];
            //点击大图
            if (CGRectContainsPoint(cell.leftImageView.frame, p) || CGRectContainsPoint(cell.rightImageView.frame, p)) {
                [self showShareView];
            }
        }
    }
}
- (void)tapGestureAsk:(UITapGestureRecognizer *)gesture {
    if (_scrollView.type == PIENewScrollTypeAsk) {
        CGPoint location = [gesture locationInView:_askCollectionView];
        NSIndexPath *indexPath = [_askCollectionView indexPathForItemAtPoint:location];
        if (indexPath) {
       PIENewAskCollectionCell*  cell= (PIENewAskCollectionCell *)[_askCollectionView cellForItemAtIndexPath:indexPath];
            _selectedVM = _sourceAsk[indexPath.row];
            CGPoint p = [gesture locationInView:cell];
            
            //点击大图
            if (CGRectContainsPoint(cell.leftImageView.frame, p) || CGRectContainsPoint(cell.rightImageView.frame, p)) {
                DDCommentVC* vc = [DDCommentVC new];
                vc.vm = _selectedVM;
                //                PIECarouselViewController* vc = [PIECarouselViewController new];
                //                vc.pageVM = _selectedVM;
                [self.navigationController pushViewController:vc animated:YES];
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
                [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
            }
        }
    }
}

@end
