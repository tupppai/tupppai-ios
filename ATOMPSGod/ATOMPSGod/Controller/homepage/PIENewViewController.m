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
#import "DDHomePageManager.h"
#import "PIEShareView.h"
#import "DDShareManager.h"
#import "DDCollectManager.h"
#import "DDInviteVC.h"
#import "JGActionSheet.h"
#import "ATOMReportModel.h"
#import "HMSegmentedControl.h"
#import "DDCommentVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PIECarouselViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIENewAskCollectionCell.h"
#import "PIERefreshCollectionView.h"
#import "PIERefreshTableView.h"
#import "PIEFriendViewController.h"
#import "PIEReplyCollectionViewController.h"
@class PIEPageEntity;
#define AskCellWidth (SCREEN_WIDTH - 20) / 2.0

@interface PIENewViewController() < UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,PWRefreshBaseCollectionViewDelegate,PIEShareViewDelegate,JGActionSheetDelegate,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
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

@property (nonatomic, assign) BOOL isFirstEnterSecondView;

//@property (nonatomic, strong) PIEShareFunctionView *shareFunctionView;
@property (nonatomic, strong)  JGActionSheet * cameraActionsheet;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) PIENewAskCollectionCell *selectedAskCell;
@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;
@property (nonatomic, strong) DDPageVM *selectedVM;
@property (nonatomic, strong) PIEShareView *shareView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation PIENewViewController

static NSString *CellIdentifier = @"PIENewReplyTableCell";
static NSString *CellIdentifier2 = @"PIENewAskCollectionCell";

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [self shouldNavToAskSegment];
    [self shouldNavToHotSegment];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_New" object:nil];
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
    _isFirstEnterSecondView = YES;
    
    _isfirstLoadingAsk = YES;
    _isfirstLoadingReply = YES;
    
    _sourceAsk = [NSMutableArray new];
    _sourceReply = [NSMutableArray new];
    //    [self firstGetDataSourceFromDataBase];
    [self getRemoteAskSource:^(BOOL finished) {
        if (finished) {
            [self getRemoteReplySource];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_New" object:nil];
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

- (void)shouldNavToHotSegment {
    BOOL shouldNav = [[NSUserDefaults standardUserDefaults]
                      boolForKey:@"shouldNavToHotSegment"];
    if (shouldNav) {
        [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
        [_scrollView toggleWithType:PIENewScrollTypeReply];
        [_hotTableView.header beginRefreshing];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"shouldNavToHotSegment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)shouldNavToAskSegment {
    BOOL shouldNav = [[NSUserDefaults standardUserDefaults]
                      boolForKey:@"shouldNavToAskSegment"];
    if (shouldNav) {
        [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
        [_scrollView toggleWithType:PIENewScrollTypeAsk];
        [_askCollectionView.header beginRefreshing];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"shouldNavToAskSegment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


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
            _selectedAskCell= (PIENewAskCollectionCell *)[_askCollectionView cellForItemAtIndexPath:indexPath];
            _selectedVM = _sourceAsk[indexPath.row];
            CGPoint p = [gesture locationInView:_selectedAskCell];
            //点击大图
            if (CGRectContainsPoint(_selectedAskCell.leftImageView.frame, p) || CGRectContainsPoint(_selectedAskCell.rightImageView.frame, p)) {
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
            _selectedAskCell= (PIENewAskCollectionCell *)[_askCollectionView cellForItemAtIndexPath:indexPath];
            _selectedVM = _sourceAsk[indexPath.row];
            CGPoint p = [gesture locationInView:_selectedAskCell];
            
            //点击大图
            if (CGRectContainsPoint(_selectedAskCell.leftImageView.frame, p) || CGRectContainsPoint(_selectedAskCell.rightImageView.frame, p)) {
                DDCommentVC* vc = [DDCommentVC new];
                vc.vm = _selectedVM;
//                PIECarouselViewController* vc = [PIECarouselViewController new];
//                vc.pageVM = _selectedVM;
                [self.navigationController pushViewController:vc animated:YES];
            }
            //点击头像
            else if (CGRectContainsPoint(_selectedAskCell.avatarView.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self.navigationController pushViewController:friendVC animated:YES];
            }
            
            //点击用户名
            else if (CGRectContainsPoint(_selectedAskCell.nameLabel.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self.navigationController pushViewController:friendVC animated:YES];
            }
            //点击帮p
            else if (CGRectContainsPoint(_selectedAskCell.bangView.frame, p)) {
                [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
            }
        }
    }
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
        } else if (currentPage == 1) {
            _hotTableView.scrollsToTop = YES;
            _askCollectionView.scrollsToTop = NO;
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            _scrollView.type = PIENewScrollTypeReply;
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
//获取服务器的最新数据
- (void)getRemoteAskSource:(void (^)(BOOL finished))block{
    WS(ws);
    [ws.scrollView.collectionView.footer endRefreshing];
    _currentAskIndex = 1;
    [_askCollectionView.footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary new];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    DDHomePageManager *pageManager = [DDHomePageManager new];
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        ws.isfirstLoadingAsk = NO;
        if (homepageArray.count) {
            [ws.sourceAsk addObjectsFromArray:homepageArray];
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
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(_currentAskIndex) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    DDHomePageManager *pageManager = [DDHomePageManager new];
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
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];

    DDHomePageManager *pageManager = [DDHomePageManager new];
    [pageManager pullReplySource:param block:^(NSMutableArray *array) {
        ws.isfirstLoadingReply = NO;
        if (array.count) {
                [ws.sourceReply removeAllObjects];
                [ws.sourceReply addObjectsFromArray:array] ;
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
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentHotIndex) forKey:@"page"];
    DDHomePageManager *pageManager = [DDHomePageManager new];
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
    [DDShareSDKManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeSinaWeibo withPageType:_selectedVM.type];
}
//qqzone
-(void)tapShare2 {
    [DDShareSDKManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQZone withPageType:_selectedVM.type];
}
//wechat moments
-(void)tapShare3 {
    [DDShareSDKManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatMoments withPageType:_selectedVM.type];
}
//wechat friends
-(void)tapShare4 {
    [DDShareSDKManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatFriends withPageType:_selectedVM.type];
}
-(void)tapShare5 {
    [DDShareSDKManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQFriends withPageType:_selectedVM.type];
}
-(void)tapShare6 {
    
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
    [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDPageVM* vm =   [_sourceAsk objectAtIndex:indexPath.row];
    
    CGFloat width;
    CGFloat height;
    
    width = AskCellWidth;
    height = vm.imageHeight + 135;
    height = MAX(height, 270);
    if (height > (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3) {
        height = (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3;
    }
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
        _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
        _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (index == 0) {
                [ws.scrollView toggleWithType:PIENewScrollTypeAsk];
            } else {
                [ws.scrollView toggleWithType:PIENewScrollTypeReply];
            }
        }];
    }
    return _segmentedControl;
}



@end
