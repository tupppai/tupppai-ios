//
//  ATOMCommentDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDetailViewController.h"
#import "ATOMCommentDetailTableViewCell.h"
#import "CommentVM.h"
#import "ATOMCommentDetailView.h"
#import "ATOMOtherPersonViewController.h"
#import "ZZCommentHeaderView.h"
#import "ATOMShowDetailOfComment.h"
#import "CommentVM.h"
#import "ATOMComment.h"
#import "CommentLikeButton.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMCommentDetailViewController() <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,PWRefreshBaseTableViewDelegate>

@property (nonatomic, strong) ATOMCommentDetailView *commentDetailView;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentDetailGesture;
@property (nonatomic, strong) NSMutableArray *hotCommentDataSource;
@property (nonatomic, strong) NSMutableArray *recentCommentDataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) CommentVM *atModel;

@end

@implementation ATOMCommentDetailViewController

#pragma mark PWRefreshBaseTableViewDelegate

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self loadNewData];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    [self loadMoreData];
}
- (void)loadNewData {
    [self getDataSource];
}

- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_commentDetailView.commentDetailTableView.footer endRefreshing];
    }
}

#pragma mark - GetDataSource

- (void)firstGetDataSource {
    
}

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
        NSLog(@"param%@hotCommentArray%@RCommentArray%@",param,hotCommentArray,recentCommentArray);
        for (ATOMComment *comment in hotCommentArray) {
            CommentVM *model = [CommentVM new];
            [model setViewModelData:comment];
            [ws.hotCommentDataSource addObject:model];
        }
        for (ATOMComment *comment in recentCommentArray) {
            CommentVM *model = [CommentVM new];
            [model setViewModelData:comment];
            [ws.recentCommentDataSource addObject:model];
        }
        [ws.commentDetailView.commentDetailTableView reloadData];
        [ws.commentDetailView.commentDetailTableView.header endRefreshing];
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
            CommentVM *model = [CommentVM new];
            [model setViewModelData:comment];
            [ws.recentCommentDataSource addObject:model];
        }
        if (recentCommentArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.commentDetailView.commentDetailTableView reloadData];
        [ws.commentDetailView.commentDetailTableView.footer endRefreshing];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    _atModel = nil;
}

- (void)createUI {
    self.title = @"评论详情";
    _commentDetailView = [ATOMCommentDetailView new];
    self.view = _commentDetailView;
    _commentDetailView.commentDetailTableView.psDelegate = self;
    _commentDetailView.commentDetailTableView.delegate = self;
    _commentDetailView.commentDetailTableView.dataSource = self;
    _commentDetailView.commentTextView.delegate = self;
    [_commentDetailView.sendCommentButton addTarget:self action:@selector(clickSendCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    _tapCommentDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentDetailGesture:)];
    [_commentDetailView.commentDetailTableView addGestureRecognizer:_tapCommentDetailGesture];
    _canRefreshFooter = YES;
    [self getDataSource];
}

#pragma mark - Click Event

- (void)clickSendCommentButton:(UIButton *)sender {
    [_commentDetailView hideCommentView];
    NSString *commentStr = _commentDetailView.commentText;
    CommentVM *model = [CommentVM new];
    [model setDataWithAtModel:_atModel andContent:commentStr];
    [_recentCommentDataSource insertObject:model atIndex:0];
    [_commentDetailView.commentDetailTableView reloadData];
    [_commentDetailView.commentDetailTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:commentStr forKey:@"content"];
    [param setObject:@(_type) forKey:@"type"];
    [param setObject:@(_ID) forKey:@"target_id"];
    [param setObject:@(0) forKey:@"for_comment"];

    NSLog(@"content%@,type%ld,target_id%ld \n param %@",commentStr,(long)_type,(long)_ID,param);
    
    if (_atModel) {
        [param setObject:@(_atModel.ID) forKey:@"reply_to"];
    }
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment SendComment:param withBlock:^(NSInteger comment_id, NSError *error) {
        NSLog(@"comment id %ld ,error %@",(long)comment_id,error);
        model.ID = comment_id;
    }];
    _atModel = nil;
}

#pragma mark - Gesture Event

- (void)tapCommentDetailGesture:(UITapGestureRecognizer *)gesture {
    if ([_commentDetailView isEditingCommentView]) {
        [_commentDetailView hideCommentView];
//        _commentDetailView.commentTextView.text = @"";
        _atModel = nil;
        return ;
    }
    CGPoint location = [gesture locationInView:_commentDetailView.commentDetailTableView];
    NSIndexPath *indexPath = [_commentDetailView.commentDetailTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        CommentVM *model = (indexPath.section == 0) ? _hotCommentDataSource[indexPath.row] : _recentCommentDataSource[indexPath.row];
        ATOMCommentDetailTableViewCell *cell = (ATOMCommentDetailTableViewCell *)[_commentDetailView.commentDetailTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = model.uid;
            opvc.userName = model.username;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = model.uid;
            opvc.userName = model.username;
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.likeButton.frame, p)) {
            //UI 颜色和数字
            [cell.likeButton toggleLike];
            //Network,点赞，取消赞
            [model toggleLike];
        } else if (CGRectContainsPoint(cell.userCommentDetailLabel.frame, p)) {
            _atModel = model;
//            _commentDetailView.textViewPlaceholder = [NSString stringWithFormat:@"//@%@:", _atModel.nickname];
//            _commentDetailView.commentTextView.text = _commentDetailView.textViewPlaceholder;
        }
        
    }
}

#pragma mark - UIImagePickerControllerDelegate


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
    static NSString *CellIdentifier = @"HotDetailCell";
    ATOMCommentDetailTableViewCell *cell = [_commentDetailView.commentDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMCommentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.viewModel = _hotCommentDataSource[indexPath.row];
    } else if (indexPath.section ==1) {
        cell.viewModel = _recentCommentDataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return [ATOMCommentDetailTableViewCell calculateCellHeightWithModel:_hotCommentDataSource[indexPath.row]];
    } else if (section == 1) {
        return [ATOMCommentDetailTableViewCell calculateCellHeightWithModel:_recentCommentDataSource[indexPath.row]];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return kCommentTableViewHeaderHeight;
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

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
//    if ([textView.text isEqualToString:_commentDetailView.textViewPlaceholder]) {
//        textView.text = @"";
//    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
}
- (void)textViewDidChange:(UITextView *)textView {
//    NSString *str= textView.text;
//    if (textView.text.length == 0) {
//        if (_atModel) {
//            textView.text = _commentDetailView.textViewPlaceholder;
//        } else {
//            textView.text = @"发表你的神回复...";
//        }
//    } else {
//        if (_atModel && [str hasPrefix:[NSString stringWithFormat:@"//@%@:", _atModel.nickname]]) {
//            textView.text = [str substringFromIndex:(_atModel.nickname.length + 4)];
//        } else if (!_atModel && [str hasPrefix:_commentDetailView.textViewPlaceholder]) {
//            textView.text = [str substringFromIndex:10];
//        }
//    }
}

//限制 kCommentTextViewMaxLength字数
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _commentDetailView.commentTextView) {
        NSString *newText = [ textView.text stringByReplacingCharactersInRange: range withString: text ];
        if( [newText length]<= kCommentTextViewMaxLength ){
            return YES;
        }
        // case where text length > MAX_LENGTH
        textView.text = [ newText substringToIndex: kCommentTextViewMaxLength ];
        return NO;
    }
    return YES;
}






@end
