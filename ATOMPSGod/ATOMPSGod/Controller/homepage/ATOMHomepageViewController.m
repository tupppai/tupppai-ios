//
//  ATOMHomepageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomepageViewController.h"
#import "ATOMHomePageHotTableViewCell.h"
#import "ATOMHomePageRecentTableViewCell.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMRecentDetailViewController.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMProceedingViewController.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMHomepageCustomTitleView.h"
#import "ATOMHomepageScrollView.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMShowHomepage.h"
#import "ATOMShareFunctionView.h"
#import "ATOMPSView.h"
#import "AppDelegate.h"
#import "ATOMBottomCommonButton.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMHomepageViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, ATOMPSViewDelegate>

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
@property (nonatomic, strong) ATOMHomePageViewModel *selectedHomePageViewModel;
@property (nonatomic, strong) UIView *thineNavigationView;

@end

@implementation ATOMHomepageViewController

#pragma mark - Lazy Initialize

- (ATOMHomepageScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [ATOMHomepageScrollView new];
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
        [_shareFunctionView.wxButton addTarget:self action:@selector(clickWXButton:) forControlEvents:UIControlEventTouchUpInside];
        [_shareFunctionView.wxFriendCircleButton addTarget:self action:@selector(clickWXFriendCircleButton:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Refresh

- (void)configHomepageHotTableViewRefresh {
    [_scrollView.homepageHotTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewHotData)];
    [_scrollView.homepageHotTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
}

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

- (void)configHomepageRecentTableViewRefresh {
    [_scrollView.homepageRecentTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewRecentData)];
    [_scrollView.homepageRecentTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecentData)];
}

- (void)loadNewRecentData {
    [self getDataSourceOfTableViewWithHomeType:@"new"];
}

- (void)loadMoreRecentData {
    if (_canRefreshRecentFooter) {
       [self getMoreDataSourceOfTableViewWithHomeType:@"new"];
    } else {
        [_scrollView.homepageRecentTableView.footer endRefreshing];
    }
    
}

#pragma mark - GetDataSource

- (void)firstGetDataSourceOfTableViewWithHomeType:(NSString *)homeType {
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    NSArray * homepageArray = [[showHomepage getHomeImages] mutableCopy];
    if ([homeType isEqualToString:@"hot"]) {
        if (!homepageArray || homepageArray.count == 0) { //读服务器
            [self loadNewHotData];
        } else { //读数据库
            _dataSourceOfHotTableView = nil;
            _dataSourceOfHotTableView = [NSMutableArray array];
            for (ATOMHomeImage *homeImage in homepageArray) {
                ATOMHomePageViewModel *model = [ATOMHomePageViewModel new];
                [model setViewModelData:homeImage];
                [_dataSourceOfHotTableView addObject:model];
            }
            [_scrollView.homepageHotTableView reloadData];
        }
    } else if ([homeType isEqualToString:@"new"]) {
        if (!homepageArray || homepageArray.count == 0) {
            [self loadNewRecentData];
        } else {
            _dataSourceOfRecentTableView = nil;
            _dataSourceOfRecentTableView = [NSMutableArray array];
            for (ATOMHomeImage *homeImage in homepageArray) {
                ATOMHomePageViewModel *model = [ATOMHomePageViewModel new];
                [model setViewModelData:homeImage];
                [_dataSourceOfRecentTableView addObject:model];
            }
            [_scrollView.homepageRecentTableView reloadData];
        }
    }
}

- (void)getDataSourceOfTableViewWithHomeType:(NSString *)homeType {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary new];
    double timeStamp = [[NSDate date] timeIntervalSince1970];
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
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:homeType forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowHomepage *showHomepage = [ATOMShowHomepage new];
    [showHomepage clearHomeImages];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [showHomepage ShowHomepage:param withBlock:^(NSMutableArray *homepageArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMHomeImage *homeImage in homepageArray) {
            ATOMHomePageViewModel *model = [ATOMHomePageViewModel new];
            [model setViewModelData:homeImage];
            if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
                [ws.dataSourceOfHotTableView addObject:model];
            } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageRecentType) {
                [ws.dataSourceOfRecentTableView addObject:model];
            }
        }
        [showHomepage saveHomeImagesInDB:homepageArray];
        if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
            [ws.scrollView.homepageHotTableView reloadData];
            [ws.scrollView.homepageHotTableView.header endRefreshing];
        } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageRecentType) {
            [ws.scrollView.homepageRecentTableView reloadData];
            [ws.scrollView.homepageRecentTableView.header endRefreshing];
        }
    }];
}

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
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [showHomepage ShowHomepage:param withBlock:^(NSMutableArray *homepageArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMHomeImage *homeImage in homepageArray) {
            ATOMHomePageViewModel *model = [ATOMHomePageViewModel new];
            [model setViewModelData:homeImage];
            if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
                [ws.dataSourceOfHotTableView addObject:model];
            } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageRecentType) {
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
        } else if ([ws.scrollView typeOfCurrentHomepageView] == ATOMHomepageRecentType) {
            [ws.scrollView.homepageRecentTableView reloadData];
            [ws.scrollView.homepageRecentTableView.footer endRefreshing];
            if (homepageArray.count == 0) {
                ws.canRefreshRecentFooter = NO;
            } else {
                ws.canRefreshRecentFooter = YES;
            }
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
    [self configHomepageRecentTableView];
    [_scrollView changeUIAccording:@"热门"];
    _customTitleView.hotTitleButton.selected = YES;
    _isfirstEnterHomepageRecentView = YES;
    _canRefreshHotFooter = YES;
    _canRefreshRecentFooter = YES;
    [self firstGetDataSourceOfTableViewWithHomeType:@"hot"];
}

