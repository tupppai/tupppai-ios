//
//  HomeViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//
#import "DDHomeVC.h"
#import "AppDelegate.h"
#import "PIEReplyTableCell.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMProceedingViewController.h"
#import "DDPageVM.h"
#import "kfcHomeScrollView.h"
#import "DDHomePageManager.h"
#import "ATOMShareFunctionView.h"
#import "DDShareManager.h"
#import "DDCollectManager.h"
#import "DDInviteVC.h"
#import "JGActionSheet.h"
#import "ATOMReportModel.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "HMSegmentedControl.h"
#import "DDCommentVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PIEDetailPageVC.h"
#import "QBImagePicker.h"
#import "PIEUploadVC.h"

#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEAskCollectionCell.h"
#import "PIERefreshCollectionView.h"
#import "RefreshTableView.h"

@class PIEPageEntity;
#define AskCellWidth (SCREEN_WIDTH - 20) / 2.0
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self
@interface DDHomeVC() < UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,PWRefreshBaseCollectionViewDelegate,ATOMShareFunctionViewDelegate,JGActionSheetDelegate,QBImagePickerControllerDelegate,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureReply;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureAsk;

@property (nonatomic, strong) NSMutableArray *sourceHot;
@property (nonatomic, strong) NSMutableArray *sourceAsk;
@property (nonatomic, assign) NSInteger currentHotIndex;
@property (nonatomic, assign) NSInteger currentAskIndex;
@property (nonatomic, strong) kfcHomeScrollView *scrollView;
@property (nonatomic, weak) PIERefreshCollectionView *askCollectionView;
@property (nonatomic, weak) RefreshTableView *hotTableView;
@property (nonatomic, assign) BOOL canRefreshHotFooter;
@property (nonatomic, assign) BOOL canRefreshRecentFooter;

@property (nonatomic, assign) BOOL isFirstEnterSecondView;


@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong)  JGActionSheet * cameraActionsheet;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) DDPageVM *selectedVM;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;

@end

@implementation DDHomeVC

static NSString *CellIdentifier = @"PIEReplyTableCell";
static NSString *CellIdentifier2 = @"PIEAskCollectionCell";

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNav1" object:nil];
    //compiler would call [super dealloc] automatically in ARC.
}


#pragma mark - init methods


- (void)commonInit {
    self.view = self.scrollView;
    [self createCustomNavigationBar];
    [self confighotTable];
    [self configAskView];
    
    //set this before firstGetRemoteSource
    _canRefreshHotFooter = YES;
    _canRefreshRecentFooter = YES;
    _isFirstEnterSecondView = YES;
    _sourceAsk = [NSMutableArray new];
    _sourceHot = [NSMutableArray new];
//    [self firstGetDataSourceFromDataBase];
    [self firstGetRemoteSource:PIEHomeTypeAsk];
    [self firstGetRemoteSource:PIEHomeTypeHot];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNav1) name:@"RefreshNav1" object:nil];

}

- (void)confighotTable {
    _hotTableView = _scrollView.replyTable;
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    _hotTableView.noDataView.label.text = @"网络连接断了吧-_-!";
    _hotTableView.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [_hotTableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    _hotTableView.estimatedRowHeight = SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT;
    _tapGestureReply = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureReply:)];
    [_hotTableView addGestureRecognizer:_tapGestureReply];
    _hotTableView.scrollsToTop = YES;
    _currentHotIndex = 1;
}

