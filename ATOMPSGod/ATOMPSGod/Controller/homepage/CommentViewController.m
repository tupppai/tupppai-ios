//
//  CommentViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentTextView.h"
#import "JGActionSheet.h"
#import "ATOMShareFunctionView.h"
#import "CommentVM.h"
#import "AppDelegate.h"
#import "ATOMCropImageController.h"
#import "CommentCell.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMComment.h"
#import "ATOMShowDetailOfComment.h"
#import "ATOMShareFunctionView.h"
#import "CommentLikeButton.h"
#import "ATOMCollectModel.h"
#import "JGActionSheet.h"
#import "ATOMInviteViewController.h"
#import "ATOMReportModel.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "ZZCommentHeaderView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

#define DEBUG_CUSTOM_TYPING_INDICATOR 0

static NSString *MessengerCellIdentifier = @"MessengerCell";

@interface CommentViewController ()<ATOMShareFunctionViewDelegate,ATOMViewControllerDelegate,JGActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray *commentsHot;
@property (nonatomic, strong) NSMutableArray *commentsNew;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITapGestureRecognizer *tapUserNameLabelGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentTableGesture;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) CommentVM *atModel;
@property (nonatomic, strong) ATOMShareFunctionView *shareFunctionView;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;
@property (nonatomic, strong) NSIndexPath *selectedIndexpath;


@end

@implementation CommentViewController

- (id)init
{
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}

- (void)commonInit
{
    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    [self registerClassForTextView:[CommentTextView class]];
    
#if DEBUG_CUSTOM_TYPING_INDICATOR
    // Register a UIView subclass, conforming to SLKTypingIndicatorProtocol, to use a custom typing indicator view.
    [self registerClassForTypingIndicatorView:[TypingIndicatorView class]];
#endif
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTableView];
    [self configFooterRefresh];
    [self configTextInput];
    [self addGestureToHeaderView];
    [self addGestureToCommentTableView];
    [self getDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollElegantly];
}

- (void)scrollElegantly {
    [self.tableView setContentOffset:CGPointMake(0, _headerView.frame.size.height - kfcBottomViewHeight) animated:YES];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ((self.isMovingFromParentViewController || self.isBeingDismissed)) {
        if (_vm && (self.isMovingFromParentViewController || self.isBeingDismissed)) {
            if(_delegate && [_delegate respondsToSelector:@selector(ATOMViewControllerDismissWithInfo:)])
            {
                NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:_vm.liked],@"liked",[NSNumber numberWithBool:_vm.collected],@"collected",nil];
                [_delegate ATOMViewControllerDismissWithInfo:info];
            }
        }
    }
}

#pragma mark - Action Methods




#pragma mark - Overriden Methods

- (BOOL)ignoreTextInputbarAdjustment
{
    return NO;
}

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status
{
    // Notifies the view controller that the keyboard changed status.
}

