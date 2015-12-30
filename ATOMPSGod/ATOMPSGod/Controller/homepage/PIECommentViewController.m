//
//  CommentViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "PIECommentViewController.h"
#import "PIECommentTableCell.h"
#import "PIECommentTextView.h"
#import "PIECommentVM.h"
#import "AppDelegate.h"
#import "PIEFriendViewController.h"
#import "PIECommentModel.h"
#import "PIECommentManager.h"
#import "PIEEntityCommentReply.h"
#import "PIECommentHeaderView.h"
#import "PIEShareView.h"
#import "PIEActionSheet_PS.h"
#import "DDCollectManager.h"
#import "PIEModelImage.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "KVCMutableArray.h"
#import "PIEReplyCollectionViewController.h"
#import "PIEPageManager.h"
#import "PIECellIconStatusChangedNotificationKey.h"

#define DEBUG_CUSTOM_TYPING_INDICATOR 0

static NSString *MessengerCellIdentifier = @"MessengerCell";

@interface PIECommentViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,PIEShareViewDelegate,JTSImageViewControllerInteractionsDelegate>

@property (nonatomic, strong) NSMutableArray *source_hotComment;
@property (nonatomic, strong) KVCMutableArray *source_newComment;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentTableGesture;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) PIECommentVM *targetCommentVM;
@property (nonatomic, strong) NSIndexPath *selectedIndexpath;
@property (nonatomic, strong) PIEShareView *shareView;
@property (nonatomic, strong)  PIEActionSheet_PS * psActionSheet;
@property (nonatomic, assign)  BOOL isFirstLoading;

@end

@implementation PIECommentViewController

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
    _shouldShowHeaderView = YES;
    _shouldDownloadVMSource = NO;
    
    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    [self registerClassForTextView:[PIECommentTextView class]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFirstLoading = YES;
    [self setupNavBar];
    
    [self setupNotificationObserver];
    
    [self configTableView];
    [self configFooterRefresh];
    [self configTextInput];
    [self addGestureToCommentTableView];
    [self getDataSource];
    if (_shouldDownloadVMSource && _shouldShowHeaderView) {
        [self getVMSource];
    }
}

