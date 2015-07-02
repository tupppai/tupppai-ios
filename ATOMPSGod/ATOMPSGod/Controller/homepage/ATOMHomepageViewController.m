//
//  ATOMHomepageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomepageViewController.h"
#import "ATOMHomePageHotTableViewCell.h"
#import "ATOMhomepageAskTableViewCell.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMPageDetailViewController.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMProceedingViewController.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMHomepageCustomTitleView.h"
#import "ATOMHomepageScrollView.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMShowHomepage.h"
#import "ATOMShareFunctionView.h"
#import "ATOMPSView.h"
#import "AppDelegate.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMCameraView.h"
#import "PWMascotAnimationImageView.h"
#import "ATOMNoDataView.h"
#import "KShareManager.h"
#import "ATOMHomeImageDAO.h"
#import "PWPageDetailViewModel.h"
#import "ATOMShareModel.h"
#import "ATOMCollectModel.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMHomepageViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, ATOMPSViewDelegate, ATOMCameraViewDelegate,PWRefreshBaseTableViewDelegate,ATOMViewControllerDelegate,ATOMShareFunctionViewDelegate>

@property (nonatomic, strong) ATOMHomepageCustomTitleView *customTitleView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapHomePageHotGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapHomePageRecentGesture;
@property (nonatomic, strong) NSMutableArray *dataSourceOfHotTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceOfRecentTableView;
@property (nonatomic, strong) ATOMHomepageScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentHotPage;
@property (nonatomic, assign) NSInteger currentRecentPage;

@property (nonatomic, assign) BOOL isfirstEnterHomepageRecentView;
@property (nonatomic, assign) BOOL canRefreshHotFooter;
@property (nonatomic, assign) BOOL canRefreshRecentFooter;
@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong) ATOMPSView *psView;
@property (nonatomic, strong) ATOMCameraView *cameraView;
@property (nonatomic, strong) UIView *thineNavigationView;

@property (nonatomic, strong) NSIndexPath* seletedIndexPath;
@property (nonatomic, strong) ATOMHomePageHotTableViewCell *selectedHotCell;
@property (nonatomic, strong) ATOMhomepageAskTableViewCell *selectedAskCell;

@property (nonatomic, strong) ATOMAskPageViewModel *selectedAskPageViewModel;

@end

@implementation ATOMHomepageViewController

#pragma mark - Lazy Initialize

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

- (ATOMPSView *)psView {
    if (!_psView) {
        _psView = [ATOMPSView new];
        _psView.delegate = self;
    }
    return _psView;
}

- (ATOMCameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [ATOMCameraView new];
        _cameraView.delegate = self;
    }
    return _cameraView;
}

