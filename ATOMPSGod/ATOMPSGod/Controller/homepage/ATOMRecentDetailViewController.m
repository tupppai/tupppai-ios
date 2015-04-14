//
//  ATOMRecentDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMRecentDetailViewController.h"
#import "ATOMRecentDetailView.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMRecentDetailTableViewCell.h"
#import "ATOMMyConcernTableHeaderView.h"
#import "ATOMRecentDetailHeaderView.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMComment.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMShowDetailOfComment.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMRecentDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) ATOMRecentDetailView *recentDetailView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray *hotCommentDataSource;
@property (nonatomic, strong) NSMutableArray *recentCommentDataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITapGestureRecognizer *tapUserNameLabelGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentDetailGesture;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) ATOMCommentDetailViewModel *atModel;

@end

@implementation ATOMRecentDetailViewController

#pragma mark - Lazy Initialize

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark Refresh

- (void)configRecentDetailTableViewRefresh {
    [_recentDetailView.recentDetailTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData {
    [self getMoreDataSource];
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
    [param setObject:@(_homePageViewModel.imageID) forKey:@"id"];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        [SVProgressHUD dismiss];
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
        [ws.recentDetailView.recentDetailTableView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    _currentPage++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_homePageViewModel.imageID) forKey:@"id"];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showDetailOfComment ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        [SVProgressHUD dismiss];
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
        [ws.recentDetailView.recentDetailTableView reloadData];
        [ws.recentDetailView.recentDetailTableView.footer endRefreshing];
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
    _recentDetailView = [ATOMRecentDetailView new];
    self.view = _recentDetailView;
    _recentDetailView.viewModel = _homePageViewModel;
    _recentDetailView.sendCommentView.delegate = self;
    _recentDetailView.recentDetailTableView.delegate = self;
    _recentDetailView.recentDetailTableView.dataSource = self;
    [self addClickEventToRecentDetailView];
    [self addGestureEventToRecentDetailView];
    [self configRecentDetailTableViewRefresh];
    _canRefreshFooter = YES;
    [self getDataSource];
}

- (void)addClickEventToRecentDetailView {
    [_recentDetailView.headerView.userHeaderButton addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentDetailView.headerView.psButton addTarget:self action:@selector(clickPSButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentDetailView.headerView.praiseButton addTarget:self action:@selector(clickPraiseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentDetailView.headerView.commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recentDetailView.sendCommentButton addTarget:self action:@selector(clickSendCommentButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addGestureEventToRecentDetailView {
    _tapCommentDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentDetailGesture:)];
    [_recentDetailView.recentDetailTableView addGestureRecognizer:_tapCommentDetailGesture];
    _tapUserNameLabelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserNameLabelGesture:)];
    [_recentDetailView.headerView.userNameLabel addGestureRecognizer:_tapUserNameLabelGesture];
}

#pragma mark - Click Event

- (void)clickUserHeaderButton:(UIButton *)sender {
    ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
    [self pushViewController:opvc animated:YES];
}

- (void)clickPSButton:(UIButton *)sender {
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"下载素材",@"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString *actionSheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([actionSheetTitle isEqualToString:@"下载素材"]) {
            [self dealDownloadWork];
        } else if ([actionSheetTitle isEqualToString:@"上传作品"]) {
            [self dealUploadWork];
        }
    }];
}

- (void)clickPraiseButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)clickCommentButton:(UIButton *)sender {
    ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
    cdvc.ID = _homePageViewModel.imageID;
    cdvc.type = @"ask";
    [self pushViewController:cdvc animated:YES];
}

