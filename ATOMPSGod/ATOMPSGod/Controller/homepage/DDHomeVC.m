//
//  HomeViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//
#import "DDHomeVC.h"
#import "AppDelegate.h"
#import "PIEHotTableCell.h"
#import "DDDetailPageVC.h"
#import "DDCropImageVC.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMProceedingViewController.h"
#import "DDPageVM.h"
#import "kfcHomeScrollView.h"
#import "DDHomePageManager.h"
#import "ATOMShareFunctionView.h"
#import "DDCommentPageVM.h"
#import "DDShareManager.h"
#import "DDCollectManager.h"
#import "DDInviteVC.h"
#import "JGActionSheet.h"
#import "ATOMReportModel.h"
#import "DDService.h"
#import "DDBaseService.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "HMSegmentedControl.h"
#import "DDBaseService.h"
#import "DDCommentVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PIEDetailPageVC.h"
#import "QBImagePicker.h"
#import "PIEUploadVC.h"

#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEAskCollectionCell.h"
#import "PIERefreshCollectionView.h"
#import "RefreshTableView.h"
//#import "QBImagePickerController.h"
@class ATOMAskPage;
#define AskCellWidth (SCREEN_WIDTH - 20) / 2.0
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self
@interface DDHomeVC() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,PWRefreshBaseCollectionViewDelegate,ATOMViewControllerDelegate,ATOMShareFunctionViewDelegate,JGActionSheetDelegate,QBImagePickerControllerDelegate,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureHot;
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

@property (nonatomic, assign) BOOL isfirstEnterHomepageRecentView;


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

static NSString *CellIdentifier = @"HotCell";
static NSString *CellIdentifier2 = @"AskCell";

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
    [self configaskTable];
    
    //set this before firstGetRemoteSource
    _canRefreshHotFooter = YES;
    _canRefreshRecentFooter = YES;
    _sourceAsk = [NSMutableArray new];
    _sourceHot = [NSMutableArray new];
    
    [self firstGetDataSourceFromDataBase];
    [self firstGetRemoteSource:PIEHomeTypeAsk];
    [self firstGetRemoteSource:PIEHomeTypeHot];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNav1) name:@"RefreshNav1" object:nil];
}


- (void)confighotTable {
    _hotTableView = _scrollView.hotTable;
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    _hotTableView.noDataView.label.text = @"网络连接断了吧-_-!";
    _hotTableView.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:@"PIEHotTableCell" bundle:nil];
    [_hotTableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    _hotTableView.estimatedRowHeight = SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT;
    _tapGestureHot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHot:)];
    [_hotTableView addGestureRecognizer:_tapGestureHot];
    
    _hotTableView.scrollsToTop = YES;
    _currentHotIndex = 1;
//    _pieCollectionView.scrollsToTop = NO;

}
- (void)configaskTable {
    _askCollectionView = _scrollView.collectionView;
    _askCollectionView.dataSource = self;
    _askCollectionView.delegate = self;
    _askCollectionView.psDelegate = self;
    _currentAskIndex = 1;
}

- (void)createCustomNavigationBar {
    WS(ws);
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;
    UIView *cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    [cameraButton setImage:[UIImage imageNamed:@"btn_psask_normal"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"btn_psask_pressed"] forState:UIControlStateHighlighted];
    [cameraButton setImageEdgeInsets:UIEdgeInsetsMake(5.5, 5, 5.5, 0)];
    [cameraButton addTarget:self action:@selector(tappedCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [cameraView addSubview:cameraButton];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraView];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightButtonItem];

    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"求P",@"热门"]];
    _segmentedControl.frame = CGRectMake(0, 120, 200, 45);
    _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
    _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [ws.scrollView toggle];
    }];

    _segmentedControl.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _segmentedControl;

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

- (void)tappedCameraButton:(UIBarButtonItem *)sender {
    [self.cameraActionsheet showInView:[AppDelegate APP].window animated:YES];
}

- (void)tapSelectPhotos {
    [[NSUserDefaults standardUserDefaults] setObject:@"Ask" forKey:@"AskOrReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
//        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.QBImagePickerController animated:YES completion:NULL];
    }
    else
    {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"😭" andMessage:@"找不到你的相册在哪"];
        [alertView addButtonWithTitle:@"我知道了"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleFade;
        [alertView show];
    }
}
- (void)tapOnImageView:(UIImage*)image withURL:(NSString*)url{
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (image != nil) {
        imageInfo.image = image;
    } else {
        imageInfo.imageURL = [NSURL URLWithString:url];
    }
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
//    imageViewer.interactionsDelegate = self;
}
/**
 *  上传作品
 *
 *  @param tag 0:->进行中  1:->选择相册图片
 */