#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    [self postSocialShare:_selectedAskPageViewModel.imageID withSocialShareType:ATOMShareTypeWechatFriends withPageType:ATOMPageTypeAsk];
}
-(void)tapWechatMoment {
    [self postSocialShare:_selectedAskPageViewModel.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
}
-(void)tapSinaWeibo {
    [self postSocialShare:_selectedAskPageViewModel.imageID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:ATOMPageTypeAsk];
}
-(void)tapInvite {
    
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
    [ATOMCollectModel toggleCollect:param withPageType:ATOMPageTypeAsk withID:_selectedAskPageViewModel.imageID withBlock:^(NSError *error) {
        if (!error) {
            _selectedAskPageViewModel.collected = self.shareFunctionView.collectButton.selected;
        }
    }];
}
-(void)tapReport {
    
}
#pragma mark - Refresh

- (void)loadNewHotData {
    [self getDataSourceOfTableViewWithHomeType:@"hot"];
}

- (void)loadMoreHotData {
    if (_canRefreshHotFooter) {
        [self getMoreDataSourceOfTableViewWithHomeType:@"hot"];
    } else {
        [_scrollView.homepageHotTableView.footer endRefreshing];
    }
}


- (void)loadNewRecentData {
    [self getDataSourceOfTableViewWithHomeType:@"new"];
}

- (void)loadMoreRecentData {
    if (_canRefreshRecentFooter) {
       [self getMoreDataSourceOfTableViewWithHomeType:@"new"];
    } else {
        [_scrollView.homepageAskTableView.footer endRefreshing];
    }
    
}

#pragma mark - PWRefreshBaseTableViewDelegate

-(void)didPullRefreshDown:(UITableView *)tableView{
    if (tableView == _scrollView.homepageHotTableView) {
        [self loadNewHotData];
    } else if(tableView == _scrollView.homepageAskTableView) {
        [self loadNewRecentData];
    }
}

-(void)didPullRefreshUp:(UITableView *)tableView {
    if (tableView == _scrollView.homepageHotTableView) {
        [self loadMoreHotData];
    } else if(tableView == _scrollView.homepageAskTableView) {
        [self loadMoreRecentData];
    }
}




#pragma mark - GetDataSource
//初始数据
- (void)firstGetDataSourceOfTableViewWithHomeType:(ATOMHomepageViewType)homeType {
    [[KShareManager mascotAnimator]show];
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    NSArray * homepageArray = [[showHomepage getHomeImagesWithHomeType:homeType] mutableCopy];
    if (homeType == ATOMHomepageHotType) {
        if (!homepageArray || homepageArray.count == 0) {//读服务器
            [self loadNewHotData];
        } else { //读数据库
            _dataSourceOfHotTableView = [self fetchDBDataSourceWithHomeType:ATOMHomepageHotType];
            _dataSourceOfRecentTableView = [self fetchDBDataSourceWithHomeType:ATOMHomepageAskType];
            [_scrollView.homepageHotTableView.header beginRefreshing];
        }
    } else if (homeType == ATOMHomepageAskType) {
        //数据库没有“求P”数据
        if (!homepageArray || homepageArray.count == 0) {
            [self loadNewRecentData];
        }
        //数据库有“求P”数据
        else {
            [[KShareManager mascotAnimator]dismiss];
            [_scrollView.homepageAskTableView.header beginRefreshing];
        }
    }
}

-(NSMutableArray*)fetchDBDataSourceWithHomeType:(ATOMHomepageViewType) homeType {
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    NSArray * homepageArray = [[showHomepage getHomeImagesWithHomeType:homeType] mutableCopy];
   NSMutableArray* tableViewDataSource = [NSMutableArray array];
    for (ATOMHomeImage *homeImage in homepageArray) {
        ATOMAskPageViewModel *model = [ATOMAskPageViewModel new];
        [model setViewModelData:homeImage];
        [tableViewDataSource addObject:model];
    }
    [[KShareManager mascotAnimator]dismiss];
    return tableViewDataSource;
}

//获取服务器的最新数据
- (void)getDataSourceOfTableViewWithHomeType:(NSString *)homeType {
    WS(ws);
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    double timeStamp = [[NSDate date] timeIntervalSince1970];

    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:homeType forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    [showHomepage clearHomePagesWithHomeType:homeType];

    [showHomepage ShowHomepage:param withBlock:^(NSMutableArray *homepageArray, NSError *error) {
     
        if (homepageArray && error == nil) {
            if ([homeType isEqualToString:@"new"]) {
                _dataSourceOfRecentTableView = nil;
                _dataSourceOfRecentTableView = [NSMutableArray array];
                _currentRecentPage = 1;
                [param setObject:@(_currentRecentPage) forKey:@"page"];
            } else if ([homeType isEqualToString:@"hot"]) {
                _dataSourceOfHotTableView = nil;
                _dataSourceOfHotTableView = [NSMutableArray array];
                _currentHotPage = 1;
                [param setObject:@(_currentHotPage) forKey:@"page"];
            }
            
            for (ATOMHomeImage *homeImage in homepageArray) {
                ATOMAskPageViewModel *model = [ATOMAskPageViewModel new];
                [model setViewModelData:homeImage];
                if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
                    [ws.dataSourceOfHotTableView addObject:model];
                } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageAskType) {
                    [ws.dataSourceOfRecentTableView addObject:model];
                }
            }
            [showHomepage saveHomeImagesInDB:homepageArray];
            
            if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
                [ws.scrollView.homepageHotTableView reloadData];
                [ws.scrollView.homepageHotTableView.header endRefreshing];
            } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageAskType) {
                [ws.scrollView.homepageAskTableView reloadData];
                [ws.scrollView.homepageAskTableView.header endRefreshing];
            }
        } else {
            [ws.scrollView.homepageHotTableView.header endRefreshing];
            [ws.scrollView.homepageAskTableView.header endRefreshing];
        }
        [[KShareManager mascotAnimator] dismiss];
            
    }];

}

