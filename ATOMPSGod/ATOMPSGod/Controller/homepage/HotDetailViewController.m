//
//  HotDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AppDelegate.h"
#import "HotDetailViewController.h"
#import "kfcDetailCell.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMCropImageController.h"
#import "ATOMProceedingViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "DDHotDetailPageVM.h"
#import "DDCommentVM.h"
#import "ATOMDetailImage.h"
#import "ATOMComment.h"
#import "ATOMShowDetailOfHomePage.h"
#import "DDAskPageVM.h"
#import "ATOMShareFunctionView.h"
#import "kfcButton.h"
#import "RefreshTableView.h"
#import "ATOMCollectModel.h"
#import "ATOMBaseRequest.h"
#import "JGActionSheet.h"
#import "ATOMInviteViewController.h"
#import "ATOMReportModel.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CommentViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface HotDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,PWRefreshBaseTableViewDelegate,ATOMViewControllerDelegate,ATOMShareFunctionViewDelegate,JGActionSheetDelegate,JTSImageViewControllerInteractionsDelegate>

@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong) UIView *hotDetailView;
@property (nonatomic, strong) RefreshTableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapHotDetailGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) kfcDetailCell* selectedHotDetailCell;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;

@end

@implementation HotDetailViewController
static NSString *CellIdentifier = @"HotDetailCell";

#pragma mark - Lazy Initialize

- (ATOMShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [ATOMShareFunctionView new];
        _shareFunctionView.delegate = self;
    }
    return _shareFunctionView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[RefreshTableView alloc] initWithFrame:_hotDetailView.bounds];
        [_tableView registerClass:[kfcDetailCell class] forCellReuseIdentifier:CellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.psDelegate = self;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tapHotDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHotDetailGesture:)];
        [_tableView addGestureRecognizer:_tapHotDetailGesture];
    }
    return _tableView;
}

- (UIView *)hotDetailView {
    if (_hotDetailView == nil) {
        _hotDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        [_hotDetailView addSubview:self.tableView];
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
            DDHotDetailPageVM *model = ws.dataSource[ws.selectedIndexPath.row];
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
                    [Util text:@"已举报" inView:ws.view];
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
        [ATOMShareSDKModel postSocialShare:_askVM.ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:ATOMPageTypeAsk];
    } else {
        DDHotDetailPageVM *model = _dataSource[_selectedIndexPath.row];
        [ATOMShareSDKModel postSocialShare:model.ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:ATOMPageTypeReply];
    }
}
-(void)tapWechatMoment {
    if (_selectedIndexPath.row == 0) {
        [ATOMShareSDKModel postSocialShare:_askVM.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
    } else {
        DDHotDetailPageVM *model = _dataSource[_selectedIndexPath.row];
        [ATOMShareSDKModel postSocialShare:model.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeReply];
    }
}
-(void)tapSinaWeibo {
    if (_selectedIndexPath.row == 0) {
        [ATOMShareSDKModel postSocialShare:_askVM.ID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:ATOMPageTypeAsk];
    } else {
        DDHotDetailPageVM *model = _dataSource[_selectedIndexPath.row];
        [ATOMShareSDKModel postSocialShare:model.ID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:ATOMPageTypeReply];
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
        DDHotDetailPageVM *model = _dataSource[_selectedIndexPath.row];
        [ATOMCollectModel toggleCollect:param withPageType:model.type withID:model.ID withBlock:^(NSError *error) {
            if (!error) {
                model.collected = self.shareFunctionView.collectButton.selected;
            }
        }];
    }
}
-(void)tapInvite {
    ATOMInviteViewController* ivc = [ATOMInviteViewController new];
    ivc.askPageViewModel = _askVM;
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
    if (_canRefreshFooter && !_tableView.header.isRefreshing) {
        [self getMoreDataSource];
    } else {
        [_tableView.footer endRefreshing];
    }
}

#pragma mark - GetDataSource
//
//- (void)firstGetDataSource {
//    _currentPage = 1;
//    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
//    NSArray *detailImageArray = [showDetailOfHomePage getDetalImagesByImageID:_askVM.ID];
//    if (!detailImageArray || detailImageArray.count == 0) { //读服务器
//        [self getDataSource];
//    } else { //读数据库
//        _dataSource = nil;
//        _dataSource = [NSMutableArray array];
//        if (_fold != 1) {
//            ATOMHotDetailPageViewModel *model = [ATOMHotDetailPageViewModel new];
//            [model setViewModelDataWithHomeImage:_askVM];
//            [_dataSource addObject:model];
//        }
//        for (ATOMDetailImage *detailImage in detailImageArray) {
//            ATOMHotDetailPageViewModel *model = [ATOMHotDetailPageViewModel new];
//            [model setViewModelDataWithDetailImage:detailImage];
//            [_dataSource addObject:model];
//        }
//        _tableView.noDataView.canShow = YES;
//        [_tableView reloadData];
//    }
//}

- (void)getDataSource {
    _currentPage = 1;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(5) forKey:@"size"];
    [param setObject:@(_fold) forKey:@"fold"];
    ATOMShowDetailOfHomePage *showDetailOfHomePage = [ATOMShowDetailOfHomePage new];
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.askVM.ID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
        //第一张图片为首页点击的图片，剩下的图片为回复图片
        ws.dataSource = nil;
        ws.dataSource = [NSMutableArray array];
        if (_fold != 1) {
            DDHotDetailPageVM *model = [DDHotDetailPageVM new];
            [model setViewModelDataWithHomeImage:ws.askVM];
            [ws.dataSource addObject:model];
        }
        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
            DDHotDetailPageVM *model = [DDHotDetailPageVM new];
            [model setViewModelDataWithDetailImage:detailImage];
            [ws.dataSource addObject:model];
        }
        if (detailOfHomePageArray.count == 0) {
            _canRefreshFooter = NO;
        }
