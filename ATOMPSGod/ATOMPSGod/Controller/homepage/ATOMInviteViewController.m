//
//  ATOMInviteViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteViewController.h"
#import "ATOMInviteView.h"
#import "ATOMInviteTableViewCell.h"
#import "ATOMInviteTableHeaderView.h"
#import "ATOMHotDetailViewController.h"

@interface ATOMInviteViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ATOMInviteView *inviteView;

@end

@implementation ATOMInviteViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)createUI {
    self.title = @"邀请页面";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _inviteView = [ATOMInviteView new];
    self.view = _inviteView;
    _inviteView.inviteTableView.delegate = self;
    _inviteView.inviteTableView.dataSource = self;
}

#pragma mark - Click Event

- (void)clickInviteButton:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor colorWithHex:0x00adef];
        [button setTitle:@"邀请" forState:UIControlStateNormal];
    } else {
        button.backgroundColor = [UIColor colorWithHex:0x838383];
        [button setTitle:@"已邀请" forState:UIControlStateNormal];
    }
}

- (void)clickRightButtonItem:(UIBarButtonItem *)barButtonItem {
    ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
    [self pushViewController:hdvc animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ATOMInviteTableHeaderView *headerView = [ATOMInviteTableHeaderView new];
    if (section == 0) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0x00adef];
        headerView.titleLabel.text = @"邀请大神";
    } else if (section == 1) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0x00adef];
        headerView.titleLabel.text = @"邀请好友";
    }
    return headerView;
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InviteCell";
    ATOMInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMInviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.inviteButton addTarget:self action:@selector(clickInviteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

@end