- (void)textWillUpdate
{
    // Notifies the view controller that the text will update.

    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated
{
    // Notifies the view controller that the text did update.

    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender
{
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender
{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    [self sendComment];
    [super didPressRightButton:sender];
}

-(void)sendComment {

    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView resignFirstResponder];
    
    CommentVM *comment = [CommentVM new];
    comment.username = [ATOMCurrentUser currentUser].username;
    NSString* commentText = [self.textView.text copy];
    comment.text = commentText;
    comment.uid = [ATOMCurrentUser currentUser].uid;
    comment.avatar = [ATOMCurrentUser currentUser].avatar;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;
    
    [self.tableView beginUpdates];
    [self.commentsNew insertObject:comment atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
    
    // Fixes the cell from blinking (because of the transform, when using translucent cells)
    // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:commentText forKey:@"content"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(_vm.pageID) forKey:@"target_id"];
    [param setObject:@(0) forKey:@"for_comment"];
    if (_atModel) {
        [param setObject:@(_atModel.ID) forKey:@"comment_reply_to"];
    }
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment SendComment:param withBlock:^(NSInteger comment_id, NSError *error) {
        comment.ID = comment_id;
    }];
    _atModel = nil;
}

- (NSString *)keyForTextCaching
{
    return [[NSBundle mainBundle] bundleIdentifier];
}


- (void)willRequestUndo
{
    // Notifies the view controller when a user did shake the device to undo the typed text
    [super willRequestUndo];
}

- (void)didCommitTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text

    [super didCommitTextEditing:sender];
}

- (void)didCancelTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the left "Cancel" button

    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton
{
    return [super canPressRightButton];
}

- (BOOL)canShowTypingIndicator
{
#if DEBUG_CUSTOM_TYPING_INDICATOR
    return YES;
#else
    return [super canShowTypingIndicator];
#endif
}




#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _commentsHot.count;
    } else if (section == 1) {
        return _commentsNew.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView == tableView) {
        static NSString *CellIdentifier = @"CommentCell";
        CommentTableViewCell *cell = (CommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MessengerCellIdentifier];
        if (!cell) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.section == 0) {
            [cell getSource:_commentsHot[indexPath.row]];
        } else if (indexPath.section ==1) {
            [cell getSource:_commentsNew[indexPath.row]];
        }
        // Cells must inherit the table view's transform
        // This is very important, since the main table view may be inverted
        cell.transform = self.tableView.transform;
        return cell;
    }
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        CommentVM* vm;
        if (indexPath.section == 0) {
            vm = _commentsHot[indexPath.row];
        } else if (indexPath.section ==1) {
            vm = _commentsNew[indexPath.row];
        }
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-kMessageTableViewCellAvatarHeight;
        width -= 25.0;
        
        CGRect titleBounds = [vm.username boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGRect bodyBounds = [vm.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        if (vm.text.length == 0) {
            return 0.0;
        }
        
        CGFloat height = CGRectGetHeight(titleBounds);
        height += CGRectGetHeight(bodyBounds);
        height += 40.0;
        
        if (height < kMessageTableViewCellMinimumHeight) {
            height = kMessageTableViewCellMinimumHeight;
        }
        
        return height;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZZCommentHeaderView *headerView = [ZZCommentHeaderView new];
    if (section == 0) {
        headerView.titleLabel.text = @"最热评论";
    } else if (section == 1) {
        headerView.titleLabel.text = @"最新评论";
    }
    return headerView;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        _atModel = _commentsHot[row];
    } else if (section == 1) {
        _atModel = _commentsNew[row];
    }
    NSString* textToEdit = [NSString stringWithFormat:@"//%@:%@",_atModel.username,_atModel.text];
    self.textView.text = textToEdit;
    [self.textView becomeFirstResponder];
    [self.textView setSelectedRange:NSMakeRange(0, 0)];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you ovveride this method, to call super.
    [super scrollViewDidScroll:scrollView];
}


#pragma mark - UIScrollViewDelegate Methods

/** UITextViewDelegate */
- (BOOL)textView:(SLKTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendComment];
    }
    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}
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
            [param setObject:@(ws.vm.pageID) forKey:@"target_id"];
            [param setObject:@(ws.vm.type) forKey:@"target_type"];
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

//#pragma mark - ATOMShareFunctionViewDelegate
//-(void)tapWechatFriends {
//    [ATOMShareSDKModel postSocialShare:_vm.pageID withSocialShareType:ATOMShareTypeWechatFriends withPageType:(int)_vm.type];
//}
//-(void)tapWechatMoment {
//    [ATOMShareSDKModel postSocialShare:_vm.pageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:(int)_vm.type];
//}
//-(void)tapSinaWeibo {
//    [ATOMShareSDKModel postSocialShare:_vm.pageID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:(int)_vm.type];
//}
//-(void)tapCollect {
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    if (self.shareFunctionView.collectButton.selected) {
//        //收藏
//        [param setObject:@(1) forKey:@"status"];
//    } else {
//        //取消收藏
//        [param setObject:@(0) forKey:@"status"];
//    }
//    [ATOMCollectModel toggleCollect:param withPageType:_vm.type withID:_vm.pageID withBlock:^(NSError *error) {
//        if (!error) {
//            _vm.collected = self.shareFunctionView.collectButton.selected;
//        }
//    }];
//}
//-(void)tapInvite {
//    ATOMInviteViewController* ivc = [ATOMInviteViewController new];
//    ivc.askPageViewModel = [_vm generateAskPageViewModel];
//    [self pushViewController:ivc animated:NO];
//}
//-(void)tapReport {
//    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
//}
#pragma mark init and config

-(void)configTableView {
    _headerView = [kfcPageView new];
    _headerView.vm = _vm;
//    self.tableView.tableHeaderView = _headerView;
    self.tableView.emptyDataSetSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
//    UIView *header = self.tableView.tableHeaderView;
//    [header setNeedsLayout];
//    [header layoutIfNeeded];
//    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    CGRect frame = header.frame;
//    frame.size.height = height;
//    header.frame = frame;
//    self.tableView.tableHeaderView = header;
}
-(void)configTextInput {
    self.bounces = NO;
    self.shakeToClearEnabled = NO;
    self.keyboardPanningEnabled = NO;
    self.shouldScrollToBottomAfterKeyboardShows = YES;
    self.inverted = NO;
    [self.leftButton setImage:[UIImage imageNamed:@"btn_emoji"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"btn_comment_send"] forState:UIControlStateNormal];
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 256;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    
}
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [super scrollViewShouldScrollToTop:scrollView];
    return NO;
}
- (void)configFooterRefresh {
    [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ddot", i]];
        [animatedImages addObject:image];
    }
    self.tableView.gifFooter.refreshingImages = animatedImages;
    self.tableView.footer.stateHidden = YES;
    _canRefreshFooter = YES;
}

