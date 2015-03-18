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
#import "ATOMUploadWorkViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMProceedingViewController.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMHomepageCustomTitleView.h"
#import "ATOMHomepageScrollView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMHomepageViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ATOMHomepageCustomTitleView *customTitleView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapHomePageHotGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapHomePageRecentGesture;
@property (nonatomic, strong) NSMutableArray *dataSourceOfHotTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceOfRecentTableView;
@property (nonatomic, strong) ATOMHomepageScrollView *scrollView;

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

#pragma mark - Refresh

- (void)configHomepageHotTableViewRefresh {
    WS(ws);
    [_scrollView.homepageHotTableView addLegendHeaderWithRefreshingBlock:^{
        [ws loadNewHotData];
    }];
    [_scrollView.homepageHotTableView addLegendFooterWithRefreshingBlock:^{
        [ws loadMoreHotData];
    }];
}

- (void)loadNewHotData {
    WS(ws);
    [ws.scrollView.homepageHotTableView.header endRefreshing];
}

- (void)loadMoreHotData {
    WS(ws);
    [ws.scrollView.homepageHotTableView.footer endRefreshing];
}

- (void)configHomepageRecentTableViewRefresh {
    WS(ws);
    [_scrollView.homepageRecentTableView addLegendHeaderWithRefreshingBlock:^{
        [ws loadNewRecentData];
    }];
    [_scrollView.homepageRecentTableView addLegendFooterWithRefreshingBlock:^{
        [ws loadMoreRecentData];
    }];
}

- (void)loadNewRecentData {
    WS(ws);
    [ws.scrollView.homepageRecentTableView.header endRefreshing];
}

- (void)loadMoreRecentData {
    WS(ws);
    [ws.scrollView.homepageRecentTableView.footer endRefreshing];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _dataSourceOfHotTableView = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage *img = [UIImage imageNamed:imgName];
        ATOMHomePageViewModel *viewModel = [ATOMHomePageViewModel new];
        viewModel.userImage = img;
        [_dataSourceOfHotTableView addObject:viewModel];
    }
    _dataSourceOfRecentTableView = [NSMutableArray array];
    for (int i = 11; i >= 0; i--) {
        NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage *img = [UIImage imageNamed:imgName];
        ATOMHomePageViewModel *viewModel = [ATOMHomePageViewModel new];
        viewModel.userImage = img;
        [_dataSourceOfRecentTableView addObject:viewModel];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
}

#pragma mark - Click Event

- (void)clickHotTitleButton:(UIButton *)sender {
    sender.selected = YES;
    _customTitleView.recentTitleButton.selected = NO;
    [_scrollView changeUIAccording:@"热门"];
}

- (void)clickRecentTitleButton:(UIButton *)sender {
    sender.selected = YES;
    _customTitleView.hotTitleButton.selected = NO;
    [_scrollView changeUIAccording:@"最新"];
}

- (void)clickCameraButton:(UIBarButtonItem *)sender {
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照", @"从手机相册选择", @"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString * tapTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([tapTitle isEqualToString:@"拍照"]) {
            [self dealTakingPhoto];
        } else if ([tapTitle isEqualToString:@"从手机相册选择"]) {
            [self dealSelectingPhotoFromAlbum];
        } else if ([tapTitle isEqualToString:@"上传作品"]) {
            [self dealUploadWorks];
        }
    }];
}

- (void)dealTakingPhoto {
    [[NSUserDefaults standardUserDefaults] setObject:@"SeekingHelp" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIImagePickerControllerSourceType currentType = UIImagePickerControllerSourceTypeCamera;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:currentType];
    if (ok) {
        self.imagePickerController.sourceType = currentType;
        [self presentViewController:_imagePickerController animated:YES completion:NULL];
    } else {
        
    }
}


- (void)dealSelectingPhotoFromAlbum {
    [[NSUserDefaults standardUserDefaults] setObject:@"SeekingHelp" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

- (void)dealUploadWorks {
    [[NSUserDefaults standardUserDefaults] setObject:@"Uploading" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ATOMProceedingViewController *pvc = [ATOMProceedingViewController new];
    [self pushViewController:pvc animated:YES];
}

- (void)dealDownloadWork {
    
}

#pragma mark - Gesture Event

- (void)tapHomePageHotGesture:(UITapGestureRecognizer *)gesture {
    if ([_scrollView typeOfCurrentHomepageView] == ATOMHomepageHotType) {
        CGPoint location = [gesture locationInView:_scrollView.homepageHotTableView];
        NSIndexPath *indexPath = [_scrollView.homepageHotTableView indexPathForRowAtPoint:location];
        if (indexPath) {
            ATOMHomePageHotTableViewCell *cell = (ATOMHomePageHotTableViewCell *)[_scrollView.homepageHotTableView cellForRowAtIndexPath:indexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint([ATOMHomePageHotTableViewCell calculateHomePageHotImageViewRectWith:_dataSourceOfHotTableView[indexPath.row]], p)) {
                ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
                [self pushViewController:hdvc animated:YES];
            } else if (CGRectContainsPoint(cell.topView.frame, p)) {
                p = [gesture locationInView:cell.topView];
                if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    [self pushViewController:opvc animated:YES];
                } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    [self pushViewController:opvc animated:YES];
                }
            } else {
                p = [gesture locationInView:cell.thinCenterView];
                if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
                    cell.praiseButton.selected = !cell.praiseButton.selected;
                } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
                    
                } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
                    ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
                    [self pushViewController:cdvc animated:YES];
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
            if (CGRectContainsPoint([ATOMHomePageRecentTableViewCell calculateHomePageHotImageViewRectWith:_dataSourceOfRecentTableView[indexPath.row]], p)) {
                ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
                [self pushViewController:hdvc animated:YES];
            } else if (CGRectContainsPoint(cell.topView.frame, p)) {
                p = [gesture locationInView:cell.topView];
                if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    [self pushViewController:opvc animated:YES];
                } else if (CGRectContainsPoint(cell.psButton.frame, p)) {
                    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"下载素材", @"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                        NSString * tapTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
                        if ([tapTitle isEqualToString:@"下载素材"]) {
                            [self dealDownloadWork];
                        } else if ([tapTitle isEqualToString:@"上传作品"]) {
                            [self dealUploadWorks];
                        }
                    }];
                } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    [self pushViewController:opvc animated:YES];
                }
            } else {
                p = [gesture locationInView:cell.thinCenterView];
                if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
                    cell.praiseButton.selected = !cell.praiseButton.selected;
                } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
                    NSLog(@"Click shareButton");
                } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
                    ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
                    [self pushViewController:cdvc animated:YES];
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
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int currentPage = (_scrollView.contentOffset.x + CGWidth(_scrollView.frame) * 0.5) / CGWidth(_scrollView.frame);
        if (currentPage == 0) {
            _customTitleView.hotTitleButton.selected = YES;
            _customTitleView.recentTitleButton.selected = NO;
            [_scrollView changeUIAccording:@"热门"];
        } else if (currentPage == 1) {
            _customTitleView.hotTitleButton.selected = NO;
            _customTitleView.recentTitleButton.selected = YES;
            [_scrollView changeUIAccording:@"最新"];
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


























@end