- (void)configHomepageHotTableView {
    _scrollView.homepageHotTableView.delegate = self;
    _scrollView.homepageHotTableView.dataSource = self;
    _tapHomePageHotGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomePageHotGesture:)];
    [_scrollView.homepageHotTableView addGestureRecognizer:_tapHomePageHotGesture];
    [self configHomepageHotTableViewRefresh];
}

- (void)configHomepageRecentTableView {
    _scrollView.homepageRecentTableView.delegate = self;
    _scrollView.homepageRecentTableView.dataSource = self;
    _tapHomePageRecentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomePageRecentGesture:)];
    [_scrollView.homepageRecentTableView addGestureRecognizer:_tapHomePageRecentGesture];
    [self configHomepageRecentTableViewRefresh];
}

- (void)createCustomNavigationBar {
    _customTitleView = [ATOMHomepageCustomTitleView new];
    self.navigationItem.titleView = _customTitleView;
    
    [_customTitleView.hotTitleButton addTarget:self action:@selector(clickHotTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_customTitleView.recentTitleButton addTarget:self action:@selector(clickRecentTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;
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
    _thineNavigationView.frame = CGRectMake(CGRectGetMinX(self.navigationItem.titleView.frame) + 20, 40, 50, 4);
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
        [self firstGetDataSourceOfTableViewWithHomeType:@"new"];
    }
}

- (void)clickCameraButton:(UIBarButtonItem *)sender {
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"求助上传", @"作品上传"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString * tapTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([tapTitle isEqualToString:@"求助上传"]) {
            [self dealSelectingPhotoFromAlbum];
        } else if ([tapTitle isEqualToString:@"作品上传"]) {
            [self dealUploadWorksWithTag:0];
        }
    }];
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
    
}

- (void)clickWXButton:(UIButton *)sender {
    [self wxFriendShare];
}

- (void)clickWXFriendCircleButton:(UIButton *)sender {
    [self wxShare];
}

- (void)changeNavigationBarAccordingTo:(NSString *)type {
    if ([type isEqualToString:@"hot"]) {
        _thineNavigationView.frame = CGRectMake(CGRectGetMinX(self.navigationItem.titleView.frame) + 20, 40, 50, 4);
    } else if ([type isEqualToString:@"new"]) {
        _thineNavigationView.frame = CGRectMake(CGRectGetMinX(self.navigationItem.titleView.frame) + 130, 40, 50, 4);
    }
}

#pragma mark - Gesture Event

- (void)tapHomePageHotGesture:(UITapGestureRecognizer *)gesture {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
        CGPoint location = [gesture locationInView:_scrollView.homepageHotTableView];
        NSIndexPath *indexPath = [_scrollView.homepageHotTableView indexPathForRowAtPoint:location];
        if (indexPath) {
            ATOMHomePageHotTableViewCell *cell = (ATOMHomePageHotTableViewCell *)[_scrollView.homepageHotTableView cellForRowAtIndexPath:indexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.userWorkImageView.frame, p)) {
                //进入热门详情
                ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
                hdvc.homePageViewModel = _dataSourceOfHotTableView[indexPath.row];
                [self pushViewController:hdvc animated:YES];
            } else if (CGRectContainsPoint(cell.topView.frame, p)) {
                p = [gesture locationInView:cell.topView];
                if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    ATOMHomePageViewModel *model = _dataSourceOfHotTableView[indexPath.row];
                    opvc.userID = model.userID;
                    opvc.userName = model.userName;
                    [self pushViewController:opvc animated:YES];
                } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    ATOMHomePageViewModel *model = _dataSourceOfHotTableView[indexPath.row];
                    opvc.userID = model.userID;
                    opvc.userName = model.userName;
                    [self pushViewController:opvc animated:YES];
                }
            } else if (CGRectContainsPoint(cell.thinCenterView.frame, p)){
                p = [gesture locationInView:cell.thinCenterView];
                if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
                    cell.praiseButton.selected = !cell.praiseButton.selected;
                } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
                    [self wxShare];
                } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
                    ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
                    ATOMHomePageViewModel *model = _dataSourceOfHotTableView[indexPath.row];
                    cdvc.ID = model.imageID;
                    cdvc.type = 1;
                    [self pushViewController:cdvc animated:YES];
                } else if (CGRectContainsPoint(cell.moreShareButton.frame, p)) {
                    [[AppDelegate APP].window addSubview:self.shareFunctionView];
                }
            }
        }
    }
}

