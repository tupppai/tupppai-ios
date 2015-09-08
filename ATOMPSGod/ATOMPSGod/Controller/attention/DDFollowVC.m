//
//  ATOMMyFollowViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDFollowVC.h"
#import "kfcFollowCell.h"
#import "ATOMCommentDetailViewController.h"
#import "DDDetailPageVC.h"
#import "ATOMOtherPersonViewController.h"
#import "DDPageVM.h"
#import "ATOMShowAttention.h"
#import "ATOMCommonImage.h"
#import "kfcFollowVM.h"
#import "kfcButton.h"
#import "ATOMNoDataView.h"
#import "RefreshTableView.h"
#import "DDCommentPageVM.h"
#import "ATOMShareFunctionView.h"
#import "AppDelegate.h"
#import "JGActionSheet.h"
#import "ATOMReportModel.h"
#import "DDCollectManager.h"
#import "DDInviteVC.h"
#import "DDCropImageVC.h"
#import "DDBaseService.h"
#import "DDCommentVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DDService.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDFollowVC () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,ATOMViewControllerDelegate,ATOMShareFunctionViewDelegate,JGActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *myAttentionView;
@property (nonatomic, strong) RefreshTableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyAttentionGesture;
@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger canRefreshFooter;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;

@end

@implementation DDFollowVC
static NSString *CellIdentifier = @"MyAttentionCell";


#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNav2) name:@"RefreshNav2" object:nil];
}
- (void)refreshNav2 {
    if (!_tableView.header.isRefreshing) {
        [_tableView.header beginRefreshing];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)createUI {
    self.navigationItem.title = @"关注";
    _myAttentionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    self.view = _myAttentionView;
    _tableView = [[RefreshTableView alloc] initWithFrame:_myAttentionView.bounds];
    [_tableView registerClass:[kfcFollowCell class] forCellReuseIdentifier:CellIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT;
    _tableView.delegate = self;
    _tableView.psDelegate = self;
    _tableView.dataSource = self;
    [_myAttentionView addSubview:_tableView];
    _tapMyAttentionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyAttentionGesture:)];
    [_tableView addGestureRecognizer:_tapMyAttentionGesture];
    _canRefreshFooter = YES;
    _dataSource = [NSMutableArray array];
    [self firstGetDataSource];
}

#pragma mark - Gesture Event

- (void)tapMyAttentionGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    _selectedIndexPath = [_tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
       kfcFollowCell* cell = (kfcFollowCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
        kfcFollowVM* vm = _dataSource[_selectedIndexPath.row];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.imageViewMain.frame, p)) {
//            ATOMPageDetailViewController* pdvc = [ATOMPageDetailViewController new];
//            kfcPageVM *pageDetailViewModel = [kfcPageVM new];
//            [pageDetailViewModel setCommonViewModelWithFollow:_dataSource[_selectedIndexPath.row]];
//            pdvc.pageDetailViewModel = pageDetailViewModel;
//            pdvc.delegate = self;
//            [self pushViewController:pdvc animated:true];
        } else if (CGRectContainsPoint(cell.topView.frame, p)) {
            p = [gesture locationInView:cell.topView];
            if (CGRectContainsPoint(cell.avatarView.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                opvc.userID = vm.userID;
                opvc.userName = vm.userName;
                [self pushViewController:opvc animated:YES];
            } else if (CGRectContainsPoint(cell.usernameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    opvc.userID = vm.userID;
                    opvc.userName = vm.userName;
                    [self pushViewController:opvc animated:YES];
            }else if (CGRectContainsPoint(cell.psView.frame, p)) {
                [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
            }
        } else {
            p = [gesture locationInView:cell.bottomView];
            if (CGRectContainsPoint(cell.likeButton.frame, p)) {
                [cell.likeButton toggleLike];
                [_dataSource[_selectedIndexPath.row] toggleLike];
            } else if (CGRectContainsPoint(cell.wechatButton.frame, p)) {
                [DDShareSDKManager postSocialShare:vm.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:vm.type];
            } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
                DDCommentVC* mvc = [DDCommentVC new];
                DDCommentPageVM *vm = [DDCommentPageVM new];
                [vm setCommonViewModelWithFollow:_dataSource[_selectedIndexPath.row]];
                mvc.vm = vm;
                mvc.delegate = self;
                [self pushViewController:mvc animated:YES];
            } else if (CGRectContainsPoint(cell.moreButton.frame, p)) {
                self.shareFunctionView.collectButton.selected = vm.collected;
                [self.shareFunctionView showInView:[AppDelegate APP].window animated:YES];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    kfcFollowCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    kfcFollowVM* vm = _dataSource[indexPath.row];
    [cell configCell:vm];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:CellIdentifier cacheByIndexPath:indexPath configuration:^(kfcFollowCell* cell) {
        kfcFollowVM* vm = _dataSource[indexPath.row];
        [cell configCell:vm];
    }];
}

#pragma mark - PWRefreshBaseTableViewDelegate
-(void)didPullRefreshDown:(UITableView *)tableView {
    [self loadNewHotData];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    [self loadMoreHotData];
}

#pragma mark - ATOMViewControllerDelegate
-(void)ATOMViewControllerDismissWithLiked:(BOOL)liked {
    kfcFollowCell* cell = (kfcFollowCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell.likeButton toggleLikeWhenSelectedChanged:liked];
}

- (void)dealDownloadWork {
    kfcFollowVM* vm = _dataSource[_selectedIndexPath.row];
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(vm.askID) forKey:@"target"];
    
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        if (imageUrl != nil) {
            //            [DDBaseService downloadImage:imageUrl withBlock:^(UIImage *image) {
            kfcFollowCell* cell = (kfcFollowCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
            UIImageWriteToSavedPhotosAlbum(cell.imageViewMain.image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            //            }];
        }
    }];
}


- (void)dealUploadWork {
    
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

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Hud text:@"保存失败"];
    }else{
        [Hud text:@"保存成功"];
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        kfcFollowVM* vm = _dataSource[_selectedIndexPath.row];
        DDCropImageVC *uwvc = [DDCropImageVC new];
        uwvc.originImage = info[UIImagePickerControllerOriginalImage];
        uwvc.askPageViewModel = [vm generateAskPageViewModel];
        [ws pushViewController:uwvc animated:YES];
    }];
}


