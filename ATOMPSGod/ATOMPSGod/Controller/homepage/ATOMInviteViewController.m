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
#import "ATOMRecentDetailViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMHomepageViewController.h"

@interface ATOMInviteViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ATOMInviteView *inviteView;
@property (nonatomic, strong) UITapGestureRecognizer *tapInviteGesture;

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
    _tapInviteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInviteGesture:)];
    [_inviteView.inviteTableView addGestureRecognizer:_tapInviteGesture];
}

#pragma mark - Gesture Event

- (void)tapInviteGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_inviteView.inviteTableView];
    NSIndexPath *indexPath = [_inviteView.inviteTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMInviteTableViewCell *cell = (ATOMInviteTableViewCell *)[_inviteView.inviteTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        } else if (CGRectContainsPoint(cell.inviteButton.frame, p)) {
            [cell changeInviteButtonStatus];
        }
    }
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)barButtonItem {
    ATOMRecentDetailViewController *rdvc = [ATOMRecentDetailViewController new];
    rdvc.homePageViewModel = _homePageViewModel;
    ATOMHomepageViewController *hvc = self.navigationController.viewControllers[0];
    [self pushViewController:rdvc animated:YES];
    [self.navigationController setViewControllers:@[hvc, rdvc]];
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
    }
    return cell;
}

@end
