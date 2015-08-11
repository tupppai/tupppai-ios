//
//  ATOMPageDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AppDelegate.h"
#import "ATOMPageDetailViewController.h"
#import "ATOMPageDetailView.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMCropImageController.h"
#import "ATOMCommentTableViewCell.h"
#import "ATOMMyConcernTableHeaderView.h"
#import "ATOMPageDetailHeaderView.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMComment.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMShowDetailOfComment.h"
#import "ATOMShareFunctionView.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMPraiseButton.h"
#import "ATOMCollectModel.h"
#import "JGActionSheet.h"
#import "ATOMInviteViewController.h"
#import "ATOMReportModel.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMPageDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate,ATOMShareFunctionViewDelegate,JGActionSheetDelegate>

@property (nonatomic, strong) ATOMPageDetailView *askDetailView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray *hotCommentDataSource;
@property (nonatomic, strong) NSMutableArray *recentCommentDataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UITapGestureRecognizer *tapUserNameLabelGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentDetailGesture;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) ATOMCommentDetailViewModel *atModel;
@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;

@end

@implementation ATOMPageDetailViewController

#pragma mark - Lazy Initialize

- (ATOMShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [ATOMShareFunctionView new];
        _shareFunctionView.delegate = self;
    }
    return _shareFunctionView;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
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

- (void)tapOnImageView:(UIImage*)image withURL:(NSString*)url{
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (image != nil) {
        imageInfo.image = image;
    } else {
        imageInfo.imageURL = [NSURL URLWithString:url];
    }
//    imageInfo.referenceRect = _selectedAskCell.userHeaderButton.frame;
//    imageInfo.referenceView = _selectedAskCell.userHeaderButton;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
    //    imageViewer.interactionsDelegate = self;
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
            [param setObject:@(ws.pageDetailViewModel.pageID) forKey:@"target_id"];
            [param setObject:@(ws.pageDetailViewModel.type) forKey:@"target_type"];
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

#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    [self postSocialShare:_pageDetailViewModel.pageID withSocialShareType:ATOMShareTypeWechatFriends withPageType:(int)_pageDetailViewModel.type];
}
-(void)tapWechatMoment {
    [self postSocialShare:_pageDetailViewModel.pageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:(int)_pageDetailViewModel.type];
}
-(void)tapSinaWeibo {
    [self postSocialShare:_pageDetailViewModel.pageID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:(int)_pageDetailViewModel.type];
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
    [ATOMCollectModel toggleCollect:param withPageType:_pageDetailViewModel.type withID:_pageDetailViewModel.pageID withBlock:^(NSError *error) {
        if (!error) {
            _pageDetailViewModel.collected = self.shareFunctionView.collectButton.selected;
        }
    }];
}
-(void)tapInvite {
    ATOMInviteViewController* ivc = [ATOMInviteViewController new];
    ivc.askPageViewModel = [_pageDetailViewModel generateAskPageViewModel];
    [self pushViewController:ivc animated:NO];
}
-(void)tapReport {
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
}
#pragma mark Refresh

- (void)configRecentDetailTableViewRefresh {
//        [_askDetailView.recentDetailTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    WS(ws);
    [ws.askDetailView.recentDetailTableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ddot", i]];
        [animatedImages addObject:image];
    }
    ws.askDetailView.recentDetailTableView.gifFooter.refreshingImages = animatedImages;
    ws.askDetailView.recentDetailTableView.footer.stateHidden = YES;
}

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_askDetailView.recentDetailTableView.footer endRefreshing];
    }
}

#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    _hotCommentDataSource = nil;
    _hotCommentDataSource = [NSMutableArray array];
    _recentCommentDataSource = nil;
    _recentCommentDataSource = [NSMutableArray array];
    _currentPage = 1;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_ID) forKey:@"target_id"];
    [param setObject:@(_type) forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        for (ATOMComment *comment in hotCommentArray) {
            ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
            [model setViewModelData:comment];
            [ws.hotCommentDataSource addObject:model];
        }
        for (ATOMComment *comment in recentCommentArray) {
            ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
            [model setViewModelData:comment];
            [ws.recentCommentDataSource addObject:model];
        }
        [ws.askDetailView.recentDetailTableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    _currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_ID) forKey:@"target_id"];
    [param setObject:@(_type) forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        for (ATOMComment *comment in recentCommentArray) {
            ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
            [model setViewModelData:comment];
            [ws.recentCommentDataSource addObject:model];
        }
        [_askDetailView.recentDetailTableView.footer endRefreshing];
        [ws.askDetailView.recentDetailTableView reloadData];
        if (recentCommentArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
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
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    _atModel = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ((self.isMovingFromParentViewController || self.isBeingDismissed)) {
        if (_pageDetailViewModel && (self.isMovingFromParentViewController || self.isBeingDismissed)) {
            if(_delegate && [_delegate respondsToSelector:@selector(ATOMViewControllerDismissWithInfo:)])
            {
                NSLog(@"_pageDetailViewModel collected %d",_pageDetailViewModel.collected);
                NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:_pageDetailViewModel.liked],@"liked",[NSNumber numberWithBool:_pageDetailViewModel.collected],@"collected",nil];
                [_delegate ATOMViewControllerDismissWithInfo:info];
            }
        }
    }
}