- (void)tapHomePageRecentGesture:(UITapGestureRecognizer *)gesture {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageRecentType) {
        CGPoint location = [gesture locationInView:_scrollView.homepageRecentTableView];
        NSIndexPath *indexPath = [_scrollView.homepageRecentTableView indexPathForRowAtPoint:location];
        if (indexPath) {
            ATOMHomePageRecentTableViewCell *cell = (ATOMHomePageRecentTableViewCell *)[_scrollView.homepageRecentTableView cellForRowAtIndexPath:indexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.userWorkImageView.frame, p)) {
                //进入最新详情
                ATOMRecentDetailViewController *rdvc = [ATOMRecentDetailViewController new];
                rdvc.homePageViewModel = _dataSourceOfRecentTableView[indexPath.row];
                [self pushViewController:rdvc animated:YES];
            } else if (CGRectContainsPoint(cell.topView.frame, p)) {
                p = [gesture locationInView:cell.topView];
                if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    ATOMHomePageViewModel *model = _dataSourceOfRecentTableView[indexPath.row];
                    opvc.userID = model.userID;
                    opvc.userName = model.userName;
                    [self pushViewController:opvc animated:YES];
                } else if (CGRectContainsPoint(cell.psButton.frame, p)) {
                    [[AppDelegate APP].window addSubview:self.psView];
                } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    ATOMHomePageViewModel *model = _dataSourceOfHotTableView[indexPath.row];
                    opvc.userID = model.userID;
                    opvc.userName = model.userName;
                    [self pushViewController:opvc animated:YES];
                }
            } else if (CGRectContainsPoint(cell.thinCenterView.frame, p)){
                p = [gesture locationInView:cell.thinCenterView];
                if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
                    cell.praiseButton.selected = !cell.praiseButton.selected;
                } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
                    [self wxShare];
                } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
                    ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
                    ATOMHomePageViewModel *model = _dataSourceOfHotTableView[indexPath.row];
                    cdvc.ID = model.imageID;
                    cdvc.type = 1;
                    [self pushViewController:cdvc animated:YES];
                } else if (CGRectContainsPoint(cell.moreShareButton.frame, p)) {
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
        uwvc.homePageViewModel = ws.selectedHomePageViewModel;
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int currentPage = (_scrollView.contentOffset.x + CGWidth(_scrollView.frame) * 0.5) / CGWidth(_scrollView.frame);
        if (currentPage == 0) {
            [self changeNavigationBarAccordingTo:@"hot"];
            [_scrollView changeUIAccording:@"热门"];
        } else if (currentPage == 1) {
            [self changeNavigationBarAccordingTo:@"new"];
            [_scrollView changeUIAccording:@"最新"];
            if (_isfirstEnterHomepageRecentView) {
                _isfirstEnterHomepageRecentView = NO;
                [self firstGetDataSourceOfTableViewWithHomeType:@"new"];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
        return _dataSourceOfHotTableView.count;
    } else if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageRecentType) {
        return _dataSourceOfRecentTableView.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
        static NSString *CellIdentifier1 = @"HomePageHotCell";
        ATOMHomePageHotTableViewCell *cell = [_scrollView.homepageHotTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell) {
            cell = [[ATOMHomePageHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        cell.viewModel = _dataSourceOfHotTableView[indexPath.row];
        return cell;
    } else if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageRecentType) {
        static NSString *CellIdentifier2 = @"HomePageRecentCell";
        ATOMHomePageRecentTableViewCell *cell = [_scrollView.homepageRecentTableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (!cell) {
            cell = [[ATOMHomePageRecentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        NSLog(@"recent row = %d and recentarraycount = %d", (int)indexPath.row, (int)_dataSourceOfRecentTableView.count);
        cell.viewModel = _dataSourceOfRecentTableView[indexPath.row];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
        return [ATOMHomePageHotTableViewCell calculateCellHeightWith:_dataSourceOfHotTableView[indexPath.row]];
    } else if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageRecentType) {
        return [ATOMHomePageRecentTableViewCell calculateCellHeightWith:_dataSourceOfRecentTableView[indexPath.row]];
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























@end