#pragma mark - Lazy Initialize
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
- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
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
            kfcFollowVM* vm = ws.dataSource[ws.selectedIndexPath.row];
            [param setObject:@(vm.imageID) forKey:@"target_id"];
            [param setObject:@(vm.type) forKey:@"target_type"];
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
                    [Hud text:@"已举报" inView:ws.view];
                }
            }];
        }];
    }
    return _reportActionSheet;
}

#pragma mark Refresh

- (void)loadNewHotData {
    [self getDataSource];
    [_tableView.header endRefreshing];
}

- (void)loadMoreHotData {
    if (_canRefreshFooter && !_tableView.header.isRefreshing) {
        [self getMoreDataSource];
    } else {
        [_tableView.footer endRefreshing];
    }
}
#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    kfcFollowVM* vm = _dataSource[_selectedIndexPath.row];
    [DDShareSDKManager postSocialShare:vm.imageID withSocialShareType:ATOMShareTypeWechatFriends withPageType:vm.type];
}
-(void)tapWechatMoment {
    kfcFollowVM* vm = _dataSource[_selectedIndexPath.row];
    [DDShareSDKManager postSocialShare:vm.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:vm.type];
}
-(void)tapSinaWeibo {
    kfcFollowVM* vm = _dataSource[_selectedIndexPath.row];
    [DDShareSDKManager postSocialShare:vm.imageID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:vm.type];
}
-(void)tapInvite {
    kfcFollowVM* vm = _dataSource[_selectedIndexPath.row];
    DDInviteVC* ivc = [DDInviteVC new];
    NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:@(vm.imageID),@"ID",@(vm.askID),@"askID",@(vm.type),@"type", nil];
    ivc.info = info;
    [self pushViewController:ivc animated:NO];
}
-(void)tapCollect {
    kfcFollowVM* vm = _dataSource[_selectedIndexPath.row];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (self.shareFunctionView.collectButton.selected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:vm.type withID:vm.imageID withBlock:^(NSError *error) {
        if (!error) {
            vm.collected = self.shareFunctionView.collectButton.selected;
        } else {
            self.shareFunctionView.collectButton.selected = !self.shareFunctionView.collectButton.selected;
        }
    }];
}
-(void)tapReport {
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
}

#pragma mark - GetDataSource
- (void)firstGetDataSource {
    [_tableView.header beginRefreshing];
}

- (void)getDataSource {
    _currentPage = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    ATOMShowAttention *showAttention = [ATOMShowAttention new];
    [showAttention ShowAttention:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        if (resultArray.count) {
            [_dataSource removeAllObjects];
        }
        for (ATOMCommonImage *commonImage in resultArray) {
            kfcFollowVM * viewModel = [kfcFollowVM new];
            [viewModel setViewModelData:commonImage];
            [_dataSource addObject:viewModel];
        }
        _tableView.noDataView.canShow = YES;
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    }];
}

- (void)getMoreDataSource {
    _currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    ATOMShowAttention *showAttention = [ATOMShowAttention new];
    [showAttention ShowAttention:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        for (ATOMCommonImage *commonImage in resultArray) {
            kfcFollowVM * viewModel = [kfcFollowVM new];
            [viewModel setViewModelData:commonImage];
            [_dataSource addObject:viewModel];
        }
        if (resultArray.count == 0) {
            _canRefreshFooter = NO;
        } else {
            _canRefreshFooter = YES;
        }
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
    }];
}












@end