- (void)configAskView {
    _askCollectionView = _scrollView.collectionView;
    _askCollectionView.dataSource = self;
    _askCollectionView.delegate = self;
    _askCollectionView.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:@"PIEAskCollectionCell" bundle:nil];
    [_askCollectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier2];
    
    _tapGestureAsk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAsk:)];
    [_askCollectionView addGestureRecognizer:_tapGestureAsk];

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
        [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
        [_scrollView toggleWithType:PIEHomeTypeHot];
        [_hotTableView.header beginRefreshing];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"shouldNavToHotSegment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)shouldNavToAskSegment {
    BOOL shouldNav = [[NSUserDefaults standardUserDefaults]
                      boolForKey:@"shouldNavToAskSegment"];
    if (shouldNav) {
        [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
        [_scrollView toggleWithType:PIEHomeTypeAsk];
        [_askCollectionView.header beginRefreshing];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"shouldNavToAskSegment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)shouldRefreshHeader {
    BOOL shouldRefresh = [[NSUserDefaults standardUserDefaults]boolForKey:@"tapNav1"];
    if (shouldRefresh) {
        if (_scrollView.type == PIEHomeTypeHot && ![_hotTableView.header isRefreshing]) {
            [_hotTableView.header beginRefreshing];
        } else if (_scrollView.type == PIEHomeTypeAsk && ![_askCollectionView.header isRefreshing]) {
            [_askCollectionView.header beginRefreshing];
            
        }
    }
}

- (void)refreshNav1 {
    if (_scrollView.type == PIEHomeTypeHot && ![_hotTableView.header isRefreshing]) {
        [_hotTableView.header beginRefreshing];
    } else if (_scrollView.type == PIEHomeTypeAsk && ![_askCollectionView.header isRefreshing]) {
        [_askCollectionView.header beginRefreshing];
    }
}

#pragma mark - event response
//
//- (void)tapOnImageView:(UIImage*)image withURL:(NSString*)url{
//    
//    // Create image info
//    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//    if (image != nil) {
//        imageInfo.image = image;
//    } else {
//        imageInfo.imageURL = [NSURL URLWithString:url];
//    }
//    
//    // Setup view controller
//    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                           initWithImageInfo:imageInfo
//                                           mode:JTSImageViewControllerMode_Image
//                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
//    
//    // Present the view controller.
//    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
////    imageViewer.interactionsDelegate = self;
//}
/**
 *  上传作品
 *
 *  @param tag 0:->进行中  1:->选择相册图片
 */


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
        }
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Hud error:@"保存失败" inView:self.view];
    } else {
        [Hud success:@"保存成功" inView:self.view];
    }
}



#pragma mark - Gesture Event

- (void)tapGestureReply:(UITapGestureRecognizer *)gesture {
    if (_scrollView.type == PIEHomeTypeHot) {
        CGPoint location = [gesture locationInView:_hotTableView];
        _selectedIndexPath = [_hotTableView indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            PIEReplyTableCell* cell = (PIEReplyTableCell *)[_hotTableView cellForRowAtIndexPath:_selectedIndexPath];
            _selectedVM = _sourceHot[_selectedIndexPath.row];
            CGPoint p = [gesture locationInView:cell];
            
            //点击小图
            if (CGRectContainsPoint(cell.thumbView.frame, p)) {
                [cell animateToggleExpanded];
            }
            //点击大图
           else  if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                //进入热门详情
                PIEDetailPageVC* vc = [PIEDetailPageVC new];
               _selectedVM.image = cell.theImageView.image;
                vc.pageVM = _selectedVM;
                [self pushViewController:vc animated:YES];
            }
            //点击头像
            else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedVM.userID;
                    opvc.userName = _selectedVM.username;
                    [self pushViewController:opvc animated:YES];
                }
            //点击用户名
            else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedVM.userID;
                    opvc.userName = _selectedVM.username;
                    [self pushViewController:opvc animated:YES];
                }
            else if (CGRectContainsPoint(cell.collectView.frame, p)) {
                [self collectReply];
            }
            }
        }
}

- (void)tapGestureAsk:(UITapGestureRecognizer *)gesture {
    if (_scrollView.type == PIEHomeTypeAsk) {
    CGPoint location = [gesture locationInView:_askCollectionView];
        NSIndexPath *indexPath = [_askCollectionView indexPathForItemAtPoint:location];
        if (indexPath) {
            PIEAskCollectionCell* cell= (PIEAskCollectionCell *)[_askCollectionView cellForItemAtIndexPath:indexPath];
           _selectedVM = _sourceAsk[indexPath.row];
            CGPoint p = [gesture locationInView:cell];
 
            //点击大图
            if (CGRectContainsPoint(cell.leftImageView.frame, p) || CGRectContainsPoint(cell.rightImageView.frame, p)) {
                NSLog(@"tap on imageview");
            }
            //点击头像
            else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = _selectedVM.userID;
                opvc.userName = _selectedVM.username;
                [self pushViewController:opvc animated:YES];
            }

            //点击用户名
            else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = _selectedVM.userID;
                opvc.userName = _selectedVM.username;
                [self pushViewController:opvc animated:YES];
            }
            //点击帮p
            else if (CGRectContainsPoint(cell.bangView.frame, p)) {
                [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
            }
        }
    }
}

#pragma mark - QBImagePickerControllerDelegate