//        [showDetailOfHomePage saveDetailImagesInDB:detailOfHomePageArray];
        _tableView.noDataView.canShow = YES;
        [ws.tableView reloadData];
        [ws.tableView.header endRefreshing];
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
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.askVM.ID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
        for (ATOMDetailImage *detailImage in detailOfHomePageArray) {
            DDHotDetailPageVM *model = [DDHotDetailPageVM new];
            [model setViewModelDataWithDetailImage:detailImage];
            model.labelArray = [ws.askVM.labelArray mutableCopy];
            [ws.dataSource addObject:model];
        }
        if (detailOfHomePageArray.count == 0) {
            _canRefreshFooter = NO;
        } else {
            _canRefreshFooter = YES;
        }
        [ws.tableView reloadData];
        [ws.tableView.footer endRefreshing];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [_tableView.header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_askVM && (self.isMovingFromParentViewController || self.isBeingDismissed)) {
        if(_delegate && [_delegate respondsToSelector:@selector(ATOMViewControllerDismissWithInfo:)])
        {
            DDHotDetailPageVM *model = _dataSource[0];
            NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:model.liked],@"liked",[NSNumber numberWithBool:model.collected],@"collected",nil];
            [_delegate ATOMViewControllerDismissWithInfo:info];
        }
}
}

- (void)createUI {
    self.title = @"作品列表";
    _tableView.noDataView.label.text = @"网络连接断了吧😶";
    self.view = self.hotDetailView;
    _canRefreshFooter = YES;
}

#pragma mark - Click Event

