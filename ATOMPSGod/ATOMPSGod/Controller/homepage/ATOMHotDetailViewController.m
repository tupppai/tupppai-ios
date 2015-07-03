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
#import "ATOMHotDetailPageViewModel.h"
#import "ATOMCommentViewModel.h"
#import "ATOMDetailImage.h"
#import "ATOMComment.h"
#import "ATOMShowDetailOfHomePage.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMShareFunctionView.h"
#import "ATOMBottomCommonButton.h"
#import "PWRefreshBaseTableView.h"
#import "ATOMPageDetailViewController.h"
#import "ATOMCollectModel.h"
#import "ATOMBaseRequest.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMHotDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,PWRefreshBaseTableViewDelegate,ATOMViewControllerDelegate,ATOMShareFunctionViewDelegate>

@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong) UIView *hotDetailView;
@property (nonatomic, strong) PWRefreshBaseTableView *hotDetailTableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapHotDetailGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSIndexPath* selectedIndexPath;
@property (nonatomic, assign) ATOMHotDetailTableViewCell* selectedHotDetailCell;
@end

@implementation ATOMHotDetailViewController

#pragma mark - Lazy Initialize

- (ATOMShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [ATOMShareFunctionView new];
        _shareFunctionView.delegate = self;
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
#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    if (_selectedIndexPath.row == 0) {
        [self postSocialShare:_askPageViewModel.imageID withSocialShareType:ATOMShareTypeWechatFriends withPageType:ATOMPageTypeAsk];
    } else {
        ATOMHotDetailPageViewModel *model = _dataSource[_selectedIndexPath.row];
        [self postSocialShare:model.ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:ATOMPageTypeReply];
    }
}
-(void)tapWechatMoment {
    if (_selectedIndexPath.row == 0) {
        [self postSocialShare:_askPageViewModel.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
    } else {
        ATOMHotDetailPageViewModel *model = _dataSource[_selectedIndexPath.row];
        [self postSocialShare:model.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeReply];
    }
}
-(void)tapSinaWeibo {
    if (_selectedIndexPath.row == 0) {
        [self postSocialShare:_askPageViewModel.imageID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:ATOMPageTypeAsk];
    } else {
        ATOMHotDetailPageViewModel *model = _dataSource[_selectedIndexPath.row];
        [self postSocialShare:model.ID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:ATOMPageTypeReply];
    }
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
    if (_selectedIndexPath) {
        int type;
        if (_selectedIndexPath.row != 0) {
            type = ATOMPageTypeReply;
        } else {
            type = ATOMPageTypeAsk;
        }
        ATOMHotDetailPageViewModel *model = _dataSource[_selectedIndexPath.row];
        [ATOMCollectModel toggleCollect:param withPageType:type withID:model.ID withBlock:^(NSError *error) {
            if (!error) {
                model.collected = self.shareFunctionView.collectButton.selected;
                NSLog(@"tapCollect model.collected%d",model.collected);
            }
        }];
    }
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
    NSArray *detailImageArray = [showDetailOfHomePage getDetalImagesByImageID:_askPageViewModel.imageID];
    if (!detailImageArray || detailImageArray.count == 0) { //读服务器
        [self getDataSource];
    } else { //读数据库
        _dataSource = nil;
        _dataSource = [NSMutableArray array];
        if (_fold != 1) {
            ATOMHotDetailPageViewModel *model = [ATOMHotDetailPageViewModel new];
            [model setViewModelDataWithHomeImage:_askPageViewModel];
            [_dataSource addObject:model];
        }
        for (ATOMDetailImage *detailImage in detailImageArray) {
            NSLog(@"detailImage %d %@",detailImage.type,detailImage.imageURL);
            ATOMHotDetailPageViewModel *model = [ATOMHotDetailPageViewModel new];
            [model setViewModelDataWithDetailImage:detailImage];
            model.labelArray = [_askPageViewModel.labelArray mutableCopy];
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
    [param setObject:@(_fold) forKey:@"fold"];
    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
    NSLog(@"%d", (int)ws.askPageViewModel.imageID);
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.askPageViewModel.imageID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
        //第一张图片为首页点击的图片，剩下的图片为回复图片
        ws.dataSource = nil;
        ws.dataSource = [NSMutableArray array];
        if (_fold != 1) {
            ATOMHotDetailPageViewModel *model = [ATOMHotDetailPageViewModel new];
            [model setViewModelDataWithHomeImage:ws.askPageViewModel];
            [ws.dataSource addObject:model];
        }
        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
            ATOMHotDetailPageViewModel *model = [ATOMHotDetailPageViewModel new];
            [model setViewModelDataWithDetailImage:detailImage];
            model.labelArray = [ws.askPageViewModel.labelArray mutableCopy];
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
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.askPageViewModel.imageID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
            ATOMHotDetailPageViewModel *model = [ATOMHotDetailPageViewModel new];
            [model setViewModelDataWithDetailImage:detailImage];
            model.labelArray = [ws.askPageViewModel.labelArray mutableCopy];
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
    if (_askPageViewModel && (self.isMovingFromParentViewController || self.isBeingDismissed)) {
        if(_delegate && [_delegate respondsToSelector:@selector(ATOMViewControllerDismissWithInfo:)])
        {
            ATOMHotDetailPageViewModel *model = _dataSource[0];
            NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:model.liked],@"liked",[NSNumber numberWithBool:model.collected],@"collected",nil];
            [_delegate ATOMViewControllerDismissWithInfo:info];
        }
}
}

- (void)createUI {
    self.title = @"作品列表";
    self.view = self.hotDetailView;
    _canRefreshFooter = YES;
}

#pragma mark - Click Event

- (void)dealDownloadWork {
    ATOMHotDetailTableViewCell *cell = (ATOMHotDetailTableViewCell *)[_hotDetailTableView cellForRowAtIndexPath:_selectedIndexPath];
    UIImageWriteToSavedPhotosAlbum(cell.userWorkImageView.image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Util TextHud:@"保存失败"];
    }else{
        [Util TextHud:@"保存成功"];
    }
}
- (void)dealUploadWork {
    [[NSUserDefaults standardUserDefaults] setObject:@"Uploading" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}


#pragma mark - Gesture Event

- (void)tapHotDetailGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_hotDetailTableView];
    _selectedIndexPath = [_hotDetailTableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        ATOMHotDetailPageViewModel *model = _dataSource[_selectedIndexPath.row];
        _selectedHotDetailCell = (ATOMHotDetailTableViewCell *)[_hotDetailTableView cellForRowAtIndexPath:_selectedIndexPath];
        
        CGPoint p = [gesture locationInView:_selectedHotDetailCell];
        //点击图片
        if (CGRectContainsPoint(_selectedHotDetailCell.userWorkImageView.frame, p)) {
            PWPageDetailViewModel* pageDetailViewModel = [PWPageDetailViewModel new];
            [pageDetailViewModel setCommonViewModelWithHotDetail:model];
            ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
            rdvc.pageDetailViewModel = pageDetailViewModel;
            rdvc.delegate = self;
            [self pushViewController:rdvc animated:YES];
        } else if (CGRectContainsPoint(_selectedHotDetailCell.topView.frame, p)) {
            p = [gesture locationInView:_selectedHotDetailCell.topView];
            if (CGRectContainsPoint(_selectedHotDetailCell.userHeaderButton.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = model.uid;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            } else if (CGRectContainsPoint(_selectedHotDetailCell.psButton.frame, p)) {
                [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"下载素材",@"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                    NSString *actionSheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
                    if ([actionSheetTitle isEqualToString:@"下载素材"]) {
                        [self dealDownloadWork];
                    } else if ([actionSheetTitle isEqualToString:@"上传作品"]) {
                        [self dealUploadWork];
                    }
                }];
            } else if (CGRectContainsPoint(_selectedHotDetailCell.userNameLabel.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = model.uid;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            }
        } else {
            p = [gesture locationInView:_selectedHotDetailCell.thinCenterView];
            if (CGRectContainsPoint(_selectedHotDetailCell.praiseButton.frame, p)) {
                [_selectedHotDetailCell.praiseButton toggleLike];
                    [model toggleLike];
            } else if (CGRectContainsPoint(_selectedHotDetailCell.shareButton.frame, p)) {
                if (_selectedIndexPath.row == 0) {
                    [self postSocialShare:_askPageViewModel.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
                } else {
                    ATOMHotDetailPageViewModel *model = _dataSource[_selectedIndexPath.row];
                    [self postSocialShare:model.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeReply];
                }            } else if (CGRectContainsPoint(_selectedHotDetailCell.commentButton.frame, p)) {
                ATOMPageDetailViewController *rdvc = [ATOMPageDetailViewController new];
                PWPageDetailViewModel* pageDetailViewModel = [PWPageDetailViewModel new];
                if (_selectedIndexPath.row != 0) {
                    [pageDetailViewModel setCommonViewModelWithProduct:model];
                } else {
                    [pageDetailViewModel setCommonViewModelWithAsk:_askPageViewModel];
                }
                rdvc.pageDetailViewModel = pageDetailViewModel;
                rdvc.delegate = self;
                [self pushViewController:rdvc animated:YES];
            } else if (CGRectContainsPoint(_selectedHotDetailCell.moreShareButton.frame, p)) {
                self.shareFunctionView.collectButton.selected = model.collected;
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
        uwvc.askPageViewModel = ws.askPageViewModel;
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - ATOMViewControllerDelegate
-(void)ATOMViewControllerDismissWithInfo:(NSDictionary *)info {
    bool liked = [info[@"liked"] boolValue];
    bool collected = [info[@"collected"]boolValue];
    NSLog(@"hot detail collected %d",collected);
    //当从child viewcontroller 传来的liked变化的时候，toggle like.
    //to do:其实应该改变datasource的liked ,tableView reload的时候才能保持。
    [_selectedHotDetailCell.praiseButton toggleLikeWhenSelectedChanged:liked];
    ATOMHotDetailPageViewModel *model = _dataSource[_selectedIndexPath.row];
    model.collected = collected;
}
@end