-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int currentPage = (_scrollView.contentOffset.x + CGWidth(_scrollView.frame) * 0.1) / CGWidth(_scrollView.frame);
        if (currentPage == 0) {
            [_scrollView toggleWithType:PIEHomeTypeAsk];
            _hotTableView.scrollsToTop = NO;
            _askCollectionView.scrollsToTop = YES;
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
        } else if (currentPage == 1) {
            [_scrollView toggleWithType:PIEHomeTypeHot];
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            _hotTableView.scrollsToTop = YES;
            _askCollectionView.scrollsToTop = NO;
        }
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_hotTableView == tableView) {
        return _sourceHot.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hotTableView == tableView) {
        PIEReplyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell configCell:_sourceHot[indexPath.row] row:indexPath.row];
        return cell;
    }
    else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hotTableView == tableView) {
            return [tableView fd_heightForCellWithIdentifier:CellIdentifier  cacheByIndexPath:indexPath configuration:^(PIEReplyTableCell *cell) {
            [cell configCell:_sourceHot[indexPath.row] row:indexPath.row];
        }];
    } else {
        return 0;
    }
}

#pragma mark - ATOMViewControllerDelegate


#pragma mark - GetDataSource from DB
//- (void)firstGetDataSourceFromDataBase {
//    
//    _sourceAsk = [self fetchDBDataSourceWithHomeType:PIEHomeTypeAsk];
//    [_askCollectionView reloadData];
//    
////    _sourceHot = [self fetchDBDataSourceWithHomeType:PIEHomeTypeHot];
//}
#pragma mark - GetDataSource from Server

//初始数据
- (void)firstGetRemoteSource:(PIEHomeType)homeType {
    if (homeType == PIEHomeTypeHot) {
        [self getRemoteSourceWithPageType:PIEHomeTypeHot];
    }
    else if (homeType == PIEHomeTypeAsk) {
        [self getRemoteSourceWithPageType:PIEHomeTypeAsk];
    }
}

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
- (void)getRemoteSourceWithPageType:(PIEHomeType)homeType {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary new];
    double timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    if (homeType == PIEHomeTypeAsk) {
        _currentAskIndex = 1;
        [_askCollectionView.footer endRefreshing];
        [param setObject:@"new" forKey:@"type"];
        [param setObject:@(AskCellWidth) forKey:@"width"];
    } else if (homeType == PIEHomeTypeHot) {
        _currentHotIndex = 1;
        [_hotTableView.footer endRefreshing];
        [param setObject:@"hot" forKey:@"type"];
        [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    }
    DDHomePageManager *pageManager = [DDHomePageManager new];
    [pageManager pullSource:param block:^(NSMutableArray *homepageArray) {
        if (homepageArray.count) {

            NSMutableArray* arrayAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in homepageArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [arrayAgent addObject:vm];
            }
            if (homeType == PIEHomeTypeHot) {
                [ws.sourceHot removeAllObjects];
                [ws.sourceHot addObjectsFromArray:arrayAgent] ;
                [ws.hotTableView reloadData];
                [ws.hotTableView.header endRefreshing];
            } else if (homeType == PIEHomeTypeAsk) {
                [ws.sourceAsk removeAllObjects];
                [ws.sourceAsk addObjectsFromArray:arrayAgent];
                [ws.askCollectionView reloadData];
                [ws.scrollView.collectionView.header endRefreshing];
            }
//            if (_scrollView.type == PIEHomeTypeAsk) {
//                [ws.scrollView.collectionView reloadData];
//            } else {
//                [ws.hotTableView reloadData];
//            }
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                [pageManager saveHomeImagesInDB:homepageArray];
//            });
        } else {
            [ws.scrollView.replyTable.header endRefreshing];
            [ws.scrollView.collectionView.header endRefreshing];
        }
    }];
    
}