- (void)dealUploadWorksWithTag:(NSInteger)tag {
    
    PIEUploadVC *vc = [[PIEUploadVC alloc] initWithNibName:@"PIEUploadVC" bundle:nil];
    [self pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
//    [[NSUserDefaults standardUserDefaults] setObject:@"Reply" forKey:@"AskOrReply"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    if (tag == 0) {
//        ATOMProceedingViewController *pvc = [ATOMProceedingViewController new];
//        [self pushViewController:pvc animated:YES];
//    } else {
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//        {
//            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentViewController:_imagePickerController animated:YES completion:NULL];
//        }
//        else
//        {
//            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"😭" andMessage:@"找不到你的相册在哪"];
//            [alertView addButtonWithTitle:@"我知道了"
//                                     type:SIAlertViewButtonTypeDefault
//                                  handler:^(SIAlertView *alert) {
//                                  }];
//            alertView.transitionStyle = SIAlertViewTransitionStyleFade;
//            [alertView show];
//        }
//    }
}

- (void)dealDownloadWork {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_selectedVM.ID) forKey:@"target"];
    
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        if (imageUrl != nil) {
//            [DDBaseService downloadImage:imageUrl withBlock:^(UIImage *image) {
//            kfcAskCell* cell = (kfcAskCell *)[_pieCollectionView cellForRowAtIndexPath:_selectedIndexPath];
//                UIImageWriteToSavedPhotosAlbum(cell.imageViewMain.image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//            }];
        }
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Hud error:@"保存失败" inView:self.view];
    }else{
        [Hud success:@"保存成功" inView:self.view];
    }
}



#pragma mark - Gesture Event

- (void)tapGestureHot:(UITapGestureRecognizer *)gesture {
    if (_scrollView.type == PIEHomeTypeHot) {
        CGPoint location = [gesture locationInView:_hotTableView];
        _selectedIndexPath = [_hotTableView indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            PIEHotTableCell* cell = (PIEHotTableCell *)[_hotTableView cellForRowAtIndexPath:_selectedIndexPath];
            _selectedVM = _sourceHot[_selectedIndexPath.row];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.thumbView.frame, p)) {
                [cell animateToggleExpanded];
            }
           else  if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                //进入热门详情
                PIEDetailPageVC* vc = [PIEDetailPageVC new];
               _selectedVM.image = cell.theImageView.image;
                vc.pageVM = _selectedVM;
                [self pushViewController:vc animated:YES];

            }
//            else if (CGRectContainsPoint(cell.topView.frame, p)) {
//                p = [gesture locationInView:cell.topView];
//                if (CGRectContainsPoint(cell.avatarView.frame, p)) {
//                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
//                    opvc.userID = _selectedVM.userID;
//                    opvc.userName = _selectedVM.username;
//                    [self pushViewController:opvc animated:YES];
//                } else if (CGRectContainsPoint(cell.usernameLabel.frame, p)) {
//                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
//                    opvc.userID = _selectedVM.userID;
//                    opvc.userName = _selectedVM.username;
//                    [self pushViewController:opvc animated:YES];
//                }
//            } else if (CGRectContainsPoint(cell.bottomView.frame, p)){
//                p = [gesture locationInView:cell.bottomView];
//                if (CGRectContainsPoint(cell.likeButton.frame, p)) {
//                    [cell.likeButton toggleLike];
//                    [_selectedVM toggleLike];
//                } else if (CGRectContainsPoint(cell.wechatButton.frame, p)) {
//                    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
//                } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
//                    DDCommentPageVM* vm = [DDCommentPageVM new];
//                    [vm setCommonViewModelWithAsk:_selectedVM];
//                    DDCommentVC* mvc = [DDCommentVC new];
//                    mvc.vm = vm;
//                    mvc.delegate = self;
//                    [self pushViewController:mvc animated:YES];
//                } else if (CGRectContainsPoint(cell.moreButton.frame, p)) {
//                    self.shareFunctionView.collectButton.selected = _selectedVM.collected;
//                    [self.shareFunctionView showInView:[AppDelegate APP].window animated:YES];
//                }
//            }
        }
        }
}