- (void)createUI {
    self.title = @"详情";
    //fucking _askDetailView should be alloc and init before assigned to self.view
    _askDetailView = [ATOMPageDetailView new];
    [self configRecentDetailTableViewRefresh];
    self.view = _askDetailView;
//    if (_askPageViewModel) {
//        _type = 1;
//        _ID = _askPageViewModel.imageID;
//        _askDetailView.askPageViewModel = _askPageViewModel;
//    } else if (_productPageViewModel) {
//        _type = 2;
//        _ID = _productPageViewModel.ID;
//        _askDetailView.productPageViewModel = _productPageViewModel;
//    }
    _type = _pageDetailViewModel.type;
    _ID = _pageDetailViewModel.pageID;
    _askDetailView.pageDetailViewModel = _pageDetailViewModel;
//    _askDetailView.headerView.praiseButton.selected = _pageDetailViewModel.liked;
    
    _askDetailView.recentDetailTableView.delegate = self;
    _askDetailView.recentDetailTableView.dataSource = self;
    _askDetailView.commentTextView.delegate = self;
    [self addClickEventToAskDetailView];
    [self addGestureEventToAskDetailView];
    [self getDataSource];
    _canRefreshFooter = YES;
}

- (void)addClickEventToAskDetailView {
    UITapGestureRecognizer *g1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShareButton:)];
    [_askDetailView.headerView.shareButton addGestureRecognizer:g1];
    UITapGestureRecognizer *g2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreShareButton:)];
    [_askDetailView.headerView.moreShareButton addGestureRecognizer:g2];
    UITapGestureRecognizer *g3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPraiseButton:)];
    [_askDetailView.headerView.praiseButton addGestureRecognizer:g3];
    UITapGestureRecognizer *g4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserWorkImageView:)];
    [_askDetailView.headerView.userWorkImageView addGestureRecognizer:g4];
    
    [_askDetailView.headerView.userHeaderButton addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    [_askDetailView.headerView.psButton addTarget:self action:@selector(clickPSButton:) forControlEvents:UIControlEventTouchUpInside];
    [_askDetailView.sendCommentButton addTarget:self action:@selector(clickSendCommentButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addGestureEventToAskDetailView {
    _tapCommentDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentDetailGesture:)];
    [_askDetailView.recentDetailTableView addGestureRecognizer:_tapCommentDetailGesture];
    _tapUserNameLabelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserNameLabelGesture:)];
    [_askDetailView.headerView.userNameLabel addGestureRecognizer:_tapUserNameLabelGesture];
}

#pragma mark - Click Event

- (void)clickShareButton:(UITapGestureRecognizer *)sender {
    [self postSocialShare:_pageDetailViewModel.pageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:(int)_pageDetailViewModel.type];
}

- (void)clickMoreShareButton:(UITapGestureRecognizer *)sender {
    self.shareFunctionView.collectButton.selected = _pageDetailViewModel.collected;
    [self.shareFunctionView showInView:[AppDelegate APP].window animated:YES];
}

- (void)clickUserHeaderButton:(UIButton *)sender {
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    opvc.userID = _pageDetailViewModel.uid;
    opvc.userName = _pageDetailViewModel.userName;
    [self pushViewController:opvc animated:YES];
}

- (void)clickPSButton:(UIButton *)sender {
    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
}

- (void)clickPraiseButton:(UITapGestureRecognizer *)sender {
    [_askDetailView.headerView.praiseButton toggleLike];
    [_pageDetailViewModel toggleLike];
}
- (void)clickUserWorkImageView:(UITapGestureRecognizer *)sender {
    NSLog(@"clickUserWorkImageView");
    [self tapOnImageView:_askDetailView.headerView.userWorkImageView.image withURL:nil];
}

- (void)clickSendCommentButton:(UIButton *)sender {
//    [_askDetailView.commentTextView resignFirstResponder];
    NSString *commentStr = _askDetailView.commentTextView.text;
    _askDetailView.commentTextView.text = @"";
    [_askDetailView toggleSendCommentView];
    ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
    [model setDataWithAtModel:_atModel andContent:commentStr];
    [_recentCommentDataSource insertObject:model atIndex:0];
    [_askDetailView.recentDetailTableView reloadData];
//    [_askDetailView.recentDetailTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:commentStr forKey:@"content"];
    [param setObject:@(_type) forKey:@"type"];
    [param setObject:@(_ID) forKey:@"target_id"];
    [param setObject:@(0) forKey:@"for_comment"];
//    if (_atModel) {
//        [param setObject:@(_atModel.comment_id) forKey:@"comment_reply_to"];
//    }
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment SendComment:param withBlock:^(NSInteger comment_id, NSError *error) {
        model.comment_id = comment_id;
        
    }];
//    _atModel = nil;
}