//拉至底层刷新
- (void)getMoreDataSourceOfTableViewWithHomeType:(NSString *)homeType {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary new];
    double timeStamp = [[NSDate date] timeIntervalSince1970];
    if ([homeType isEqualToString:@"new"]) {
        ws.currentRecentPage++;
        [param setObject:@(ws.currentRecentPage) forKey:@"page"];
    } else if ([homeType isEqualToString:@"hot"]) {
        ws.currentHotPage++;
        [param setObject:@(ws.currentHotPage) forKey:@"page"];
    }
    [param setObject:@(SCREEN_WIDTH - kPadding15 * 2) forKey:@"width"];
    [param setObject:homeType forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    [showHomepage ShowHomepage:param withBlock:^(NSMutableArray *homepageArray,     NSError *error) {
        if (homepageArray && error == nil) {

            for (ATOMHomeImage *homeImage in homepageArray) {
                ATOMAskPageViewModel *model = [ATOMAskPageViewModel new];
                [model setViewModelData:homeImage];
                if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
                    [ws.dataSourceOfHotTableView addObject:model];
                } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageAskType) {
                    [ws.dataSourceOfRecentTableView addObject:model];
                }
            }
            if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
                [ws.scrollView.homepageHotTableView reloadData];
                [ws.scrollView.homepageHotTableView.footer endRefreshing];
                if (homepageArray.count == 0) {
                    ws.canRefreshHotFooter = NO;
                } else {
                    ws.canRefreshHotFooter = YES;
                }
            } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageAskType) {
                [ws.scrollView.homepageAskTableView reloadData];
                [ws.scrollView.homepageAskTableView.footer endRefreshing];
                if (homepageArray.count == 0) {
                    ws.canRefreshRecentFooter = NO;
                } else {
                    ws.canRefreshRecentFooter = YES;
                }
            }
        } else {
        }
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _thineNavigationView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _thineNavigationView.hidden = YES;
}

- (void)createUI {
    [self createCustomNavigationBar];
    _scrollView = [ATOMHomepageScrollView new];
    _scrollView.delegate =self;
    self.view = _scrollView;
    [self configHomepageHotTableView];
    [self confighomepageAskTableView];
    _isfirstEnterHomepageRecentView = YES;
    _canRefreshHotFooter = YES;
    _canRefreshRecentFooter = YES;
    [self firstGetDataSourceOfTableViewWithHomeType:ATOMHomepageHotType];
}

- (void)configHomepageHotTableView {
    _scrollView.homepageHotTableView.delegate = self;
    _scrollView.homepageHotTableView.dataSource = self;
    _scrollView.homepageHotTableView.psDelegate = self;
    _tapHomePageHotGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomePageHotGesture:)];
    [_scrollView.homepageHotTableView addGestureRecognizer:_tapHomePageHotGesture];
}
- (void)confighomepageAskTableView {
    _scrollView.homepageAskTableView.delegate = self;
    _scrollView.homepageAskTableView.dataSource = self;
    _scrollView.homepageAskTableView.psDelegate = self;

    _tapHomePageRecentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomePageRecentGesture:)];
    [_scrollView.homepageAskTableView addGestureRecognizer:_tapHomePageRecentGesture];
}

