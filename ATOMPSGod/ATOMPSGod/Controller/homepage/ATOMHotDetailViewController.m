//
//  ATOMHotDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AppDelegate.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMHotDetailTableViewCell.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMProceedingViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMDetailImageViewModel.h"
#import "ATOMCommentViewModel.h"
#import "ATOMDetailImage.h"
#import "ATOMComment.h"
#import "ATOMShowDetailOfHomePage.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMShareFunctionView.h"
#import "ATOMBottomCommonButton.h"
#import "PWRefreshBaseTableView.h"
#import "ATOMAskDetailViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMHotDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,PWRefreshBaseTableViewDelegate>

@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong) UIView *hotDetailView;
@property (nonatomic, strong) PWRefreshBaseTableView *hotDetailTableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapHotDetailGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation ATOMHotDetailViewController

#pragma mark - Lazy Initialize

- (ATOMShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [ATOMShareFunctionView new];
        [_shareFunctionView.wxButton addTarget:self action:@selector(clickWXButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareFunctionView;
}

- (UITableView *)hotDetailTableView {
    if (_hotDetailTableView == nil) {
        _hotDetailTableView = [[PWRefreshBaseTableView alloc] initWithFrame:_hotDetailView.bounds];
        _hotDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _hotDetailTableView.psDelegate = self;
        _hotDetailTableView.delegate = self;
        _hotDetailTableView.dataSource = self;
        _tapHotDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHotDetailGesture:)];
        [_hotDetailTableView addGestureRecognizer:_tapHotDetailGesture];
        [self configHotDetailTableViewRefresh];
    }
    return _hotDetailTableView;
}

- (UIView *)hotDetailView {
    if (_hotDetailView == nil) {
        _hotDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        [_hotDetailView addSubview:self.hotDetailTableView];
    }
    return _hotDetailView;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark Refresh

- (void)configHotDetailTableViewRefresh {
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ddot", i]];
        [animatedImages addObject:image];
    }
    [_hotDetailTableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
    _hotDetailTableView.gifFooter.refreshingImages = animatedImages;
    _hotDetailTableView.footer.stateHidden = YES;
    
}

- (void)loadMoreHotData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_hotDetailTableView.footer endRefreshing];
    }
}

#pragma mark - GetDataSource

- (void)firstGetDataSource {
    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
    NSArray *detailImageArray = [showDetailOfHomePage getDetalImagesByImageID:_homePageViewModel.imageID];
    if (!detailImageArray || detailImageArray.count == 0) { //读服务器
        [self getDataSource];
    } else { //读数据库
        _dataSource = nil;
        _dataSource = [NSMutableArray array];
        //第一张图片为首页点击的图片，剩下的图片为回复图片
        ATOMDetailImageViewModel *model = [ATOMDetailImageViewModel new];
        [model setViewModelDataWithHomeImage:_homePageViewModel];
        [_dataSource addObject:model];
        for (ATOMDetailImage *detailImage in detailImageArray) {
            ATOMDetailImageViewModel *model = [ATOMDetailImageViewModel new];
            [model setViewModelDataWithDetailImage:detailImage];
            model.labelArray = [_homePageViewModel.labelArray mutableCopy];
            [_dataSource addObject:model];
        }
        [_hotDetailTableView reloadData];
    }
}

