//
//  CommentViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "DDCommentVC.h"
#import "DDCommentTableCell.h"
#import "DDCommentTextView.h"
#import "DDCommentVM.h"
#import "AppDelegate.h"
#import "CommentCell.h"
#import "PIEFriendViewController.h"
#import "ATOMComment.h"
#import "DDCommentManager.h"
#import "CommentLikeButton.h"
#import "DDCommentReplyVM.h"
#import "DDCommentHeaderView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

#define DEBUG_CUSTOM_TYPING_INDICATOR 0

static NSString *MessengerCellIdentifier = @"MessengerCell";

@interface DDCommentVC ()<DZNEmptyDataSetSource>

@property (nonatomic, strong) NSMutableArray *commentsHot;
@property (nonatomic, strong) NSMutableArray *commentsNew;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentTableGesture;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) DDCommentVM *targetCommentVM;
@property (nonatomic, strong) NSIndexPath *selectedIndexpath;

@end

@implementation DDCommentVC

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
    [self registerClassForTextView:[DDCommentTextView class]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTableView];
    [self configFooterRefresh];
    [self configTextInput];
    [self addGestureToCommentTableView];
    [self getDataSource];
    [self.textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

#pragma mark - Overriden Methods

//don't ignore babe --peiwei.
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
    
    [self.textView resignFirstResponder];
    self.textView.placeholder = @"发布你的神回复..";
    
    DDCommentVM *commentVM = [DDCommentVM new];
    commentVM.username = [DDUserManager currentUser].username;
    commentVM.uid = [DDUserManager currentUser].uid;
    commentVM.avatar = [DDUserManager currentUser].avatar;
    commentVM.originText = self.textView.text;
    NSString* commentToShow;
    //回复评论
    if (_targetCommentVM) {
        [commentVM.replyArray addObjectsFromArray:_targetCommentVM.replyArray];
        //所要回复的评论只有一个回复人，也就是我要回复的评论已经有两个人。
        if (commentVM.replyArray.count <= 1) {
            commentToShow = [NSString stringWithFormat:@"%@//@%@:%@",self.textView.text,_targetCommentVM.username,_targetCommentVM.text];
        }
        //所要回复的评论多于一个回复人，也就是我要回复的评论已经多于两个人。
        else {
            DDCommentReplyVM* reply1 = commentVM.replyArray[0];
            commentToShow = [NSString stringWithFormat:@"%@//@%@:%@",self.textView.text,_targetCommentVM.username,_targetCommentVM.originText];
            commentToShow = [NSString stringWithFormat:@"%@//@%@:%@",commentToShow,reply1.username,reply1.text];
        }
        commentVM.text = commentToShow;

        DDCommentReplyVM* reply = [DDCommentReplyVM new];
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

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView beginUpdates];
    [self.commentsNew insertObject:commentVM atIndex:0];
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
    DDCommentManager *showDetailOfComment = [DDCommentManager new];
    [showDetailOfComment SendComment:param withBlock:^(NSInteger comment_id, NSError *error) {
        commentVM.ID = comment_id;
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
        DDCommentTableCell *cell = (DDCommentTableCell *)[self.tableView dequeueReusableCellWithIdentifier:MessengerCellIdentifier];
        if (!cell) {
            cell = [[DDCommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.section == 0) {
            [cell getSource:_commentsHot[indexPath.row]];
        } else if (indexPath.section == 1) {
            [cell getSource:_commentsNew[indexPath.row]];
        }
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
        DDCommentVM* vm;
        if (indexPath.section == 0) {
            vm = _commentsHot[indexPath.row];
        } else if (indexPath.section == 1) {
            vm = _commentsNew[indexPath.row];
        }
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-kMessageTableViewCellAvatarHeight - kPadding15*3;
        
        CGRect titleBounds = [vm.username boundingRectWithSize:CGSizeMake(width-100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGRect bodyBounds = [vm.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        if (vm.text.length == 0) {
            return 0.0;
        }
        
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


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return kTableHeaderHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DDCommentHeaderView *headerView = [DDCommentHeaderView new];
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
        _targetCommentVM = _commentsHot[row];
    } else if (section == 1) {
        _targetCommentVM = _commentsNew[row];
    }
    self.textView.placeholder = [NSString stringWithFormat:@"回复@%@:",_targetCommentVM.username];
    [self.textView becomeFirstResponder];
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



#pragma mark init and config

-(void)configTableView {
//    _headerView = [kfcPageView new];
//    _headerView.vm = _vm;
//    self.tableView.tableHeaderView = _headerView;
    self.tableView.emptyDataSetSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[DDCommentTableCell class] forCellReuseIdentifier:MessengerCellIdentifier];
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
    
//    UIButton* dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32,32)];
//    [dismissBtn setImage:[UIImage imageNamed:@"ic_dismiss"] forState:UIControlStateNormal];
//    dismissBtn.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.7];
//    [dismissBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:dismissBtn];
//    [self.view bringSubviewToFront:dismissBtn];
}
- (void) dismissSelf {
    [self dismissViewControllerAnimated:NO completion:nil];
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
    _canRefreshFooter = NO;
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
        DDCommentTableCell *cell = (DDCommentTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        DDCommentVM *model = (section == 0) ? _commentsHot[row] : _commentsNew[row];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.avatarView.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            DDPageVM* vm = [DDPageVM new];
            vm.userID = model.uid;
            vm.username = model.username;
            opvc.pageVM = vm;
            [self.navigationController pushViewController:opvc animated:YES];
        }
//        else if (CGRectContainsPoint(cell.usernameLabel.frame, p)) {
//            //ATOMOtherPersonViewControlle *opvc = [//ATOMOtherPersonViewControlle new];
//            opvc.userID = model.uid;
//            opvc.userName = model.username;
//            [self.navigationController pushViewController:opvc animated:YES];
//        }
        else if (CGRectContainsPoint(cell.likeButton.frame, p)) {
            //UI
            [cell.likeButton toggleLike];
            //Network
            [model toggleLike];

    }
}
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
    [param setObject:@(_vm.ID) forKey:@"target_id"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    
    DDCommentManager *showDetailOfComment = [DDCommentManager new];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        for (ATOMComment *comment in hotCommentArray) {
            DDCommentVM *model = [DDCommentVM new];
            [model setViewModelData:comment];
            [ws.commentsHot addObject:model];
        }
        for (ATOMComment *comment in recentCommentArray) {
            DDCommentVM *model = [DDCommentVM new];
            [model setViewModelData:comment];
            [ws.commentsNew addObject:model];
        }
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
    DDCommentManager *showDetailOfComment = [DDCommentManager new];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        for (ATOMComment *comment in recentCommentArray) {
            DDCommentVM *model = [DDCommentVM new];
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


#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"快来抢第一个坐上沙发";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