- (void)setupNavBar {
    
    UIButton *buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [buttonLeft setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem =  buttonItem;

    if (self.navigationController.viewControllers.count <= 1) {
        [buttonLeft addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [buttonLeft addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateShareStatus:)
                                                 name:PIESharedIconStatusChangedNotification
                                               object:nil];
}

- (void) dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)popSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getVMSource {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@(_vm.ID) forKey:@"id"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];

    [PIEPageManager getPageSource:param block:^(PIEPageVM *remoteVM) {
        _vm = remoteVM;
        if (_vm.type == PIEPageTypeAsk) {
            self.headerView.vm = _vm;
        } else {
            self.headerView_reply.vm = _vm;
        }
        [self resizeHeaderView];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil
//                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

//    self.navigationController.hidesBarsOnSwipe = YES;
        [MobClick beginLogPageView:@"进入浏览图片页"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.hidesBarsOnSwipe = NO;
    //    [MobClick endLogPageView:@"离开浏览图片页"];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset < - 90) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)dealloc {
    if (_shouldShowHeaderView) {
        [self.source_newComment removeObserver:self forKeyPath:@"array"];
        [self removeKVO];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PIESharedIconStatusChangedNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFirstLoading&&!_shouldShowHeaderView) {
        [self.textView becomeFirstResponder];
        //        [self scrollElegant];
        _isFirstLoading = NO;
    }
    
    [self addKVO];

}
- (void)scrollElegant {
    
    [UIView animateWithDuration:0.7 animations:^{
        self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.frame.size.height - 52);
    } completion:^(BOOL finished) {
    }];
    
}
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

#pragma mark - Overriden Methods

//don't ignore babe --peiwei.
- (BOOL)ignoreTextInputbarAdjustment
{
    [super ignoreTextInputbarAdjustment];
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
    
    [self.textView resignFirstResponder];
    self.textView.placeholder = @"添加评论";
    
    PIECommentVM *commentVM = [PIECommentVM new];
    commentVM.username = [DDUserManager currentUser].nickname;
    commentVM.uid = [DDUserManager currentUser].uid;
    commentVM.avatar = [DDUserManager currentUser].avatar;
    commentVM.originText = self.textView.text;
    commentVM.time = @"刚刚";
//    NSString* commentToShow;
    //回复评论
    if (_targetCommentVM) {
        [commentVM.replyArray addObjectsFromArray:_targetCommentVM.replyArray];
//        //所要回复的评论只有一个回复人，也就是我要回复的评论已经有两个人。
//        if (commentVM.replyArray.count <= 1) {
//            commentToShow = [NSString stringWithFormat:@"%@//@%@:%@",self.textView.text,_targetCommentVM.username,_targetCommentVM.text];
//        }
//        //所要回复的评论多于一个回复人，也就是我要回复的评论已经多于两个人。
//        else {
//            PIEEntityCommentReply* reply1 = commentVM.replyArray[0];
//            commentToShow = [NSString stringWithFormat:@"%@//@%@:%@",self.textView.text,_targetCommentVM.username,_targetCommentVM.originText];
//            commentToShow = [NSString stringWithFormat:@"%@//@%@:%@",commentToShow,reply1.username,reply1.text];
//        }
        commentVM.text = self.textView.text;
        
        PIEEntityCommentReply* reply = [PIEEntityCommentReply new];
        reply.uid = _targetCommentVM.uid;
        reply.username = _targetCommentVM.username;
        reply.text = _targetCommentVM.originText;
        reply.ID = _targetCommentVM.ID;
        [commentVM.replyArray insertObject:reply atIndex:0];
    }
    //第一次评论
    else {
        commentVM.text  = self.textView.text;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.source_newComment insertObject:commentVM inArrayAtIndex:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    // Fixes the cell from blinking (because of the transform, when using translucent cells)
    // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.textView.text forKey:@"content"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(_vm.ID) forKey:@"target_id"];
    if (_targetCommentVM) {
        [param setObject:@(_targetCommentVM.ID) forKey:@"for_comment"];
    }
    PIECommentManager *showDetailOfComment = [PIECommentManager new];
    [showDetailOfComment SendComment:param withBlock:^(NSInteger comment_id, NSError *error) {
        if (comment_id) {
            commentVM.ID = comment_id;
            _vm.commentCount = [NSString stringWithFormat:@"%zd",[_vm.commentCount integerValue]+1];
        }
    }];
    self.textView.text = @"";
    _targetCommentVM = nil;
    
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
-(void)didPasteMediaContent:(NSDictionary *)userInfo {
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

-(void)didPressReturnKey:(id)sender {
    [self sendComment];
    [super didPressReturnKey:sender];
}



#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (section == 0) {
    //        return _commentsHot.count;
    //    } else if (section == 1) {
    return _source_newComment.array.count;
    //    } else {
    //        return 0;
    //    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView == tableView) {
        static NSString *CellIdentifier = @"CommentCell";
        PIECommentTableCell *cell = (PIECommentTableCell *)[self.tableView dequeueReusableCellWithIdentifier:MessengerCellIdentifier];
        if (!cell) {
            cell = [[PIECommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //        if (indexPath.section == 0) {
        //            [cell getSource:_commentsHot[indexPath.row]];
        //        } else if (indexPath.section == 1) {
        [cell getSource:_source_newComment.array[indexPath.row]];
        //        }
        // Cells must inherit the table view's transform
        // This is very important, since the main table view may be inverted
        //        cell.transform = self.tableView.transform;
        return cell;
    }
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        PIECommentVM* vm;
        //        if (indexPath.section == 0) {
        //            vm = _commentsHot[indexPath.row];
        //        } else if (indexPath.section == 1) {
        vm = _source_newComment.array[indexPath.row];
        //        }
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-kMessageTableViewCellAvatarHeight - kPadding15*3;
        
        CGRect titleBounds = [vm.username boundingRectWithSize:CGSizeMake(width-100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGRect bodyBounds = [vm.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        CGFloat height = CGRectGetHeight(titleBounds);
        height += CGRectGetHeight(bodyBounds);
        height += 30.0;
        
        if (height < kMessageTableViewCellMinimumHeight) {
            height = kMessageTableViewCellMinimumHeight;
        }
        
        return height;
    }
    return 0;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
//        return 0;
//    } else {
//        return kTableHeaderHeight;
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    PIECommentHeaderView *headerView = [PIECommentHeaderView new];
//    if (section == 0) {
//        headerView.titleLabel.text = @"最热评论";
//    } else if (section == 1) {
//        headerView.titleLabel.text = @"最新评论";
//    }
//    return headerView;
//}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    //    if (section == 0) {
    //        _targetCommentVM = _commentsHot[row];
    //    } else if (section == 1) {
//    _targetCommentVM = _source_newComment.array[row];
    //    }
//    self.textView.placeholder = [NSString stringWithFormat:@"@%@:",_targetCommentVM.username];
//    [self.textView becomeFirstResponder];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UIScrollViewDelegate Methods



#pragma mark init and config

-(void)configTableView {
    _source_hotComment = [NSMutableArray new];
    
    _source_newComment = [KVCMutableArray new];
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag|UIScrollViewKeyboardDismissModeInteractive;
    [self.tableView registerClass:[PIECommentTableCell class] forCellReuseIdentifier:MessengerCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    
    
    
    if (_shouldShowHeaderView) {
        self.title = @"浏览图片";
        if (_vm.type == PIEPageTypeAsk) {
            self.tableView.tableHeaderView = self.headerView;
        } else {
            self.tableView.tableHeaderView = self.headerView_reply;
        }
        [self resizeHeaderView];
        
        [self.source_newComment addObserver:self forKeyPath:@"array" options:NSKeyValueObservingOptionNew context:nil];
    } else {
        self.title = @"全部评论";
    }

}

- (void)resizeHeaderView {
    UIView *header = self.tableView.tableHeaderView;
    [header setNeedsLayout];
    [header layoutIfNeeded];
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = header.frame;
    frame = CGRectMake(0, 0, SCREEN_WIDTH, height);

    header.frame = frame;
    self.tableView.tableHeaderView = header;
}



-(void)configTextInput {
    self.bounces = NO;
    self.shakeToClearEnabled = NO;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = NO;
    //    [self.leftButton setImage:[UIImage imageNamed:@"btn_emoji"] forState:UIControlStateNormal];
    //    [self.rightButton setImage:[UIImage imageNamed:@"btn_comment_send"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 128;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    self.shouldClearTextAtRightButtonPress = YES;
}
- (void)configFooterRefresh {
    
    NSMutableArray *animatedImages = [NSMutableArray array];
    for (int i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pie_loading_%d", i]];
        [animatedImages addObject:image];
    }
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    
    [footer setImages:animatedImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
    
    _canRefreshFooter = NO;
}


#pragma mark - tap Event

- (void)tapCommentTable:(UITapGestureRecognizer *)gesture {
    
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        //        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        PIECommentTableCell *cell = (PIECommentTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        //        DDCommentVM *model = (section == 0) ? _commentsHot[row] : _source_newComment.array[row];
        PIECommentVM *model =  _source_newComment.array[row];
        
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.avatarView.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            PIEPageVM* vm = [PIEPageVM new];
            vm.userID = model.uid;
            vm.username = model.username;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        }
        else if (CGRectContainsPoint(cell.usernameLabel.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            PIEPageVM* vm = [PIEPageVM new];
            vm.userID = model.uid;
            vm.username = model.username;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.receiveNameLabel.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            opvc.uid = cell.receiveNameLabel.tag;
            [self.navigationController pushViewController:opvc animated:YES];
        } else {
            NSInteger row = indexPath.row;
            _targetCommentVM = _source_newComment.array[row];
            self.textView.placeholder = [NSString stringWithFormat:@"@%@:",_targetCommentVM.username];
            [self.textView becomeFirstResponder];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

    }
}


#pragma mark Refresh

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    
    _currentPage = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_vm.ID) forKey:@"target_id"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    
    PIECommentManager *commentManager = [PIECommentManager new];
    [commentManager ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        ws.source_newComment.array = recentCommentArray;
        ws.source_hotComment = hotCommentArray;
        
        if (recentCommentArray.count > 0) {
            _canRefreshFooter = YES;
        }
        [self.tableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    _currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_vm.ID) forKey:@"target_id"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    PIECommentManager *commentManager = [PIECommentManager new];
    [commentManager ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        [self.source_newComment willChangeValueForKey:@"array"];
        [ws.source_newComment addArrayObject: recentCommentArray];
        [self.source_newComment didChangeValueForKey:@"array"];
        [ws.source_hotComment addObjectsFromArray: hotCommentArray];
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (recentCommentArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
    }];
}


#pragma mark - DZNEmptyDataSetSource
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"快来抢第一个坐上沙发";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_shouldShowHeaderView;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}
#pragma mark - headerView

-(PIECommentTableHeaderView_Ask *)headerView {
    if (!_headerView) {
        _headerView = [PIECommentTableHeaderView_Ask new];
        _headerView.vm = _vm;
        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap1)];
        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap2)];
//        UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap3)];
//        UITapGestureRecognizer* tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap4)];
        
        UITapGestureRecognizer* tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap5)];
        UITapGestureRecognizer* tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHelp)];
        [_headerView.avatarView addGestureRecognizer:tap1];
        [_headerView.usernameLabel addGestureRecognizer:tap2];
//        [_headerView.imageViewMain addGestureRecognizer:tap3];
//        [_headerView.imageViewRight addGestureRecognizer:tap4];
        [_headerView.shareButton addGestureRecognizer:tap5];
        [_headerView.bangView addGestureRecognizer:tap6];
    }
    return _headerView;
}

#pragma mark - headerView

-(PIECommentTableHeaderView_Reply *)headerView_reply {
    if (!_headerView_reply) {
        _headerView_reply = [PIECommentTableHeaderView_Reply new];
        _headerView_reply.vm = _vm;
        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap1)];
        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap2)];
        UITapGestureRecognizer* tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap5)];
        UITapGestureRecognizer* tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAllWorkButton)];
        UITapGestureRecognizer* tap7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapLike)];
        UILongPressGestureRecognizer* longpress7 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongpressLike)];
        [_headerView_reply.avatarView addGestureRecognizer:tap1];
        [_headerView_reply.usernameLabel addGestureRecognizer:tap2];
        [_headerView_reply.shareButton addGestureRecognizer:tap5];
        [_headerView_reply.likeButton addGestureRecognizer:longpress7];
        [_headerView_reply.likeButton addGestureRecognizer:tap7];
        [_headerView_reply.moreWorkButton addGestureRecognizer:tap6];
    }
    return _headerView_reply;
}