- (void)getDataSource {
    WS(ws);
    ws.currentPage = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(5) forKey:@"size"];
    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
    NSLog(@"%d", (int)ws.homePageViewModel.imageID);
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.homePageViewModel.imageID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
        //第一张图片为首页点击的图片，剩下的图片为回复图片
        ws.dataSource = nil;
        ws.dataSource = [NSMutableArray array];
        ATOMDetailImageViewModel *model = [ATOMDetailImageViewModel new];
        [model setViewModelDataWithHomeImage:ws.homePageViewModel];
        [ws.dataSource addObject:model];
        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
            ATOMDetailImageViewModel *model = [ATOMDetailImageViewModel new];
            [model setViewModelDataWithDetailImage:detailImage];
            model.labelArray = [ws.homePageViewModel.labelArray mutableCopy];
            [ws.dataSource addObject:model];
        }
        if (detailOfHomePageArray.count == 0) {
            _canRefreshFooter = NO;
        }
        [showDetailOfHomePage saveDetailImagesInDB:detailOfHomePageArray];
        [ws.hotDetailTableView reloadData];
        [ws.hotDetailTableView.header endRefreshing];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    ws.currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.homePageViewModel.imageID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
            ATOMDetailImageViewModel *model = [ATOMDetailImageViewModel new];
            [model setViewModelDataWithDetailImage:detailImage];
            model.labelArray = [ws.homePageViewModel.labelArray mutableCopy];
            [ws.dataSource addObject:model];
        }
        if (detailOfHomePageArray.count == 0) {
            _canRefreshFooter = NO;
        } else {
            _canRefreshFooter = YES;
        }
        [ws.hotDetailTableView reloadData];
        [ws.hotDetailTableView.footer endRefreshing];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self firstGetDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)createUI {
    self.title = @"详情";
    self.view = self.hotDetailView;
    _canRefreshFooter = YES;
}

#pragma mark - Click Event

- (void)dealDownloadWork {
    
}

- (void)dealUploadWork {
    [[NSUserDefaults standardUserDefaults] setObject:@"Uploading" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

- (void)clickWXButton:(UIButton *)sender {
    [self wxFriendShare];
}

#pragma mark - Gesture Event

- (void)tapHotDetailGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_hotDetailTableView];
    NSIndexPath *indexPath = [_hotDetailTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMDetailImageViewModel *model = _dataSource[indexPath.row];
        ATOMHotDetailTableViewCell *cell = (ATOMHotDetailTableViewCell *)[_hotDetailTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.userWorkImageView.frame, p)) {
            ATOMAskDetailViewController *rdvc = [ATOMAskDetailViewController new];
            if (indexPath.row != 0) {
                NSLog(@"rdvc.detailImageViewModel");
                rdvc.detailImageViewModel = _dataSource[indexPath.row];
            } else {
                rdvc.homePageViewModel = _homePageViewModel;
            }
            
            [self pushViewController:rdvc animated:YES];
        } else if (CGRectContainsPoint(cell.topView.frame, p)) {
            p = [gesture locationInView:cell.topView];
            if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = model.uid;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            } else if (CGRectContainsPoint(cell.psButton.frame, p)) {
                [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"下载素材",@"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                    NSString *actionSheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
                    if ([actionSheetTitle isEqualToString:@"下载素材"]) {
                        [self dealDownloadWork];
                    } else if ([actionSheetTitle isEqualToString:@"上传作品"]) {
                        [self dealUploadWork];
                    }
                }];
            } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = model.uid;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            }
        } else {
            p = [gesture locationInView:cell.thinCenterView];
            if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
                [cell.praiseButton toggleApperance];
                if (indexPath.row != 0 ) {
                    [model toggleLike];
                } else {
                    [_homePageViewModel toggleLike];
                }
            } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
                [self wxShare];
            } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
                ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
                cdvc.ID = model.ID;
                cdvc.type = (indexPath.row == 0) ? 1 : 2;
                [self pushViewController:cdvc animated:YES];
            } else if (CGRectContainsPoint(cell.moreShareButton.frame, p)) {
                [[AppDelegate APP].window addSubview:self.shareFunctionView];
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
        uwvc.homePageViewModel = ws.homePageViewModel;
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HotDetailCell";
    ATOMHotDetailTableViewCell *cell = [_hotDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMHotDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMHotDetailTableViewCell calculateCellHeightWith:_dataSource[indexPath.row]];
}


-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    [self getMoreDataSource];
}

@end
