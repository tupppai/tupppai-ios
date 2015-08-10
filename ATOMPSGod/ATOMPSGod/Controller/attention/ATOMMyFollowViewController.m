//
//  ATOMMyFollowViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyFollowViewController.h"
#import "ATOMMyAttentionTableViewCell.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMShowAttention.h"
#import "ATOMCommonImage.h"
#import "ATOMFollowPageViewModel.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMNoDataView.h"
#import "PWRefreshBaseTableView.h"
#import "PWPageDetailViewModel.h"
#import "ATOMShareFunctionView.h"
#import "ATOMPageDetailViewController.h"
#import "AppDelegate.h"
#import "JGActionSheet.h"
#import "ATOMReportModel.h"
#import "ATOMCollectModel.h"
#import "ATOMInviteViewController.h"
#import "ATOMCropImageController.h"
#import "ATOMRecordModel.h"
#import "ATOMBaseRequest.h"


#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyFollowViewController () <UITableViewDelegate, UITableViewDataSource,PWRefreshBaseTableViewDelegate,ATOMViewControllerDelegate,ATOMShareFunctionViewDelegate,JGActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *myAttentionView;
@property (nonatomic, strong) PWRefreshBaseTableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapMyAttentionGesture;
@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger canRefreshFooter;
@property (nonatomic, assign) ATOMMyAttentionTableViewCell* selectedCell;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;

@end

@implementation ATOMMyFollowViewController

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
            [param setObject:@(ws.selectedCell.viewModel.imageID) forKey:@"target_id"];
            [param setObject:@(ws.selectedCell.viewModel.type) forKey:@"target_type"];
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

#pragma mark Refresh

- (void)loadNewHotData {
    [self getDataSource];
    [_tableView.header endRefreshing];
}

- (void)loadMoreHotData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_tableView.footer endRefreshing];
    }
}
#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    [self postSocialShare:_selectedCell.viewModel.imageID withSocialShareType:ATOMShareTypeWechatFriends withPageType:_selectedCell.viewModel.type];
}
-(void)tapWechatMoment {
    [self postSocialShare:_selectedCell.viewModel.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:_selectedCell.viewModel.type];
}
-(void)tapSinaWeibo {
    [self postSocialShare:_selectedCell.viewModel.imageID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:_selectedCell.viewModel.type];
}
-(void)tapInvite {
    ATOMInviteViewController* ivc = [ATOMInviteViewController new];
    NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:@(_selectedCell.viewModel.imageID),@"ID",@(_selectedCell.viewModel.askID),@"askID",@(_selectedCell.viewModel.type),@"type", nil];
    ivc.info = info;
    [self pushViewController:ivc animated:NO];
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
    [ATOMCollectModel toggleCollect:param withPageType:_selectedCell.viewModel.type withID:_selectedCell.viewModel.imageID withBlock:^(NSError *error) {
        if (!error) {
            _selectedCell.viewModel.collected = self.shareFunctionView.collectButton.selected;
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
    [self getDataSource];
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
            ATOMFollowPageViewModel * viewModel = [ATOMFollowPageViewModel new];
            [viewModel setViewModelData:commonImage];
            [_dataSource addObject:viewModel];
        }
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
            ATOMFollowPageViewModel * viewModel = [ATOMFollowPageViewModel new];
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

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)createUI {
    self.navigationItem.title = @"关注";
    _myAttentionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    self.view = _myAttentionView;
    _tableView = [[PWRefreshBaseTableView alloc] initWithFrame:_myAttentionView.bounds];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        _selectedCell = (ATOMMyAttentionTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:_selectedCell];
        //点击图片
        if (CGRectContainsPoint(_selectedCell.userWorkImageView.frame, p)) {
            ATOMPageDetailViewController* pdvc = [ATOMPageDetailViewController new];
            PWPageDetailViewModel *pageDetailViewModel = [PWPageDetailViewModel new];
            [pageDetailViewModel setCommonViewModelWithFollow:_dataSource[indexPath.row]];
            pdvc.pageDetailViewModel = pageDetailViewModel;
            pdvc.delegate = self;
            [self pushViewController:pdvc animated:true];
        } else if (CGRectContainsPoint(_selectedCell.topView.frame, p)) {
            p = [gesture locationInView:_selectedCell.topView];
            if (CGRectContainsPoint(_selectedCell.userHeaderButton.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                ATOMFollowPageViewModel* model =  (ATOMFollowPageViewModel*)_dataSource[indexPath.row];
                opvc.userID = model.userID;
                opvc.userName = model.userName;
                [self pushViewController:opvc animated:YES];
            } else if (CGRectContainsPoint(_selectedCell.userNameLabel.frame, p)) {
                    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                    ATOMFollowPageViewModel* model =  (ATOMFollowPageViewModel*)_dataSource[indexPath.row];
                    opvc.userID = model.userID;
                    opvc.userName = model.userName;
                    [self pushViewController:opvc animated:YES];
            }else if (CGRectContainsPoint(_selectedCell.psButton.frame, p)) {
                [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
            }

        } else {
            p = [gesture locationInView:_selectedCell.thinCenterView];
            if (CGRectContainsPoint(_selectedCell.praiseButton.frame, p)) {
                [_selectedCell.praiseButton toggleLike];
                [_dataSource[indexPath.row] toggleLike];
            } else if (CGRectContainsPoint(_selectedCell.shareButton.frame, p)) {
                [self postSocialShare:_selectedCell.viewModel.imageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:_selectedCell.viewModel.type];
            } else if (CGRectContainsPoint(_selectedCell.commentButton.frame, p)) {
                ATOMPageDetailViewController* pdvc = [ATOMPageDetailViewController new];
                PWPageDetailViewModel *pageDetailViewModel = [PWPageDetailViewModel new];
                [pageDetailViewModel setCommonViewModelWithFollow:_dataSource[indexPath.row]];
                pdvc.delegate = self;
                pdvc.pageDetailViewModel = pageDetailViewModel;
                [self pushViewController:pdvc animated:true];
            } else if (CGRectContainsPoint(_selectedCell.moreShareButton.frame, p)) {
                self.shareFunctionView.collectButton.selected = _selectedCell.viewModel.collected;
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
    static NSString *CellIdentifier = @"MyAttentionCell";
    ATOMMyAttentionTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMyAttentionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMMyAttentionTableViewCell calculateCellHeightWith:_dataSource[indexPath.row]];
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
    [_selectedCell.praiseButton toggleLikeWhenSelectedChanged:liked];
}




- (void)dealDownloadWork {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_selectedCell.viewModel.askID) forKey:@"target"];
    [ATOMRecordModel record:param withBlock:^(NSError *error, NSString *url) {
        if (!error) {
            [ATOMBaseRequest downloadImage:url withBlock:^(UIImage *image) {
                UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }];
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
        [Util TextHud:@"保存失败"];
    }else{
        [Util TextHud:@"保存成功"];
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
        uwvc.askPageViewModel = [_selectedCell.viewModel generateAskPageViewModel];
        [ws pushViewController:uwvc animated:YES];
    }];
}



















@end