//- (void)tapGestureAsk:(UITapGestureRecognizer *)gesture {
//    if (_scrollView.type == PIEHomeTypeAsk) {
//        CGPoint location = [gesture locationInView:_pieCollectionView];
//        NSIndexPath *indexPath = [_pieCollectionView indexPathForRowAtPoint:location];
//        if (indexPath) {
//            kfcAskCell* cell= (kfcAskCell *)[_pieCollectionView cellForRowAtIndexPath:indexPath];
//           _selectedVM = _sourceAsk[indexPath.row];
//
//            CGPoint p = [gesture locationInView:cell];
//            if (CGRectContainsPoint(cell.imageViewMain.frame, p)) {
//                [self tapOnImageView:cell.imageViewMain.image withURL:_selectedVM.imageURL];
//            } else if (CGRectContainsPoint(cell.topView.frame, p)) {
//                p = [gesture locationInView:cell.topView];
//                if (CGRectContainsPoint(cell.avatarView.frame, p)) {
//                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
//                    opvc.userID = _selectedVM.userID;
//                    opvc.userName = _selectedVM.username;
//                    [self pushViewController:opvc animated:YES];
//                } else if (CGRectContainsPoint(cell.psView.frame, p)) {
//                    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
//                } else if (CGRectContainsPoint(cell.usernameLabel.frame, p)) {
//                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
//                    opvc.userID = _selectedVM.userID;
//                    opvc.userName = _selectedVM.username;
//                    [self pushViewController:opvc animated:YES];
//                }
//            } else if (CGRectContainsPoint(cell.bottomView.frame, p)){
//                p = [gesture locationInView:cell.bottomView];
//                if (CGRectContainsPoint(cell.likeButton.frame, p)) {
//                    [cell.likeButton toggleLike];
//                    [_selectedVM toggleLike];
//                } else if (CGRectContainsPoint(cell.wechatButton.frame, p)) {
//                    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
//                } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
//                    DDCommentPageVM* vm = [DDCommentPageVM new];
//                    [vm setCommonViewModelWithAsk:_selectedVM];
//                    DDCommentVC* mvc = [DDCommentVC new];
//                    mvc.vm = vm;
//                    mvc.delegate = self;
//                    [self pushViewController:mvc animated:YES];
//                } else if (CGRectContainsPoint(cell.moreButton.frame, p)) {
//                    self.shareFunctionView.collectButton.selected = _selectedVM.collected;
//                    [self.shareFunctionView showInView:[AppDelegate APP].window animated:YES];
//                }
//            }
//            
//        }
//    }
//}

#pragma mark - QBImagePickerControllerDelegate


-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:NO completion:^{
        DDCropImageVC *uwvc = [DDCropImageVC new];
        uwvc.originImage = info[UIImagePickerControllerOriginalImage];
        uwvc.askPageViewModel = _selectedVM;
        [ws pushViewController:uwvc animated:YES];
    }];
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
        PIEHotTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
            return [tableView fd_heightForCellWithIdentifier:CellIdentifier  cacheByIndexPath:indexPath configuration:^(PIEHotTableCell *cell) {
            [cell configCell:_sourceHot[indexPath.row] row:indexPath.row];
        }];
    } else {
        return 0;
    }
}

#pragma mark - ATOMViewControllerDelegate


-(void)ATOMViewControllerDismissWithInfo:(NSDictionary *)info {
//    bool liked = [info[@"liked"] boolValue];
//    bool collected = [info[@"collected"]boolValue];
//    if (_scrollView.type == PIEHomeTypeHot) {
//        //当从child viewcontroller 传来的liked变化的时候，toggle like.
//        //to do:其实应该改变datasource的liked ,tableView reload的时候才能保持。
//        PIEHotTableCell* cell= (kfcHotCell *)[_hotTable cellForRowAtIndexPath:_selectedIndexPath];
//        [cell.likeButton toggleLikeWhenSelectedChanged:liked];
//        _selectedVM.collected = collected;
//        NSLog(@"_selectedVM.collected %d",collected);
//
//    } else if (_scrollView.type == PIEHomeTypeAsk) {
//        kfcAskCell* cell= (kfcAskCell *)[_pieCollectionView cellForRowAtIndexPath:_selectedIndexPath];
//        [cell.likeButton toggleLikeWhenSelectedChanged:liked];
//        _selectedVM.collected = collected;
//    }
}


#pragma mark - GetDataSource from DB
- (void)firstGetDataSourceFromDataBase {
    
    _sourceAsk = [self fetchDBDataSourceWithHomeType:PIEHomeTypeAsk];
    [_askCollectionView reloadData];
    
    _sourceHot = [self fetchDBDataSourceWithHomeType:PIEHomeTypeHot];
}
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