- (void) didTapAllWorkButton {
    PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
    vc.pageVM = _vm;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) didTap1 {
    PIEFriendViewController *opvc = [PIEFriendViewController new];
    opvc.pageVM = _vm;
    [self.navigationController pushViewController:opvc animated:YES];
}
- (void) didTap2 {
    PIEFriendViewController *opvc = [PIEFriendViewController new];
    opvc.pageVM = _vm;
    [self.navigationController pushViewController:opvc animated:YES];
}
- (void) didTap3 {
    [self.textView resignFirstResponder];
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (_headerView.imageViewMain.image != nil) {
        imageInfo.image = _headerView.imageViewMain.image;
    } else {
        imageInfo.imageURL = [NSURL URLWithString:_vm.imageURL];
    }
    //    imageInfo.referenceRect = _selectedHotDetailCell.userHeaderButton.frame;
    //    imageInfo.referenceView = _selectedHotDetailCell.userHeaderButton;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
    imageViewer.interactionsDelegate = self;
}
- (void) didTap4 {
    [self.textView resignFirstResponder];
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (_headerView.imageViewMain.image != nil) {
//        imageInfo.image = _headerView.imageViewRight.image;
    } else {
        if (_vm.models_image.count >= 2) {
            PIEModelImage* imgEntity = _vm.models_image[1];
            imageInfo.imageURL = [NSURL URLWithString:imgEntity.url];
        }
    }
    //    imageInfo.referenceRect = _selectedHotDetailCell.userHeaderButton.frame;
    //    imageInfo.referenceView = _selectedHotDetailCell.userHeaderButton;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
    imageViewer.interactionsDelegate = self;
}
- (void) didTap5 {
    [self.textView resignFirstResponder];

    [self showShareView:_vm];
}
- (void) didTapHelp {
    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
}
- (void) didTapLike {
    
//    [PIEPageManager love:_headerView_reply.likeButton viewModel:_vm revert:NO];
    [_vm love:NO];
}
- (void) didLongpressLike {
    
//    [PIEPageManager love:_headerView_reply.likeButton viewModel:_vm revert:YES];
    [_vm love:YES];
}