- (void)tapOnImageView:(UIImage*)image withURL:(NSString*)url{
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (image != nil) {
        imageInfo.image = image;
    } else {
        imageInfo.imageURL = [NSURL URLWithString:url];
    }
//    imageInfo.referenceRect = _selectedHotDetailCell.userHeaderButton.frame;
//    imageInfo.referenceView = _selectedHotDetailCell.userHeaderButton;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    imageViewer.interactionsDelegate = self;
}
- (void)dealDownloadWork {
    kfcDetailCell *cell = (kfcDetailCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    UIImageWriteToSavedPhotosAlbum(cell.imageViewMain.image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Util text:@"保存失败"];
    }else{
        [Util text:@"保存成功"];
    }
}
- (void)dealUploadWork {
    [[NSUserDefaults standardUserDefaults] setObject:@"Reply" forKey:@"AskOrReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:NULL];
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


#pragma mark - Gesture Event

- (void)tapHotDetailGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    _selectedIndexPath = [_tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        DDHotDetailPageVM *model = _dataSource[_selectedIndexPath.row];
        _selectedHotDetailCell = (kfcDetailCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
        
        CGPoint p = [gesture locationInView:_selectedHotDetailCell];
        //点击图片
        if (CGRectContainsPoint(_selectedHotDetailCell.imageViewMain.frame, p)) {
            [self tapOnImageView:_selectedHotDetailCell.imageViewMain.image withURL:model.userImageURL];
        } else if (CGRectContainsPoint(_selectedHotDetailCell.topView.frame, p)) {
            p = [gesture locationInView:_selectedHotDetailCell.topView];
            if (CGRectContainsPoint(_selectedHotDetailCell.avatarView.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = model.uid;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            } else if (CGRectContainsPoint(_selectedHotDetailCell.psView.frame, p)) {
                [self.psActionSheet showInView:[AppDelegate APP].window animated:true];
            } else if (CGRectContainsPoint(_selectedHotDetailCell.usernameLabel.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = model.uid;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            }
        } else {
            p = [gesture locationInView:_selectedHotDetailCell.bottomView];
            if (CGRectContainsPoint(_selectedHotDetailCell.likeButton.frame, p)) {
                [_selectedHotDetailCell.likeButton toggleLike];
                    [model toggleLike];
                if (_selectedIndexPath.row == 0) {
                    //为了点赞第一个page，重新刷新时的数据能同步。
                    _askVM.liked = model.liked;
                    _askVM.likeNumber = _selectedHotDetailCell.likeButton.number;
                }
            } else if (CGRectContainsPoint(_selectedHotDetailCell.wechatButton.frame, p)) {
                if (_selectedIndexPath.row == 0) {
                    [ATOMShareSDKModel postSocialShare:_askVM.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeAsk];
                } else {
                    DDHotDetailPageVM *model = _dataSource[_selectedIndexPath.row];
                    [ATOMShareSDKModel postSocialShare:model.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:ATOMPageTypeReply];
                }            } else if (CGRectContainsPoint(_selectedHotDetailCell.commentButton.frame, p)) {
                    
                DDCommentPageVM* vm = [DDCommentPageVM new];
                if (_selectedIndexPath.row != 0) {
                    [vm setCommonViewModelWithHotDetail:model];
                } else {
                    [vm setCommonViewModelWithAsk:_askVM];
                }
                    CommentViewController* mvc = [CommentViewController new];
                    mvc.vm = vm;
                    mvc.delegate = self;
                    [self pushViewController:mvc animated:YES];
            } else if (CGRectContainsPoint(_selectedHotDetailCell.moreButton.frame, p)) {
                self.shareFunctionView.collectButton.selected = model.collected;
                [self.shareFunctionView showInView:[AppDelegate APP].window animated:YES];
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
        ATOMCropImageController *uwvc = [ATOMCropImageController new];
        uwvc.originImage = info[UIImagePickerControllerOriginalImage];
        uwvc.askPageViewModel = ws.askVM;
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kfcDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[kfcDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell configCell:_dataSource[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:CellIdentifier cacheByIndexPath:indexPath configuration:^(kfcDetailCell* cell) {
        [cell configCell:_dataSource[indexPath.row]];
    }];
}


#pragma mark - ATOMViewControllerDelegate
-(void)ATOMViewControllerDismissWithInfo:(NSDictionary *)info {
    bool liked = [info[@"liked"] boolValue];
    bool collected = [info[@"collected"]boolValue];
    //当从child viewcontroller 传来的liked变化的时候，toggle like.
    //to do:其实应该改变datasource的liked ,tableView reload的时候才能保持。
    [_selectedHotDetailCell.likeButton toggleLikeWhenSelectedChanged:liked];
    if (_selectedIndexPath) {
        DDHotDetailPageVM *model = _dataSource[_selectedIndexPath.row];
        model.collected = collected;
    }
}
#pragma mark - JTSImageViewControllerInteractionsDelegate

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect {
    NSLog(@"longpressed");
}
@end
