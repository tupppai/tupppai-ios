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
    self.navigationItem.title = @"我的消息";
    _myMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_myMessageView.bounds];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellAccessoryDisclosureIndicator;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
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
        cell.imageView.image = [UIImage imageNamed:@"ic_news_comment"];
        cell.imageView.frame = CGRectMake(100, 0, 0, 0);
        cell.textLabel.text = @"评论";
    } else if (row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_draft"];
        cell.textLabel.text = @"帖子回复";
    } else if (row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_follow"];
        cell.textLabel.text = @"关注通知";
    } else if (row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_invite"];
        cell.textLabel.text = @"邀请通知";
    } else if (row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_setting"];
        cell.textLabel.text = @"系统通知";
    }
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
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
