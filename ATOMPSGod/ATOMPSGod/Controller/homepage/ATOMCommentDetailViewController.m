//
//  ATOMCommentDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDetailViewController.h"
#import "ATOMCommentDetailTableViewCell.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMCommentDetailView.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMMyConcernTableHeaderView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMCommentDetailViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ATOMCommentDetailView *commentDetailView;

@property (nonatomic, strong) UITapGestureRecognizer *tapCommentDetailGesture;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation ATOMCommentDetailViewController

#pragma mark - Lazy Initialize

#pragma mark Refresh

- (void)configCommentDetailTableViewRefresh {
    WS(ws);
    [_commentDetailView.commentDetailTableView addLegendHeaderWithRefreshingBlock:^{
        [ws loadNewHotData];
    }];
    [_commentDetailView.commentDetailTableView addLegendFooterWithRefreshingBlock:^{
        [ws loadMoreHotData];
    }];
}

- (void)loadNewHotData {
    WS(ws);
    [ws.commentDetailView.commentDetailTableView.header endRefreshing];
}

- (void)loadMoreHotData {
    WS(ws);
    [ws.commentDetailView.commentDetailTableView.footer endRefreshing];
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
    _dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
        if (i % 3 == 0) {
            model.userSex = @"man";
        }
        [_dataArray addObject:model];
    }
    [_commentDetailView.commentDetailTableView reloadData];
    
}

- (void)createUI {
    self.title = @"评论详情";
    _commentDetailView = [ATOMCommentDetailView new];
    self.view = _commentDetailView;
    [self configCommentDetailTableViewRefresh];
    _commentDetailView.commentDetailTableView.delegate = self;
    _commentDetailView.commentDetailTableView.dataSource = self;
    [_commentDetailView.sendCommentButton addTarget:self action:@selector(clickSendCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    _tapCommentDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentDetailGesture:)];
    [_commentDetailView.commentDetailTableView addGestureRecognizer:_tapCommentDetailGesture];
}

#pragma mark - Click Event

- (void)clickSendCommentButton:(UIButton *)sender {
    [_commentDetailView.sendCommentView resignFirstResponder];
    NSString *commentStr = _commentDetailView.sendCommentView.text;
    _commentDetailView.sendCommentView.text = @"";
    ATOMCommentDetailViewModel *model = [ATOMCommentDetailViewModel new];
    model.userCommentDetail = commentStr;
    [_dataArray insertObject:model atIndex:0];
    [_commentDetailView.commentDetailTableView reloadData];
    [_commentDetailView.commentDetailTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - Gesture Event

- (void)tapCommentDetailGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_commentDetailView.commentDetailTableView];
    NSIndexPath *indexPath = [_commentDetailView.commentDetailTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMCommentDetailTableViewCell *cell = (ATOMCommentDetailTableViewCell *)[_commentDetailView.commentDetailTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
            p = [gesture locationInView:cell.praiseButton];
            cell.praiseButton.selected = !cell.praiseButton.selected;
        } else if (CGRectContainsPoint(cell.userCommentDetailLabel.frame, p)) {
            if ([_commentDetailView.sendCommentView isFirstResponder]) {
                [_commentDetailView.sendCommentView resignFirstResponder];
            } else {
                [_commentDetailView.sendCommentView becomeFirstResponder];
                _commentDetailView.sendCommentView.text = @"@宋祥伍//";
            }
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
        return 2;
    } else if (section == 1) {
        return _dataArray.count;
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
    NSLog(@"current section is %d and current row is %d", (int)indexPath.section, (int)indexPath.row);
    cell.viewModel = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMCommentDetailTableViewCell calculateCellHeightWithModel:_dataArray[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ATOMMyConcernTableHeaderView *headerView = [ATOMMyConcernTableHeaderView new];
    headerView.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0xf80630];
        headerView.titleLabel.text = @"最热评论";
    } else if (section == 1) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0x00adef];
        headerView.titleLabel.text = @"最新评论";
    }
    return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}












@end
