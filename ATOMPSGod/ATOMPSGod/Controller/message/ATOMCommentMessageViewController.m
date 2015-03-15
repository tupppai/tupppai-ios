//
//  ATOMCommentMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentMessageViewController.h"
#import "ATOMCommentMessageViewModel.h"
#import "ATOMCommentMessageTableViewCell.h"
#import "ATOMNoDataView.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMOtherPersonViewController.h"

@interface ATOMCommentMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *commentMessageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ATOMNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapCommentMessageGesture;

@end

@implementation ATOMCommentMessageViewController

#pragma mark - Lazy Initialize

- (ATOMNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [ATOMNoDataView new];
    }
    return _noDataView;
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        ATOMCommentMessageViewModel *model = [ATOMCommentMessageViewModel new];
        [_dataSource addObject:model];
    }
    [_tableView reloadData];
}

- (void)createUI {
    self.title = @"评论";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _commentMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _commentMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_commentMessageView.bounds];
    _tableView.tableFooterView = [UIView new];
    [_commentMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tapCommentMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentMessageGesture:)];
    [_tableView addGestureRecognizer:_tapCommentMessageGesture];
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    [_dataSource removeAllObjects];
    if (_dataSource.count == 0) {
        self.view = self.noDataView;
    }
}

#pragma mark - Gesture Event

- (void)tapCommentMessageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMCommentMessageTableViewCell *cell = (ATOMCommentMessageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.workImageView.frame, p)) {
//            NSLog(@"Click userWorkImageView");
            ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
            hdvc.pushType = ATOMCommentMessageType;
            [self pushViewController:hdvc animated:YES];
        } else if (CGRectContainsPoint(cell.replyContentLabel.frame, p)) {
            ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
            [self pushViewController:cdvc animated:YES];
        } else if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
            p = [gesture locationInView:cell.userNameLabel];
            if (p.x <= 16 * 3) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                [self pushViewController:opvc animated:YES];
            }
        }
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CommentMessageCell";
    ATOMCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMCommentMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.commentMessageViewModel = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMCommentMessageTableViewCell calculateCellHeightWithModel:_dataSource[indexPath.row]];
}

























@end