- (void)addGestureToHeaderView {
    UITapGestureRecognizer *g1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShareButton)];
    [_headerView.wechatButton addGestureRecognizer:g1];
    UITapGestureRecognizer *g2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreShareButton)];
    [_headerView.moreButton addGestureRecognizer:g2];
    UITapGestureRecognizer *g3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPraiseButton)];
    [_headerView.likeButton addGestureRecognizer:g3];
    UITapGestureRecognizer *g4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHeaderButton)];
    [_headerView.avatarView addGestureRecognizer:g4];
    UITapGestureRecognizer *g5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPSButton)];
    [_headerView.psView addGestureRecognizer:g5];
    UITapGestureRecognizer *g6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserWorkImageView)];
    [_headerView.imageViewMain addGestureRecognizer:g6];

    _tapUserNameLabelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserNameLabel)];
    [_headerView.usernameLabel addGestureRecognizer:_tapUserNameLabelGesture];
}

- (void)addGestureToCommentTableView {
    _tapCommentTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentTable:)];
    _tapCommentTableGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:_tapCommentTableGesture];
}

#pragma mark - tap Event

- (void)tapCommentTable:(UITapGestureRecognizer *)gesture {

    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        CommentTableViewCell *cell = (CommentTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        CommentVM *model = (section == 0) ? _commentsHot[row] : _commentsNew[row];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.avatarView.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = model.uid;
            opvc.userName = model.username;
            [self.navigationController pushViewController:opvc animated:YES];
        }
//        else if (CGRectContainsPoint(cell.usernameLabel.frame, p)) {
//            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
//            opvc.userID = model.uid;
//            opvc.userName = model.username;
//            [self pushViewController:opvc animated:YES];
//        }
        else if (CGRectContainsPoint(cell.likeButton.frame, p)) {
            //UI
            [cell.likeButton toggleLike];
            //Network
            [model toggleLike];

    }
}
}
- (void)tapUserNameLabel {
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    opvc.userID = _vm.uid;
    opvc.userName = _vm.userName;
//    [self pushViewController:opvc animated:YES];
}

//- (void)clickShareButton{
//    [ATOMShareSDKModel postSocialShare:_vm.pageID withSocialShareType:ATOMShareTypeWechatMoments withPageType:(int)_vm.type];
//}

- (void)clickMoreShareButton {
    self.shareFunctionView.collectButton.selected = _vm.collected;
    [self.shareFunctionView showInView:[AppDelegate APP].window animated:YES];
}

- (void)clickUserHeaderButton {
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    opvc.userID = _vm.uid;
    opvc.userName = _vm.userName;
//    [self pushViewController:opvc animated:YES];
}

- (void)clickPSButton {
    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
}

- (void)clickPraiseButton {
    [_headerView.likeButton toggleLike];
    [_vm toggleLike];
}
- (void)clickUserWorkImageView {
    [self tapOnImageView:_headerView.imageViewMain.image withURL:nil];
}

#pragma mark Refresh

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [self.tableView.footer endRefreshing];
    }
}

#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    _commentsHot = nil;
    _commentsHot = [NSMutableArray array];
    _commentsNew = nil;
    _commentsNew = [NSMutableArray array];
    _currentPage = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_vm.pageID) forKey:@"target_id"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        for (ATOMComment *comment in hotCommentArray) {
            CommentVM *model = [CommentVM new];
            [model setViewModelData:comment];
            [ws.commentsHot addObject:model];
        }
        for (ATOMComment *comment in recentCommentArray) {
            CommentVM *model = [CommentVM new];
            [model setViewModelData:comment];
            [ws.commentsNew addObject:model];
        }
        [self.tableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    _currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_vm.pageID) forKey:@"target_id"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        for (ATOMComment *comment in recentCommentArray) {
            CommentVM *model = [CommentVM new];
            [model setViewModelData:comment];
            [ws.commentsNew addObject:model];
        }
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
        if (recentCommentArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
    }];
}

#pragma mark - ATOMPSViewDelegate

- (void)dealImageWithCommand:(NSString *)command {
    if ([command isEqualToString:@"upload"]) {
        [self dealUploadWork];
    } else if ([command isEqualToString:@"download"]) {
        [self dealDownloadWork];
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
        uwvc.askPageViewModel = [ws.vm generateAskPageViewModel];
//        [ws pushViewController:uwvc animated:YES];
    }];
}

- (void)dealDownloadWork {
    UIImageWriteToSavedPhotosAlbum(_headerView.imageViewMain.image
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


#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"快来抢第一个坐上沙发";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
