//
//  ATOMPersonViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPersonViewController.h"
#import "ATOMPersonView.h"
#import "ATOMPersonTableViewCell.h"
#import "ATOMAccountSettingViewController.h"
#import "ATOMMyFansViewController.h"
#import "ATOMMyConcernViewController.h"
#import "ATOMMyWorkViewController.h"
#import "ATOMMyUploadViewController.h"
#import "ATOMMyCollectionViewController.h"
#import "ATOMProfileEditViewController.h"
#import "ATOMProceedingViewController.h"

@interface ATOMPersonViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ATOMPersonView *personView;

@end

@implementation ATOMPersonViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)createUI {
    _personView = [ATOMPersonView new];
    self.view = _personView;
    UITapGestureRecognizer *tapFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFansGesture:)];
    [_personView.fansLabel addGestureRecognizer:tapFansGesture];
    _personView.personTableView.delegate = self;
    _personView.personTableView.dataSource = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.title = @"个人";
    self.navigationItem.title = @"宋祥伍";
}

#pragma mark - Gesture Event

- (void)tapFansGesture:(UITapGestureRecognizer *)gesture {
    ATOMMyFansViewController *mfvc = [ATOMMyFansViewController new];
    [self pushViewController:mfvc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 3;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            ATOMMyUploadViewController *muvc = [ATOMMyUploadViewController new];
            [self pushViewController:muvc animated:YES];
        } else if (row == 1) {
            ATOMMyWorkViewController *mwvc = [ATOMMyWorkViewController new];
            [self pushViewController:mwvc animated:YES];
        } else if (row == 2) {
            ATOMProceedingViewController *pvc = [ATOMProceedingViewController new];
            [self pushViewController:pvc animated:YES];
        } else if (row == 3) {
            ATOMMyCollectionViewController *mcvc = [ATOMMyCollectionViewController new];
            [self pushViewController:mcvc animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            ATOMMyConcernViewController *mcvc = [ATOMMyConcernViewController new];
            [self pushViewController:mcvc animated:YES];
        } else if (row == 1) {
            ATOMProfileEditViewController *pevc = [ATOMProfileEditViewController new];
            [self pushViewController:pevc animated:YES];
        } else if (row == 2) {
            ATOMAccountSettingViewController *asvc = [ATOMAccountSettingViewController new];
            [self pushViewController:asvc animated:YES];
        }
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PersonCell";
    ATOMPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            cell.themeImageView.image = [UIImage imageNamed:@"icon_user_psask"];
            cell.themeLabel.text = @"我的求P(100)";
        } else if (row == 1) {
            cell.themeImageView.image = [UIImage imageNamed:@"icon_user_pswork"];
            cell.themeLabel.text = @"我的作品(100)";
        } else if (row == 2) {
            cell.themeImageView.image = [UIImage imageNamed:@"icon_progress"];
            cell.themeLabel.text = @"进行中(100)";
        } else if (row == 3) {
            cell.themeImageView.image = [UIImage imageNamed:@"icon_collect"];
            cell.themeLabel.text = @"我的收藏";
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.themeImageView.image = [UIImage imageNamed:@"bt_myfollow"];
            cell.themeLabel.text = @"我的关注";
        } else if (row == 1) {
            cell.themeImageView.image = [UIImage imageNamed:@"btn_user_edit"];
            cell.themeLabel.text = @"编辑资料";
        } else if (row == 2) {
            cell.themeImageView.image = [UIImage imageNamed:@"icon_user_config"];
            cell.themeLabel.text = @"用户设置";
        }
    }

    
    return cell;
}










@end