-(NSMutableArray*)fetchDBDataSourceWithHomeType:(PIEHomeType) homeType {
    
    DDHomePageManager *showHomepage = [DDHomePageManager new];
    NSArray * homepageArray = [[showHomepage getHomeImagesWithHomeType:homeType] mutableCopy];
    NSMutableArray* tableViewDataSource = [NSMutableArray array];
    for (ATOMAskPage *homeImage in homepageArray) {
        DDPageVM *model = [DDPageVM new];
        [model setViewModelData:homeImage];
        [tableViewDataSource addObject:model];
    }
    return tableViewDataSource;
}
//获取服务器的最新数据
- (void)getRemoteSourceWithPageType:(PIEHomeType)homeType {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary new];
    double timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(10) forKey:@"size"];
    if (homeType == PIEHomeTypeAsk) {
        _currentAskIndex = 1;
        [_askCollectionView.footer endRefreshing];
        [param setObject:@"new" forKey:@"type"];
        [param setObject:@(AskCellWidth) forKey:@"width"];
    } else if (homeType == PIEHomeTypeHot) {
        _currentHotIndex = 1;
        [_hotTableView.footer endRefreshing];
        [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
        [param setObject:@"hot" forKey:@"type"];
    }
    DDHomePageManager *pageManager = [DDHomePageManager new];
    [pageManager getHomepage:param withBlock:^(NSMutableArray *homepageArray, NSError *error) {
        if (homepageArray.count != 0 && error == nil) {
            NSMutableArray* arrayAgent = [NSMutableArray new];
            for (ATOMAskPage *homeImage in homepageArray) {
                DDPageVM *vm = [DDPageVM new];
                [vm setViewModelData:homeImage];
                [arrayAgent addObject:vm];
            }
            
            if (homeType == PIEHomeTypeHot) {
                [ws.sourceHot removeAllObjects];
                [ws.sourceHot addObjectsFromArray:arrayAgent] ;
                    [ws.hotTableView.header endRefreshing];
            } else if (homeType == PIEHomeTypeAsk) {
                [ws.sourceAsk removeAllObjects];
                [ws.sourceAsk addObjectsFromArray:arrayAgent] ;
                [ws.scrollView.collectionView.header endRefreshing];
            }
            if (_scrollView.type == PIEHomeTypeAsk) {
                [ws.scrollView.collectionView reloadData];
            } else {
                [ws.hotTableView reloadData];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [pageManager saveHomeImagesInDB:homepageArray];
            });
        } else {
            [ws.scrollView.hotTable.header endRefreshing];
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
    [pageManager getHomepage:param withBlock:^(NSMutableArray *homepageArray,NSError *error) {
        if (homepageArray && error == nil) {
            NSMutableArray* arrayAgent = [NSMutableArray new];
            for (ATOMAskPage *homeImage in homepageArray) {
                DDPageVM *model = [DDPageVM new];
                [model setViewModelData:homeImage];
                [arrayAgent addObject:model];
            }
            if (homeType == PIEHomeTypeHot) {
                [_sourceHot addObjectsFromArray:arrayAgent];
                [ws.scrollView.hotTable reloadData];
                [ws.scrollView.hotTable.footer endRefreshing];
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
            [ws.scrollView.hotTable.footer endRefreshing];
            [ws.scrollView.collectionView.footer endRefreshing];
        }
    }];
}


#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:ATOMPageTypeAsk];
}
-(void)tapWechatMoment {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
}
-(void)tapSinaWeibo {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:ATOMPageTypeAsk];
}
-(void)tapInvite {
    DDInviteVC* ivc = [DDInviteVC new];
    ivc.askPageViewModel = _selectedVM;
    [self pushViewController:ivc animated:YES];
}
-(void)tapCollect {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (self.shareFunctionView.collectButton.selected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:ATOMPageTypeAsk withID:_selectedVM.ID withBlock:^(NSError *error) {
        if (!error) {
            _selectedVM.collected = self.shareFunctionView.collectButton.selected;
        }   else {
            self.shareFunctionView.collectButton.selected = !self.shareFunctionView.collectButton.selected;
        }
    }];
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

#pragma mark - Getters and Setters

-(kfcHomeScrollView*)scrollView {
    if (!_scrollView) {
        _scrollView = [kfcHomeScrollView new];
        _scrollView.delegate =self;
    }
    return _scrollView;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
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
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"下载素材", @"上传作品",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
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
                    [ws dealDownloadWork];
                    break;
                case 1:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws dealUploadWorksWithTag:1];
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

- (JGActionSheet *)cameraActionsheet {
    WS(ws);
    if (!_cameraActionsheet) {
        _cameraActionsheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"求助上传", @"作品上传",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:2];
        NSArray *sections = @[section];
        _cameraActionsheet = [JGActionSheet actionSheetWithSections:sections];
        _cameraActionsheet.delegate = self;
        [_cameraActionsheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_cameraActionsheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 0:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    [ws tapSelectPhotos];
                    
                    break;
                case 1:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    [ws dealUploadWorksWithTag:0];
                    break;
                case 2:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    break;
                default:
                    [ws.cameraActionsheet dismissAnimated:YES];
                    break;
            }
        }];
    }
    return _cameraActionsheet;
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
            [param setObject:@(ATOMPageTypeAsk) forKey:@"target_type"];
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


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceAsk.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEAskCollectionCell*cell =
    (PIEAskCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WaterfallCell"
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
@end
