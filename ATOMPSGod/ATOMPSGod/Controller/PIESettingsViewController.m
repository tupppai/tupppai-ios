//
//  PIESettingsViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESettingsViewController.h"

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

#import "PIESignOutTableViewCell.h"
@interface PIESettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PIESettingsViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [UIView new];
    self.view = _tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UINib* nib = [UINib nibWithNibName:@"PIESignOutTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"PIESignOutTableViewCell"];
    self.title = @"设置";
}
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 3;
    } else if (section ==2) {
        return 4;
    } else if (section ==3) {
        return 3;
    }
    return 0;
}

#pragma mark - UITableViewDelegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 2) {
        return 72;
    }
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3 && indexPath.row == 2) {
        PIESignOutTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PIESignOutTableViewCell"];
        return cell;
    }
    else {
        PIESettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountSettingCell"];
        if (!cell) {
            cell = [[PIESettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingCell"];
        }
        
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (section == 0) {
            if (row == 0) {
                cell.textLabel.text = @"账号安全";
            } else if (row == 1) {
                cell.textLabel.text = @"编辑个人资料";
            }
        }
        else if (section == 1) {
            if (row == 0) {
                cell.textLabel.text = @"消息通知";
            } else if (row == 1) {
                cell.textLabel.text = @"我赞过的";
            } else if (row == 2) {
                cell.textLabel.text = @"我评论过的";
            }
        }
        else if (section == 2) {
            if (row == 0) {
                cell.textLabel.text = @"版本更新";
            } else if (row == 1) {
                cell.textLabel.text = @"清理缓存";
            } else if (row == 2) {
                cell.textLabel.text = @"推荐应用给好友";
            } else if (row == 3) {
                cell.textLabel.text = @"给图派评分";
            }
        }
        else if (section == 3) {
            if (row == 0) {
                cell.textLabel.text = @"意见反馈";
            } else if (row == 1) {
                cell.textLabel.text = @"关于我们";
            }
        }
        return cell;
    }
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
            PIEThirdPartyBindingViewController *abvc = [PIEThirdPartyBindingViewController new];
            [self.navigationController pushViewController:abvc animated:YES];
        } else if (row == 1) {
            PIEModifyProfileViewController *mpvc = [PIEModifyProfileViewController new];
            [self.navigationController pushViewController:mpvc animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            PIEMessagePushSettingViewController *mrvc = [PIEMessagePushSettingViewController new];
            [self.navigationController pushViewController:mrvc animated:YES];

        } else if (row == 1) {
            //我赞过的
        } else if (row == 2) {
            //我评论过的
        }
    } else if (section == 2) {
        
        if (row == 0) {
            PIEMessagePushSettingViewController *mrvc = [PIEMessagePushSettingViewController new];
            [self.navigationController pushViewController:mrvc animated:YES];
        } else if (row == 1) {
            [self clearCache];
        } else if (row == 2) {
            //推荐应用
        } else if (row == 3) {
            //给应用评分
        }
    }
    else if (section == 3) {
        if (row == 0) {
            ATOMUserFeedbackViewController *ufvc = [ATOMUserFeedbackViewController new];
            [self.navigationController pushViewController:ufvc animated:YES];
        } else if (row == 1) {
            //关于我们
        } else if (row == 2) {
            [self signOut];
        }
    }

}

-(void) signOut {
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
                              DDLaunchVC *lvc = [[DDLaunchVC alloc] init];
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
