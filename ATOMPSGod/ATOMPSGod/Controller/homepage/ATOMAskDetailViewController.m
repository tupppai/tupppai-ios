//
//  ATOMAskDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AppDelegate.h"
#import "ATOMAskDetailViewController.h"
#import "ATOMAskDetailView.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMAskDetailTableViewCell.h"
#import "ATOMMyConcernTableHeaderView.h"
#import "ATOMAskDetailHeaderView.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMComment.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMShowDetailOfComment.h"
#import "ATOMShareFunctionView.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMPSView.h"
#import "ATOMPraiseButton.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMAskDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, ATOMPSViewDelegate>

@property (nonatomic, strong) ATOMAskDetailView *askDetailView;
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
@property (nonatomic, strong) ATOMPSView *psView;

@end

@implementation ATOMAskDetailViewController

#pragma mark - Lazy Initialize

- (ATOMShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [ATOMShareFunctionView new];
        [_shareFunctionView.wxButton addTarget:self action:@selector(clickWXButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (ATOMPSView *)psView {
    if (!_psView) {
        _psView = [ATOMPSView new];
        _psView.delegate = self;
    }
    return _psView;
}

#pragma mark Refresh

- (void)configRecentDetailTableViewRefresh {
    [_askDetailView.recentDetailTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    NSLog(@"%@ param",param);
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
    NSInteger type = _homePageViewModel!=nil? 1:2;
    NSInteger ID = _homePageViewModel!=nil? _homePageViewModel.imageID:_detailImageViewModel.ID;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(ID) forKey:@"target_id"];
    [param setObject:@(type) forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        for (ATOMComment *comment in recentCommentArray) {
            ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
            [model setViewModelData:comment];
            [ws.recentCommentDataSource addObject:model];
        }
        if (recentCommentArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.askDetailView.recentDetailTableView reloadData];
        [ws.askDetailView.recentDetailTableView.footer endRefreshing];
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
}

- (void)createUI {
    self.title = @"详情";
    _askDetailView = [ATOMAskDetailView new];
    self.view = _askDetailView;
    if (_homePageViewModel) {
        _type = 1;
        _ID = _homePageViewModel.imageID;
        _askDetailView.viewModel = _homePageViewModel;
    } else if (_detailImageViewModel) {
        _askDetailView.detailImageViewModel = _detailImageViewModel;
        _type = 2;
        _ID = _detailImageViewModel.ID;
    }
    _askDetailView.commentTextView.delegate = self;
    _askDetailView.recentDetailTableView.delegate = self;
    _askDetailView.recentDetailTableView.dataSource = self;
    [self addClickEventToAskDetailView];
    [self addGestureEventToAskDetailView];
    [self configRecentDetailTableViewRefresh];
    _canRefreshFooter = YES;
    _askDetailView.headerView.praiseButton.selected = _homePageViewModel.liked;
    [self getDataSource];
}

- (void)addClickEventToAskDetailView {
    UITapGestureRecognizer *g1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShareButton:)];
    [_askDetailView.headerView.shareButton addGestureRecognizer:g1];
    UITapGestureRecognizer *g2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMoreShareButton:)];
    [_askDetailView.headerView.moreShareButton addGestureRecognizer:g2];
    UITapGestureRecognizer *g3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPraiseButton:)];
    [_askDetailView.headerView.praiseButton addGestureRecognizer:g3];
//    UITapGestureRecognizer *g4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCommentButton:)];
//    [_askDetailView.headerView.commentButton addGestureRecognizer:g4];
    
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
    [self wxShare];
}

- (void)clickMoreShareButton:(UITapGestureRecognizer *)sender {
    [[AppDelegate APP].window addSubview:self.shareFunctionView];
}

- (void)clickUserHeaderButton:(UIButton *)sender {
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    [self pushViewController:opvc animated:YES];
}

- (void)clickPSButton:(UIButton *)sender {
    [[AppDelegate APP].window addSubview:self.psView];
}

- (void)clickPraiseButton:(UITapGestureRecognizer *)sender {
    [_askDetailView.headerView.praiseButton toggleApperance];
    if (_homePageViewModel) {
        [_homePageViewModel toggleLike];
    } else {
        [_detailImageViewModel toggleLike];
    }
}

//- (void)clickCommentButton:(UITapGestureRecognizer *)sender {
//    ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
//    cdvc.ID = _homePageViewModel.imageID;
//    cdvc.type = 1;
//    [self pushViewController:cdvc animated:YES];
//}

- (void)clickSendCommentButton:(UIButton *)sender {
//    [_askDetailView.commentTextView resignFirstResponder];
    NSString *commentStr = _askDetailView.commentTextView.text;
    _askDetailView.commentTextView.text = @"";
    [_askDetailView toggleSendCommentView];
    ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
    [model setDataWithAtModel:_atModel andContent:commentStr];
    [_recentCommentDataSource insertObject:model atIndex:0];
    [_askDetailView.recentDetailTableView reloadData];
    [_askDetailView.recentDetailTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
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
    
}

- (void)dealUploadWork {
    [[NSUserDefaults standardUserDefaults] setObject:@"Uploading" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

- (void)clickWXButton:(UIButton *)sender {
    [self wxFriendShare];
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
        ATOMAskDetailTableViewCell *cell = (ATOMAskDetailTableViewCell *)[_askDetailView.recentDetailTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
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
            [cell.praiseButton toggleApperance];
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
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    [self pushViewController:opvc animated:YES];
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
        uwvc.homePageViewModel = ws.homePageViewModel;
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
    static NSString *CellIdentifier = @"RecentDetailCell";
    ATOMAskDetailTableViewCell *cell = [_askDetailView.recentDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMAskDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.viewModel = _hotCommentDataSource[indexPath.row];
    } else if (indexPath.section ==1) {
        cell.viewModel = _recentCommentDataSource[indexPath.row];
    }
    return cell;
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
        return [ATOMAskDetailTableViewCell calculateCellHeightWithModel:_hotCommentDataSource[indexPath.row]];
    } else if (section == 1) {
        return [ATOMAskDetailTableViewCell calculateCellHeightWithModel:_recentCommentDataSource[indexPath.row]];
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