- (void)clickSendCommentButton:(UIButton *)sender {
    [_recentDetailView.sendCommentView resignFirstResponder];
    NSString *commentStr = _recentDetailView.sendCommentView.text;
    _recentDetailView.sendCommentView.text = @"";
    ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
    [model setDataWithAtModel:_atModel andContent:commentStr];
    [_recentCommentDataSource insertObject:model atIndex:0];
    [_recentDetailView.recentDetailTableView reloadData];
    [_recentDetailView.recentDetailTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:commentStr forKey:@"content"];
    [param setObject:@"ask" forKey:@"comment_type"];
    [param setObject:@(_homePageViewModel.imageID) forKey:@"comment_target_id"];
    if (_atModel) {
        [param setObject:@(_atModel.comment_id) forKey:@"comment_reply_to"];
    }
    ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
    [showDetailOfComment SendComment:param withBlock:^(NSInteger comment_id, NSError *error) {
        model.comment_id = comment_id;
    }];
    _atModel = nil;
}

- (void)dealDownloadWork {
    
}

- (void)dealUploadWork {
    [[NSUserDefaults standardUserDefaults] setObject:@"Uploading" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

#pragma mark - Gesture Event

- (void)tapCommentDetailGesture:(UITapGestureRecognizer *)gesture {
    if ([_recentDetailView.sendCommentView isFirstResponder]) {
        [_recentDetailView.sendCommentView resignFirstResponder];
        _recentDetailView.sendCommentView.text = @"";
        _atModel = nil;
        return ;
    }
    CGPoint location = [gesture locationInView:_recentDetailView.recentDetailTableView];
    NSIndexPath *indexPath = [_recentDetailView.recentDetailTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMRecentDetailTableViewCell *cell = (ATOMRecentDetailTableViewCell *)[_recentDetailView.recentDetailTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
            p = [gesture locationInView:cell.praiseButton];
            NSInteger section = indexPath.section;
            NSInteger row = indexPath.row;
            ATOMCommentDetailViewModel *model = (section == 0) ? _hotCommentDataSource[row] : _recentCommentDataSource[row];
            if (!model.isPraise) {
                cell.praiseButton.selected = !cell.praiseButton.selected;
                [model increasePraiseNumber];
                ATOMShowDetailOfComment *showDetailOfComment = [ATOMShowDetailOfComment new];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:@(model.comment_id) forKey:@"cid"];
                [showDetailOfComment PraiseComment:param withBlock:^(NSError *error) {
                    if (!error) {
                        NSLog(@"praise");
                    }
                }];
            }
            [_recentDetailView.recentDetailTableView reloadData];
        } else if (CGRectContainsPoint(cell.userCommentDetailLabel.frame, p)) {
            [_recentDetailView.sendCommentView becomeFirstResponder];
            NSInteger section = indexPath.section;
            NSInteger row = indexPath.row;
            if (section == 0) {
                _atModel = _hotCommentDataSource[row];
            } else if (section == 1) {
                _atModel = _recentCommentDataSource[row];
            }
            _recentDetailView.textViewPlaceholder = [NSString stringWithFormat:@"//@%@:", _atModel.nickname];
            _recentDetailView.sendCommentView.text = _recentDetailView.textViewPlaceholder;
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
    ATOMRecentDetailTableViewCell *cell = [_recentDetailView.recentDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMRecentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    return 28.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return [ATOMRecentDetailTableViewCell calculateCellHeightWithModel:_hotCommentDataSource[indexPath.row]];
    } else if (section == 1) {
        return [ATOMRecentDetailTableViewCell calculateCellHeightWithModel:_recentCommentDataSource[indexPath.row]];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ATOMMyConcernTableHeaderView *headerView = [ATOMMyConcernTableHeaderView new];
    if (section == 0) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0xf80630];
        headerView.titleLabel.text = @"最热评论";
    } else if (section == 1) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0x00adef];
        headerView.titleLabel.text = @"最新评论";
    }
    return headerView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:_recentDetailView.textViewPlaceholder]) {
        textView.text = @"";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *str = textView.text;
    if (str.length == 0) {
        if (_atModel) {
            textView.text = _recentDetailView.textViewPlaceholder;
        }
    } else {
        if (_atModel && [str hasPrefix:[NSString stringWithFormat:@"//@%@:", _atModel.nickname]]) {
            textView.text = [str substringFromIndex:(_atModel.nickname.length + 4)];
        }
    }
}









































@end
