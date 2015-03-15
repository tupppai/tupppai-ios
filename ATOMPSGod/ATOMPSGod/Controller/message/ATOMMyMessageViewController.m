//
//  ATOMMyMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyMessageViewController.h"
#import "ATOMMyMessageTableViewCell.h"
#import "ATOMCommentMessageViewController.h"
#import "ATOMInviteMessageViewController.h"
#import "ATOMConcernMessageViewController.h"
#import "ATOMTopicReplyMessageViewController.h"

@interface ATOMMyMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *myMessageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ATOMMyMessageViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI {
    self.title = @"我的消息";
    _myMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_myMessageView.bounds];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_myMessageView addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyMessageCell";
    ATOMMyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMyMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.themeImageView.image = [UIImage imageNamed:@"icon_comment1"];
        cell.themeLabel.text = @"评论";
    } else if (row == 1) {
        cell.themeImageView.image = [UIImage imageNamed:@"icon_reply"];
        cell.themeLabel.text = @"帖子回复";
    } else if (row == 2) {
        cell.themeImageView.image = [UIImage imageNamed:@"bt_myfollow"];
        cell.themeLabel.text = @"关注通知";
    } else if (row == 3) {
        cell.themeImageView.image = [UIImage imageNamed:@"icon_invite"];
        cell.themeLabel.text = @"邀请通知";
    } else if (row == 4) {
        cell.themeImageView.image = [UIImage imageNamed:@"icon_notice"];
        cell.themeLabel.text = @"系统通知";
    }
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        ATOMCommentMessageViewController *cmvc = [ATOMCommentMessageViewController new];
        [self pushViewController:cmvc animated:YES];
    } else if (row == 1) {
        ATOMTopicReplyMessageViewController *trmvc = [ATOMTopicReplyMessageViewController new];
        [self pushViewController:trmvc animated:YES];
    } else if (row == 2) {
        ATOMConcernMessageViewController *cmvc = [ATOMConcernMessageViewController new];
        [self pushViewController:cmvc animated:YES];
    } else if (row == 3) {
        ATOMInviteMessageViewController *imvc = [ATOMInviteMessageViewController new];
        [self pushViewController:imvc animated:YES];
    } else if (row == 4) {

    }
}





























@end
