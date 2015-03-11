//
//  ATOMAccountSettingViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAccountSettingViewController.h"
#import "ATOMAccountSettingTableViewCell.h"
#import "ATOMModifyPasswordViewController.h"
#import "ATOMAccountBindingViewController.h"
#import "ATOMMessageRemindViewController.h"

@interface ATOMAccountSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ATOMAccountSettingViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.title = @"账号设置";
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 5;
    } else if (section ==2) {
        return 1;
    }
    return 0;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGFloat sectionHeaderHeight = 22.5;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AccountSettingCell";
    ATOMAccountSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMAccountSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            cell.themeLabel.text = @"消息提醒";
        } else if (row == 1) {
            cell.themeLabel.text = @"修改密码";
        } else if (row == 2) {
            cell.themeLabel.text = @"账号绑定";
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.themeLabel.text = @"离线下载";
            [cell addSwitch];
        } else if (row == 1) {
            cell.themeLabel.text = @"清除缓存";
        } else if (row == 2) {
            cell.themeLabel.text = @"推荐应用给好友";
        } else if (row == 3) {
            cell.themeLabel.text = @"关于我们";
        } else if (row == 4) {
            cell.themeLabel.text = @"给应用评分";
        }
    } else if (section == 2) {
        [cell addLogout];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            ATOMMessageRemindViewController *mrvc = [ATOMMessageRemindViewController new];
            [self pushViewController:mrvc animated:YES];
        } else if (row == 1) {
            ATOMModifyPasswordViewController *mpvc = [ATOMModifyPasswordViewController new];
            [self pushViewController:mpvc animated:YES];
        } else if (row == 2) {
            ATOMAccountBindingViewController *abvc = [ATOMAccountBindingViewController new];
            [self pushViewController:abvc animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
        } else if (row == 1) {
        } else if (row == 2) {
        } else if (row == 3) {
        } else if (row == 4) {
        }
    } else if (section == 2) {
    }
}

@end