//拉至底层刷新
- (void)getMoreRemoteSourceWithType:(PIEHomeType)homeType {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (homeType == PIEHomeTypeAsk) {
        ws.currentAskIndex++;
        [param setObject:@(ws.currentAskIndex) forKey:@"page"];
        [param setObject:@"new" forKey:@"type"];
        [param setObject:@(AskCellWidth) forKey:@"width"];
    } else if (homeType == PIEHomeTypeHot) {
        ws.currentHotIndex++;
        [param setObject:@(ws.currentHotIndex) forKey:@"page"];
        [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
        [param setObject:@"hot" forKey:@"type"];
    }
    double timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(10) forKey:@"size"];
    
    DDHomePageManager *pageManager = [DDHomePageManager new];
    [pageManager pullSource:param block:^(NSMutableArray *homepageArray) {
        if (homepageArray) {
            NSMutableArray* arrayAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in homepageArray) {
                DDPageVM *model = [[DDPageVM alloc]initWithPageEntity:homeImage];
                [arrayAgent addObject:model];
            }
            if (homeType == PIEHomeTypeHot) {
                [_sourceHot addObjectsFromArray:arrayAgent];
                [ws.scrollView.replyTable reloadData];
                [ws.scrollView.replyTable.footer endRefreshing];
                if (homepageArray.count == 0) {
                    ws.canRefreshHotFooter = NO;
                } else {
                    ws.canRefreshHotFooter = YES;
                }
            } else if (homeType == PIEHomeTypeAsk) {
                [_sourceAsk addObjectsFromArray:arrayAgent];
                [ws.scrollView.collectionView reloadData];
                [ws.scrollView.collectionView.footer endRefreshing];
                if (homepageArray.count == 0) {
                    ws.canRefreshRecentFooter = NO;
                } else {
                    ws.canRefreshRecentFooter = YES;
                }
            }
        } else {
            [ws.scrollView.replyTable.footer endRefreshing];
            [ws.scrollView.collectionView.footer endRefreshing];
        }
    }];
}


#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:PIEPageTypeAsk];
}
-(void)tapWechatMoment {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:PIEPageTypeAsk];
}
-(void)tapSinaWeibo {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:PIEPageTypeAsk];
}
-(void)tapInvite {
    DDInviteVC* ivc = [DDInviteVC new];
    ivc.askPageViewModel = _selectedVM;
    [self pushViewController:ivc animated:YES];
}
-(void)collectReply{
    PIEReplyTableCell* cell = [_hotTableView cellForRowAtIndexPath:_selectedIndexPath];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (cell.collectView.selected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:PIEPageTypeReply withID:_selectedVM.ID withBlock:^(NSError *error) {
        if (!error) {
//            _selectedVM.collected = cell.collectView.highlighted;
        }   else {
//            cell.collectView.highlighted = !cell.collectView.highlighted;
//            cell.collectCountLabel.selected = !cell.collectCountLabel.selected;
        }
    }];
}
-(void)toggleLabel:(UILabel*)label toggle:(BOOL)toggle{
    if (toggle) {
        NSInteger count = [label.text integerValue];
        label.text = [NSString stringWithFormat:@"%zd",count+1];
    }
}

-(void)tapReport {
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
}
#pragma mark - Refresh

- (void)loadNewHotData {
    [self getRemoteSourceWithPageType:PIEHomeTypeHot];
}

- (void)loadMoreHotData {
    if (_canRefreshHotFooter && !_hotTableView.header.isRefreshing) {
        [self getMoreRemoteSourceWithType:PIEHomeTypeHot];
    } else {
        [_hotTableView.footer endRefreshing];
    }
}


- (void)loadNewRecentData {
    [self getRemoteSourceWithPageType:PIEHomeTypeAsk];
}

- (void)loadMoreRecentData {
    if (_canRefreshRecentFooter && !_askCollectionView.header.isRefreshing) {
        [self getMoreRemoteSourceWithType:PIEHomeTypeAsk];
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
    PIEAskCollectionCell*cell =
    (PIEAskCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2
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
    if (height > (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3) {
        height = (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3;
    }
    return CGSizeMake(width, height);
}


#pragma mark - Getters and Setters

-(kfcHomeScrollView*)scrollView {
    if (!_scrollView) {
        _scrollView = [kfcHomeScrollView new];
        _scrollView.delegate =self;
    }
    return _scrollView;
}

- (ATOMShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [ATOMShareFunctionView new];
        _shareFunctionView.delegate = self;
    }
    return _shareFunctionView;
}

- (JGActionSheet *)psActionSheet {
    WS(ws);
    if (!_psActionSheet) {
        _psActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"下载图片，马上帮P", @"塞入“进行中”,暂不下载",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
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
                if (ws.scrollView.type == PIEHomeTypeHot) {
                    view = ws.hotTableView;
                } else  if (ws.scrollView.type == PIEHomeTypeAsk) {
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

- (QBImagePickerController* )QBImagePickerController {
    if (!_QBImagePickerController) {
        _QBImagePickerController = [QBImagePickerController new];
        _QBImagePickerController.delegate = self;
        _QBImagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        _QBImagePickerController.allowsMultipleSelection = YES;
        _QBImagePickerController.showsNumberOfSelectedAssets = YES;
        _QBImagePickerController.minimumNumberOfSelection = 1;
        _QBImagePickerController.maximumNumberOfSelection = 2;
    }
    return _QBImagePickerController;
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
            [ws.scrollView toggle];
        }];
    }
    return _segmentedControl;
}
@end
