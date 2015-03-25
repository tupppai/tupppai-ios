//
//  ATOMRecentDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMRecentDetailViewController.h"
#import "ATOMRecentDetailView.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMRecentDetailTableViewCell.h"
#import "ATOMMyConcernTableHeaderView.h"
#import "ATOMRecentDetailHeaderView.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMCommentDetailViewController.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMRecentDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ATOMRecentDetailView *recentDetailView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITapGestureRecognizer *tapUserNameLabelGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentDetailGesture;

@end

@implementation ATOMRecentDetailViewController

#pragma mark - Lazy Initialize

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark Refresh

- (void)configRecentDetailTableViewRefresh {
    WS(ws);
    [_recentDetailView.recentDetailTableView addLegendFooterWithRefreshingBlock:^{
        [ws loadMoreData];
    }];
}

- (void)loadMoreData {
    WS(ws);
    [ws getMoreDataSource];
}

#pragma mark - GetDataSource

- (void)getDataSource {
//    WS(ws);
//    ws.dataSource = nil;
//    ws.dataSource = [NSMutableArray array];
//    ws.currentPage = 1;
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
//    [param setObject:@(ws.currentPage) forKey:@"page"];
//    [param setObject:@(10) forKey:@"size"];
//    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    NSLog(@"%d", (int)ws.homePageViewModel.imageID);
//    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.homePageViewModel.imageID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
//        [SVProgressHUD dismiss];
//        //第一张图片为首页点击的图片，剩下的图片为回复图片
//        ATOMDetailImageViewModel *model = [ATOMDetailImageViewModel new];
//        [model setViewModelDataWithHomeImage:ws.homePageViewModel];
//        [ws.dataSource addObject:model];
//        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
//            ATOMDetailImageViewModel *model = [ATOMDetailImageViewModel new];
//            [model setViewModelDataWithDetailImage:detailImage];
//            model.labelArray = [ws.homePageViewModel.labelArray mutableCopy];
//            [ws.dataSource addObject:model];
//        }
//        [ws.hotDetailTableView reloadData];
//        [ws.hotDetailTableView.header endRefreshing];
//    }];
}

- (void)getMoreDataSource {
//    WS(ws);
//    ws.currentPage++;
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
//    [param setObject:@(ws.currentPage) forKey:@"page"];
//    [param setObject:@(10) forKey:@"size"];
//    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.homePageViewModel.imageID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
//        [SVProgressHUD dismiss];
//        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
//            ATOMDetailImageViewModel *model = [ATOMDetailImageViewModel new];
//            [model setViewModelDataWithDetailImage:detailImage];
//            model.labelArray = [ws.homePageViewModel.labelArray mutableCopy];
//            [ws.dataSource addObject:model];
//        }
//        [ws.hotDetailTableView reloadData];
//        [ws.hotDetailTableView.footer endRefreshing];
//    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
//    [self getDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
        [_dataSource addObject:model];
    }
    [_recentDetailView.recentDetailTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)createUI {
    self.title = @"详情";
    _recentDetailView = [ATOMRecentDetailView new];
    self.view = _recentDetailView;
    _recentDetailView.viewModel = _homePageViewModel;
    _recentDetailView.recentDetailTableView.delegate = self;
    _recentDetailView.recentDetailTableView.dataSource = self;
    [self addClickEventToRecentDetailView];
    [self addGestureEventToRecentDetailView];
    [self configRecentDetailTableViewRefresh];
}

- (void)addClickEventToRecentDetailView {
    [_recentDetailView.headerView.userHeaderButton addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentDetailView.headerView.psButton addTarget:self action:@selector(clickPSButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentDetailView.headerView.praiseButton addTarget:self action:@selector(clickPraiseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentDetailView.headerView.commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentDetailView.sendCommentButton addTarget:self action:@selector(clickSendCommentButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addGestureEventToRecentDetailView {
    _tapCommentDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentDetailGesture:)];
    [_recentDetailView.recentDetailTableView addGestureRecognizer:_tapCommentDetailGesture];
    _tapUserNameLabelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserNameLabelGesture:)];
    [_recentDetailView.headerView.userNameLabel addGestureRecognizer:_tapUserNameLabelGesture];
}

#pragma mark - Click Event

- (void)clickUserHeaderButton:(UIButton *)sender {
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    [self pushViewController:opvc animated:YES];
}

- (void)clickPSButton:(UIButton *)sender {
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"下载素材",@"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString *actionSheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([actionSheetTitle isEqualToString:@"下载素材"]) {
            [self dealDownloadWork];
        } else if ([actionSheetTitle isEqualToString:@"上传作品"]) {
            [self dealUploadWork];
        }
    }];
}

- (void)clickPraiseButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)clickCommentButton:(UIButton *)sender {
    ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
    [self pushViewController:cdvc animated:YES];
}

- (void)clickSendCommentButton:(UIButton *)sender {
    [_recentDetailView.sendCommentView resignFirstResponder];
    NSString *commentStr = _recentDetailView.sendCommentView.text;
    _recentDetailView.sendCommentView.text = @"";
    ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
    model.userCommentDetail = commentStr;
    [_dataSource insertObject:model atIndex:0];
    [_recentDetailView.recentDetailTableView reloadData];
    [_recentDetailView.recentDetailTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)dealDownloadWork {
    
}

- (void)dealUploadWork {
    [[NSUserDefaults standardUserDefaults] setObject:@"Uploading" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

//- (void)popCurrentController {
//    if (_pushType == ATOMCommentMessageType) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else if (_pushType == ATOMInviteMessageType) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else if (_pushType == ATOMTopicReplyMessageType) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else if (_pushType == ATOMMyUploadType) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else if (_pushType == ATOMMyWorkType) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else if (_pushType == ATOMProceedingType) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else if (_pushType == ATOMMyCollectionType) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//}

#pragma mark - Gesture Event

- (void)tapCommentDetailGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_recentDetailView.recentDetailTableView];
    NSIndexPath *indexPath = [_recentDetailView.recentDetailTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMRecentDetailTableViewCell *cell = (ATOMRecentDetailTableViewCell *)[_recentDetailView.recentDetailTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
            p = [gesture locationInView:cell.praiseButton];
            cell.praiseButton.selected = !cell.praiseButton.selected;
        } else if (CGRectContainsPoint(cell.userCommentDetailLabel.frame, p)) {
            if ([_recentDetailView.sendCommentView isFirstResponder]) {
                [_recentDetailView.sendCommentView resignFirstResponder];
            } else {
                [_recentDetailView.sendCommentView becomeFirstResponder];
                _recentDetailView.sendCommentView.text = @"@宋祥伍//";
            }
        }
    }
}

- (void)tapUserNameLabelGesture:(UITapGestureRecognizer *)gesture {
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    [self pushViewController:opvc animated:YES];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return _dataSource.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RecentDetailCell";
    ATOMRecentDetailTableViewCell *cell = [_recentDetailView.recentDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMRecentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMRecentDetailTableViewCell calculateCellHeightWithModel:_dataSource[indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ATOMMyConcernTableHeaderView *headerView = [ATOMMyConcernTableHeaderView new];
    if (section == 0) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0xf80630];
        headerView.titleLabel.text = @"最热评论";
    } else if (section == 1) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0x00adef];
        headerView.titleLabel.text = @"最新评论";
    }
    return headerView;
}












































@end