- (void)dealDownloadWork {
    UIImageWriteToSavedPhotosAlbum(_askDetailView.headerView.userWorkImageView.image
,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Util TextHud:@"保存失败"];
    }else{
        [Util TextHud:@"保存到相册成功"];
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

- (void)tapCommentDetailGesture:(UITapGestureRecognizer *)gesture {
    if ([_askDetailView isEditingCommentView]) {
        [_askDetailView hideCommentView];
//        _askDetailView.commentTextView.text = @"";
//        _atModel = nil;
        return ;
    }
    CGPoint location = [gesture locationInView:_askDetailView.recentDetailTableView];
    NSIndexPath *indexPath = [_askDetailView.recentDetailTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMCommentTableViewCell *cell = (ATOMCommentTableViewCell *)[_askDetailView.recentDetailTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = cell.viewModel.uid;
            opvc.userName = cell.viewModel.nickname;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = cell.viewModel.uid;
            opvc.userName = cell.viewModel.nickname;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
            NSInteger section = indexPath.section;
            NSInteger row = indexPath.row;
            ATOMCommentDetailViewModel *model = (section == 0) ? _hotCommentDataSource[row] : _recentCommentDataSource[row];
//            if (!model.liked) {
////                cell.praiseButton.selected = !cell.praiseButton.selected;
//                ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
//                NSMutableDictionary *param = [NSMutableDictionary dictionary];
//                [param setObject:@(model.comment_id) forKey:@"cid"];
////                [showDetailOfComment PraiseComment:param withBlock:^(NSError *error) {
////                    if (!error) {
////                        NSLog(@"praise");
////                    }
////                }];
//            }
            //UI 颜色和数字
            [cell.praiseButton toggleLike];
            //Network,点赞，取消赞
            [model toggleLike];

//            [_askDetailView.recentDetailTableView reloadData];
        } else if (CGRectContainsPoint(cell.userCommentDetailLabel.frame, p)) {
//            [_askDetailView.commentTextView becomeFirstResponder];
//            NSInteger section = indexPath.section;
//            NSInteger row = indexPath.row;
//            if (section == 0) {
//                _atModel = _hotCommentDataSource[row];
//            } else if (section == 1) {
//                _atModel = _recentCommentDataSource[row];
//            }
//            _askDetailView.textViewPlaceholder = [NSString stringWithFormat:@"//@%@:", _atModel.nickname];
//            _askDetailView.commentTextView.text = _askDetailView.textViewPlaceholder;
        }
    }
}

- (void)tapUserNameLabelGesture:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapUserNameLabelGesture");
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    opvc.userID = _pageDetailViewModel.uid;
    opvc.userName = _pageDetailViewModel.userName;
    [self pushViewController:opvc animated:YES];
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
        uwvc.askPageViewModel = [ws.pageDetailViewModel generateAskPageViewModel];
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _hotCommentDataSource.count;
    } else if (section == 1) {
        return _recentCommentDataSource.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_askDetailView.recentDetailTableView == tableView) {
        static NSString *CellIdentifier = @"RecentDetailCell";
        ATOMCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ATOMCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.section == 0) {
            cell.viewModel = _hotCommentDataSource[indexPath.row];
        } else if (indexPath.section ==1) {
            cell.viewModel = _recentCommentDataSource[indexPath.row];
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return kCommentTableViewHeaderHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return [ATOMCommentTableViewCell calculateCellHeightWithModel:_hotCommentDataSource[indexPath.row]];
    } else if (section == 1) {
        return [ATOMCommentTableViewCell calculateCellHeightWithModel:_recentCommentDataSource[indexPath.row]];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ATOMMyConcernTableHeaderView *headerView = [ATOMMyConcernTableHeaderView new];
    if (section == 0) {
        headerView.titleLabel.text = @"最热评论";
    } else if (section == 1) {
        headerView.titleLabel.text = @"最新评论";
    }
    return headerView;
}

#pragma mark - UITextViewDelegate

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    if ([textView.text isEqualToString:_askDetailView.textViewPlaceholder]) {
//        textView.text = @"";
//    }
//}
//
//- (void)textViewDidChange:(UITextView *)textView {
//    NSString *str= textView.text;
//    if (textView.text.length == 0) {
//        if (_atModel) {
//            textView.text = _askDetailView.textViewPlaceholder;
//        } else {
//            textView.text = @"发表你的神回复...";
//        }
//    } else {
//        if (_atModel && [str hasPrefix:[NSString stringWithFormat:@"//@%@:", _atModel.nickname]]) {
//            textView.text = [str substringFromIndex:(_atModel.nickname.length + 4)];
//        } else if (!_atModel && [str hasPrefix:_askDetailView.textViewPlaceholder]) {
//            textView.text = [str substringFromIndex:10];
//        }
//    }
//}


#pragma mark - ATOMPSViewDelegate

- (void)dealImageWithCommand:(NSString *)command {
    if ([command isEqualToString:@"upload"]) {
        [self dealUploadWork];
    } else if ([command isEqualToString:@"download"]) {
        [self dealDownloadWork];
    }
}



@end