- (void)createCustomNavigationBar {
    _customTitleView = [ATOMHomepageCustomTitleView new];
    self.navigationItem.titleView = _customTitleView;
    
    [_customTitleView.hotTitleButton addTarget:self action:@selector(clickHotTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_customTitleView.recentTitleButton addTarget:self action:@selector(clickRecentTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;
    UIView *cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cameraButton setImage:[UIImage imageNamed:@"btn_psask_normal"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"btn_psask_pressed"] forState:UIControlStateHighlighted];
    [cameraButton setImageEdgeInsets:UIEdgeInsetsMake(5.5, 5, 5.5, 0)];
    [cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [cameraView addSubview:cameraButton];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraView];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightButtonItem];
    
    _thineNavigationView = [UIView new];
    _thineNavigationView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    _thineNavigationView.frame = CGRectMake(CGRectGetMinX(self.navigationItem.titleView.frame) + 10, 40, 60, 4);
    [self.navigationController.navigationBar addSubview:_thineNavigationView];
}

#pragma mark - Click Event

- (void)clickHotTitleButton:(UIButton *)sender {
    [self changeNavigationBarAccordingTo:@"hot"];
    [_scrollView changeUIAccording:@"热门"];
}

- (void)clickRecentTitleButton:(UIButton *)sender {
    [self changeNavigationBarAccordingTo:@"new"];
    [_scrollView changeUIAccording:@"最新"];
    if (_isfirstEnterHomepageRecentView) {
        _isfirstEnterHomepageRecentView = NO;
        [self firstGetDataSourceOfTableViewWithHomeType:ATOMHomepageAskType];
    }
}

- (void)clickCameraButton:(UIBarButtonItem *)sender {
    [[AppDelegate APP].window addSubview:self.cameraView];
}

- (void)dealSelectingPhotoFromAlbum {
    [[NSUserDefaults standardUserDefaults] setObject:@"SeekingHelp" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

/**
 *  上传作品
 *
 *  @param tag 0:->进行中  1:->选择相册图片
 */
- (void)dealUploadWorksWithTag:(NSInteger)tag {
    [[NSUserDefaults standardUserDefaults] setObject:@"Uploading" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (tag == 0) {
        ATOMProceedingViewController *pvc = [ATOMProceedingViewController new];
        [self pushViewController:pvc animated:YES];
    } else {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:_imagePickerController animated:YES completion:NULL];
    }
}

- (void)dealDownloadWork {
    UIImageWriteToSavedPhotosAlbum(_selectedAskCell.userWorkImageView.image
                                   ,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Util TextHud:@"保存失败"];
    }else{
        [Util TextHud:@"保存成功"];
    }
}

- (void)changeNavigationBarAccordingTo:(NSString *)type {
    if ([type isEqualToString:@"hot"]) {
        _thineNavigationView.frame = CGRectMake(CGRectGetMinX(self.navigationItem.titleView.frame) + 10, 40, 60, 4);
    } else if ([type isEqualToString:@"new"]) {
        _thineNavigationView.frame = CGRectMake(CGRectGetMinX(self.navigationItem.titleView.frame) + 130, 40, 60, 4);
    }
}

#pragma mark - Gesture Event

- (void)tapHomePageHotGesture:(UITapGestureRecognizer *)gesture {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
        CGPoint location = [gesture locationInView:_scrollView.homepageHotTableView];
        NSIndexPath *indexPath = [_scrollView.homepageHotTableView indexPathForRowAtPoint:location];
        if (indexPath) {
            _seletedIndexPath = indexPath;
            _selectedHotCell = (ATOMHomePageHotTableViewCell *)[_scrollView.homepageHotTableView cellForRowAtIndexPath:indexPath];
            CGPoint p = [gesture locationInView:_selectedHotCell];
            _selectedAskPageViewModel = _dataSourceOfHotTableView[indexPath.row];
            
            if (CGRectContainsPoint(_selectedHotCell.userWorkImageView.frame, p)) {
                //进入热门详情
                ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
                hdvc.delegate = self;
                hdvc.askPageViewModel = _dataSourceOfHotTableView[indexPath.row];
                [self pushViewController:hdvc animated:YES];
            } else if (CGRectContainsPoint(_selectedHotCell.topView.frame, p)) {
                p = [gesture locationInView:_selectedHotCell.topView];
                if (CGRectContainsPoint(_selectedHotCell.userHeaderButton.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedAskPageViewModel.userID;
                    opvc.userName = _selectedAskPageViewModel.userName;
                    [self pushViewController:opvc animated:YES];
                } else if (CGRectContainsPoint(_selectedHotCell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedAskPageViewModel.userID;
                    opvc.userName = _selectedAskPageViewModel.userName;
                    [self pushViewController:opvc animated:YES];
                }
            } else if (CGRectContainsPoint(_selectedHotCell.thinCenterView.frame, p)){
                p = [gesture locationInView:_selectedHotCell.thinCenterView];
                if (CGRectContainsPoint(_selectedHotCell.praiseButton.frame, p)) {
                    [_selectedHotCell.praiseButton toggleLike];
                    [_selectedAskPageViewModel toggleLike];
                } else if (CGRectContainsPoint(_selectedHotCell.shareButton.frame, p)) {
                    [self postSocialShare:_selectedAskPageViewModel.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
                } else if (CGRectContainsPoint(_selectedHotCell.commentButton.frame, p)) {
                    ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
                    rdvc.delegate = self;
                    PWPageDetailViewModel* pageDetailViewModel = [PWPageDetailViewModel new];
                    [pageDetailViewModel setCommonViewModelWithAsk:_selectedAskPageViewModel];
                    rdvc.pageDetailViewModel = pageDetailViewModel;
                    [self pushViewController:rdvc animated:YES];
//                    ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
//                    cdvc.ID = _selectedAskPageViewModel.imageID;
//                    cdvc.type = 1;
//                    [self pushViewController:cdvc animated:YES];
                } else if (CGRectContainsPoint(_selectedHotCell.moreShareButton.frame, p)) {
                    [[AppDelegate APP].window addSubview:self.shareFunctionView];
                    self.shareFunctionView.collectButton.selected = _selectedAskPageViewModel.collected;
                }
            }
        }
    }
}

- (void)tapHomePageRecentGesture:(UITapGestureRecognizer *)gesture {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageAskType) {
        CGPoint location = [gesture locationInView:_scrollView.homepageAskTableView];
        NSIndexPath *indexPath = [_scrollView.homepageAskTableView indexPathForRowAtPoint:location];
        if (indexPath) {
            _seletedIndexPath = indexPath;
            _selectedAskCell = (ATOMhomepageAskTableViewCell *)[_scrollView.homepageAskTableView cellForRowAtIndexPath:indexPath];
            CGPoint p = [gesture locationInView:_selectedAskCell];
            _selectedAskPageViewModel = _dataSourceOfRecentTableView[indexPath.row];
            if (CGRectContainsPoint(_selectedAskCell.userWorkImageView.frame, p)) {
                ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
                rdvc.delegate = self;
                PWPageDetailViewModel* pageDetailViewModel = [PWPageDetailViewModel new];
                [pageDetailViewModel setCommonViewModelWithAsk:_selectedAskPageViewModel];
                rdvc.pageDetailViewModel = pageDetailViewModel;
                [self pushViewController:rdvc animated:YES];
            } else if (CGRectContainsPoint(_selectedAskCell.topView.frame, p)) {
                p = [gesture locationInView:_selectedAskCell.topView];
                if (CGRectContainsPoint(_selectedAskCell.userHeaderButton.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedAskPageViewModel.userID;
                    opvc.userName = _selectedAskPageViewModel.userName;
                    [self pushViewController:opvc animated:YES];
                } else if (CGRectContainsPoint(_selectedAskCell.psButton.frame, p)) {
                    [[AppDelegate APP].window addSubview:self.psView];
                } else if (CGRectContainsPoint(_selectedAskCell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = _selectedAskPageViewModel.userID;
                    opvc.userName = _selectedAskPageViewModel.userName;
                    [self pushViewController:opvc animated:YES];
                }
            } else if (CGRectContainsPoint(_selectedAskCell.thinCenterView.frame, p)){
                p = [gesture locationInView:_selectedAskCell.thinCenterView];
                if (CGRectContainsPoint(_selectedAskCell.praiseButton.frame, p)) {
                    [_selectedAskCell.praiseButton toggleLike];
                    [_selectedAskPageViewModel toggleLike];
                } else if (CGRectContainsPoint(_selectedAskCell.shareButton.frame, p)) {
                    [self postSocialShare:_selectedAskPageViewModel.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
                } else if (CGRectContainsPoint(_selectedAskCell.commentButton.frame, p)) {
                    ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
                    rdvc.delegate = self;
                    PWPageDetailViewModel* pageDetailViewModel = [PWPageDetailViewModel new];
                    [pageDetailViewModel setCommonViewModelWithAsk:_selectedAskPageViewModel];
                    rdvc.pageDetailViewModel = pageDetailViewModel;
                    [self pushViewController:rdvc animated:YES];
                } else if (CGRectContainsPoint(_selectedAskCell.moreShareButton.frame, p)) {
                    self.shareFunctionView.collectButton.selected = _selectedAskPageViewModel.collected;
                    [[AppDelegate APP].window addSubview:self.shareFunctionView];

                }
            }
            
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        ATOMUploadWorkViewController *uwvc = [ATOMUploadWorkViewController new];
        uwvc.originImage = info[UIImagePickerControllerOriginalImage];
        uwvc.askPageViewModel = ws.selectedAskPageViewModel;
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int currentPage = (_scrollView.contentOffset.x + CGWidth(_scrollView.frame) * 0.1) / CGWidth(_scrollView.frame);
        if (currentPage == 0) {
            [self changeNavigationBarAccordingTo:@"hot"];
            [_scrollView changeUIAccording:@"热门"];
        } else if (currentPage == 1) {
            [self changeNavigationBarAccordingTo:@"new"];
            [_scrollView changeUIAccording:@"最新"];
            if (_isfirstEnterHomepageRecentView) {
                _isfirstEnterHomepageRecentView = NO;
                [self firstGetDataSourceOfTableViewWithHomeType:ATOMHomepageAskType];
            }
        }
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_scrollView.homepageHotTableView == tableView) {
        return _dataSourceOfHotTableView.count;
    } else if (_scrollView.homepageAskTableView == tableView) {
        return _dataSourceOfRecentTableView.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_scrollView.homepageHotTableView == tableView) {
        static NSString *CellIdentifier1 = @"HomePageHotCell";
        ATOMHomePageHotTableViewCell *cell = [_scrollView.homepageHotTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell) {
            cell = [[ATOMHomePageHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        cell.viewModel = _dataSourceOfHotTableView[indexPath.row];
        return cell;
    } else if (_scrollView.homepageAskTableView == tableView) {
        static NSString *CellIdentifier2 = @"HomePageRecentCell";
        ATOMhomepageAskTableViewCell *cell = [_scrollView.homepageAskTableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (!cell) {
            cell = [[ATOMhomepageAskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        cell.viewModel = _dataSourceOfRecentTableView[indexPath.row];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_scrollView.homepageHotTableView == tableView) {
        return [ATOMHomePageHotTableViewCell calculateCellHeightWith:_dataSourceOfHotTableView[indexPath.row]];
    } else if (_scrollView.homepageAskTableView == tableView) {
        return [ATOMhomepageAskTableViewCell calculateCellHeightWith:_dataSourceOfRecentTableView[indexPath.row]];
    } else {
        return 0;
    }
}

#pragma mark - ATOMPSViewDelegate

- (void)dealImageWithCommand:(NSString *)command {
    if ([command isEqualToString:@"upload"]) {
        [self dealUploadWorksWithTag:1];
    } else if ([command isEqualToString:@"download"]) {
        [self dealDownloadWork];
    }
}

#pragma mark - ATOMCameraViewDelegate

- (void)dealWithCommand:(NSString *)command {
//    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"求助上传", @"作品上传"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//        NSString * tapTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
//        if ([tapTitle isEqualToString:@"求助上传"]) {
//            [self dealSelectingPhotoFromAlbum];
//        } else if ([tapTitle isEqualToString:@"作品上传"]) {
//            [self dealUploadWorksWithTag:0];
//        }
//    }];
    if ([command isEqualToString:@"help"]) {
        [self dealSelectingPhotoFromAlbum];
    } else if ([command isEqualToString:@"work"]) {
        [self dealUploadWorksWithTag:0];
    }
}

#pragma mark - ATOMViewControllerDelegate
-(void)ATOMViewControllerDismissWithLiked:(BOOL)liked {
    if (_scrollView.typeOfCurrentHomepageView == ATOMHomepageHotType) {
        //当从child viewcontroller 传来的liked变化的时候，toggle like.
        //to do:其实应该改变datasource的liked ,tableView reload的时候才能保持。
        [_selectedHotCell.praiseButton toggleLikeWhenSelectedChanged:liked];
    } else if (_scrollView.typeOfCurrentHomepageView == ATOMHomepageAskType) {
        [_selectedAskCell.praiseButton toggleLikeWhenSelectedChanged:liked];
    }
}

-(void)ATOMViewControllerDismissWithInfo:(NSDictionary *)info {
    NSLog(@"ATOMViewControllerDismissWithInfo");
    bool liked = [info[@"liked"] boolValue];
    bool collected = [info[@"collected"]boolValue];

    NSLog(@"ATOMViewControllerDismissWithInfo collected %d",collected);
    if (_scrollView.typeOfCurrentHomepageView == ATOMHomepageHotType) {
        //当从child viewcontroller 传来的liked变化的时候，toggle like.
        //to do:其实应该改变datasource的liked ,tableView reload的时候才能保持。
        [_selectedHotCell.praiseButton toggleLikeWhenSelectedChanged:liked];
        _selectedAskPageViewModel.collected = collected;
        NSLog(@"_selectedAskPageViewModel.collected %d",collected);

    } else if (_scrollView.typeOfCurrentHomepageView == ATOMHomepageAskType) {
        [_selectedAskCell.praiseButton toggleLikeWhenSelectedChanged:liked];
        _selectedAskPageViewModel.collected = collected;
    }
}

@end
