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
#import "JGActionSheet.h"
#import "ATOMInviteViewController.h"
#import "ATOMReportModel.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMHotDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,PWRefreshBaseTableViewDelegate,ATOMViewControllerDelegate,ATOMShareFunctionViewDelegate,JGActionSheetDelegate>

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
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;

@end

@implementation ATOMHotDetailViewController

#pragma mark - Lazy Initialize

- (ATOMShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [ATOMShareFunctionView new];
        _shareFunctionView.delegate = self;
        UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissShareFunction:)];
        [_shareFunctionView addGestureRecognizer:tgr];
        [[AppDelegate APP].window addSubview:self.shareFunctionView];
    }
    return _shareFunctionView;
}
-(void)dismissShareFunction:(UITapGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:self.view];
    if (!CGRectContainsPoint(_shareFunctionView.bottomView.frame, location)) {
        [_shareFunctionView dismiss];
    }
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
//        [self configHotDetailTableViewRefresh];
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
                    [ws dealUploadWork];
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
            ATOMHotDetailPageViewModel *model = ws.dataSource[ws.selectedIndexPath.row];
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(model.ID) forKey:@"target_id"];
            [param setObject:@(model.type) forKey:@"target_type"];
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
                if(!error) {
                    [Util TextHud:@"已举报" inView:ws.view];
                }
            }];
        }];
    }
    return _reportActionSheet;
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
        ATOMHotDetailPageViewModel *model = _dataSource[_selectedIndexPath.row];
        [ATOMCollectModel toggleCollect:param withPageType:model.type withID:model.ID withBlock:^(NSError *error) {
            if (!error) {
                model.collected = self.shareFunctionView.collectButton.selected;
            }
        }];
    }
}
-(void)tapInvite {
    ATOMInviteViewController* ivc = [ATOMInviteViewController new];
    ivc.askPageViewModel = _askPageViewModel;
    [self pushViewController:ivc animated:NO];
}
-(void)tapReport {
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
}
#pragma mark Refresh

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self loadHotData];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    [self loadMoreHotData];
}
- (void)loadHotData {
    [self getDataSource];
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
    _currentPage = 1;
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
    _currentPage = 1;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(5) forKey:@"size"];
    [param setObject:@(_fold) forKey:@"fold"];
    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.askPageViewModel.askID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
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
    [param setObject:@(_fold) forKey:@"fold"];
    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.askPageViewModel.imageID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
            ATOMHotDetailPageViewModel *model = [ATOMHotDetailPageViewModel new];
            [model setViewModelDataWithDetailImage:detailImage];
            model.labelArray = [ws.askPageViewModel.labelArray mutableCopy];
            [ws.dataSource addObject:model];
            NSLog(@"for in getMoreDataSource");
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
                [self.psActionSheet showInView:[AppDelegate APP].window animated:true];
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
                    [pageDetailViewModel setCommonViewModelWithHotDetail:model];
                } else {
                    [pageDetailViewModel setCommonViewModelWithAsk:_askPageViewModel];
                }
                rdvc.pageDetailViewModel = pageDetailViewModel;
                rdvc.delegate = self;
                [self pushViewController:rdvc animated:YES];
            } else if (CGRectContainsPoint(_selectedHotDetailCell.moreShareButton.frame, p)) {
                self.shareFunctionView.collectButton.selected = model.collected;
                [self.shareFunctionView show];
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
