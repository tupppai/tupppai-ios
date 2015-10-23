//
//  ATOMAccountSettingViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIESettingViewController.h"
#import "PIESettingsTableViewCell.h"
#import "ATOMModifyPasswordViewController.h"
#import "PIEThirdPartyBindingViewController.h"
#import "PIEMessagePushSettingViewController.h"
#import "ATOMUserFeedbackViewController.h"
#import "ATOMUserDAO.h"
#import "PIEPageDAO.h"
#import "DDLoginNavigationController.h"
#import "AppDelegate.h"
#import "SIAlertView.h"
#import "DDHomePageManager.h"
#import "PIEModifyProfileViewController.h"
@interface PIESettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PIESettingViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.title = @"账号设置";
}
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 6;
    } else if (section ==2) {
        return 1;
    }
    return 0;
}

#pragma mark - UITableViewDelegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 15;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AccountSettingCell";
    PIESettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PIESettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            cell.textLabel.text = @"消息提醒";
        } else if (row == 1) {
            cell.textLabel.text = @"编辑资料";
        } else if (row == 2) {
            cell.textLabel.text = @"修改密码";
        } else if (row == 3) {
            cell.textLabel.text = @"账号绑定";
        }
    }
    else if (section == 1) {
        if (row == 0) {
            cell.textLabel.text = @"清除缓存";
        } else if (row == 1) {
            cell.textLabel.text = @"检查新版本";
        } else if (row == 2) {
            cell.textLabel.text = @"推荐应用给好友";
        } else if (row == 3) {
            cell.textLabel.text = @"用户反馈";
        } else if (row == 4) {
            cell.textLabel.text = @"关于我们";
        } else if (row == 5) {
            cell.textLabel.text = @"给应用评分";
        }
    }
    else if (section == 2) {
        cell.textLabel.text = @"退出当前账号";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.topViewController != self) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            PIEMessagePushSettingViewController *mrvc = [PIEMessagePushSettingViewController new];
            [self.navigationController pushViewController:mrvc animated:YES];
        } else if (row == 1) {
            PIEModifyProfileViewController *mpvc = [PIEModifyProfileViewController new];
            [self.navigationController pushViewController:mpvc animated:YES];
        } else if (row == 2) {
            ATOMModifyPasswordViewController *mpvc = [ATOMModifyPasswordViewController new];
            [self.navigationController pushViewController:mpvc animated:YES];
        } else if (row == 3) {
            PIEThirdPartyBindingViewController *abvc = [PIEThirdPartyBindingViewController new];
            [self.navigationController pushViewController:abvc animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            [self clearCache];
        } else if (row == 1) {
            //检查新版本
        } else if (row == 2) {
            //推荐应用
        } else if (row == 3) {
            ATOMUserFeedbackViewController *ufvc = [ATOMUserFeedbackViewController new];
            [self.navigationController pushViewController:ufvc animated:YES];
        } else if (row == 4) {
            //关于我们
        } else if (row == 5) {
            //给应用评分
        }
    } else if (section == 2) {
        [self SignOut];
    }
}

-(void) SignOut {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"确定要退出登录吗"];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    [alertView addButtonWithTitle:@"确定😭"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              //清空数据库用户表
                              [ATOMUserDAO clearUsers];
                              //清空当前用户
                              [[DDUserManager currentUser]wipe];
                              self.navigationController.viewControllers = @[];
                              PIELaunchViewController *lvc = [[PIELaunchViewController alloc] init];
                              [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}
-(void) clearCache {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"😊" andMessage:@"确定要清理缓存吗？"];
    [alertView addButtonWithTitle:@"不清理"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                          }];
    [alertView addButtonWithTitle:@"坚决清理"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [[NSURLCache sharedURLCache]removeAllCachedResponses];
                              DDHomePageManager *showHomepage = [DDHomePageManager new];
                              [showHomepage clearHomePages];
                              [Hud success:@"清理缓存成功" inView:self.view];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}
@end