#pragma mark - <PIEShareViewDelegate>

- (void)shareViewDidShare:(PIEShareView *)shareView
{
    // refresh ui element on main thread after successful sharing, do nothing otherwise.
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self updateShareStatus];
//    }];
}

- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}


#pragma mark - Gesture methods
- (void)addGestureToCommentTableView {
    _tapCommentTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentTable:)];
    _tapCommentTableGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:_tapCommentTableGesture];
}
- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
}
-(void)collect {
    NSMutableDictionary *param = [NSMutableDictionary new];
    _vm.collected = !_vm.collected;
    if (_vm.collected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:_vm.type withID:_vm.ID  withBlock:^(NSError *error) {
        if (!error) {
            if (  _vm.collected ) {
                [Hud textWithLightBackground:@"收藏成功"];
            } else {
                [Hud textWithLightBackground:@"取消收藏成功"];
            }
        }   else {
            _vm.collected = !_vm.collected;
        }
    }];
}
- (PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
        _psActionSheet.vm = _vm;
    }
    return _psActionSheet;
}

-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}


#pragma mark - Notification methods
/**
 *  用户点击了updateShareStatus之后（在弹出的窗口分享），刷新本页面ReplyCell的分享数
 */
- (void)updateShareStatus:(NSNotification *)notification
{
    /*
     _vm.shareCount ++ 这个副作用集中发生在PIEShareView之中。
     
     */
    
    //    /*??? 分享结束之后没有刷新UI，reload tableView之类的*/
    //    _vm.shareCount = [NSString stringWithFormat:@"%zd",[_vm.shareCount integerValue]+1];
    
    NSString *numberString = notification.userInfo[PIESharedIconSharedCountKey];
   
    if (_vm.type == PIEPageTypeAsk && _headerView != nil) {
        _headerView.shareButton.numberString = numberString;
    }
    else if (_vm.type == PIEPageTypeReply && _headerView_reply != nil){
        _headerView_reply.shareButton.numberString = numberString;
    }
    else{
        /* nothing happened. */
    }
    
}



- (void)addKVO {
    if (_shouldShowHeaderView) {
        [_vm addObserver:self forKeyPath:@"lovedCount" options:NSKeyValueObservingOptionNew context:NULL];
        [_vm addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionNew context:NULL];
    }
}
- (void)removeKVO {
    @try{
        [_vm removeObserver:self forKeyPath:@"lovedCount"];
        [_vm removeObserver:self forKeyPath:@"likeCount"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"lovedCount"]) {
        NSInteger newLovedCount = [[change objectForKey:@"new"]integerValue];
        self.headerView_reply.likeButton.status = newLovedCount;
    } else     if ([keyPath isEqualToString:@"likeCount"]) {
        NSInteger newLikeCount = [[change objectForKey:@"new"]integerValue];
        self.headerView_reply.likeButton.number = newLikeCount;
    } else     if ([keyPath isEqualToString:@"array"]) {
        
        if (_vm.type == PIEPageTypeAsk) {
            ((PIECommentTableHeaderView_Ask*)self.tableView.tableHeaderView).commentButton.number = _source_newComment.countOfArray;
        }    else    if (_vm.type == PIEPageTypeReply) {
            ((PIECommentTableHeaderView_Reply*)self.tableView.tableHeaderView).commentButton.number = _source_newComment.countOfArray;
        }
    }

}


@end
