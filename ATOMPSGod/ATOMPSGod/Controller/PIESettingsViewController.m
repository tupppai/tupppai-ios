//
//  PIESettingsViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESettingsViewController.h"

#import "PIESettingsTableViewCell.h"
#import "PIEThirdPartyBindingViewController.h"
#import "PIEMessagePushSettingViewController.h"
#import "ATOMUserDAO.h"
#import "PIEPageDAO.h"
#import "DDLoginNavigationController.h"
#import "AppDelegate.h"
#import "SIAlertView.h"
#import "PIEPageManager.h"
#import "PIEModifyProfileViewController.h"
#import "PIEMyCommentedPageViewController.h"
#import "PIESignOutTableViewCell.h"
#import "PIEMyLikedPagesViewController.h"
#import "PIEFeedbackViewController.h"
#import "PIEAboutUsViewController.h"
#import "UMCheckUpdate.h"
#import "PIELaunchViewController_Black.h"


@interface PIESettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PIESettingsViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.tableView;
    self.title = @"设置";
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHex:0xffffff andAlpha:0.9];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 20);
        _tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UINib* nib = [UINib nibWithNibName:@"PIESignOutTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"PIESignOutTableViewCell"];
    }
    return _tableView;
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
        return 2;
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
    if (section != 0) {
        return 10;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3 && indexPath.row == 2) {
        PIESignOutTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PIESignOutTableViewCell"];
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
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
                cell.textLabel.text = @"清理缓存";
            }
//            else if (row == 1) {
//                cell.textLabel.text = @"清理缓存";
//            }
//            else if (row == 2) {
//                cell.textLabel.text = @"推荐应用给好友";
//            }
            else if (row == 1) {
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
            PIEMyLikedPagesViewController * vc = [PIEMyLikedPagesViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (row == 2) {
            //我评论过的
            PIEMyCommentedPageViewController* vc = [PIEMyCommentedPageViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (section == 2) {
        
        if (row == 0) {
            [self clearCache];

//            [UMCheckUpdate checkUpdateWithDelegate:self selector:@selector(UMCheckUpdateReturn:) appkey:@"55b1ecdbe0f55a1de9001164" channel:nil];
        } else if (row == 1) {
            [self alert_evaluation];

//            [self clearCache];
        }
//        else if (row == 2) {
//            [self alert_evaluation];
//        }
    }
    else if (section == 3) {
        if (row == 0) {
            PIEFeedbackViewController *ufvc = [PIEFeedbackViewController new];
            [self.navigationController pushViewController:ufvc animated:YES];
        } else if (row == 1) {
            //关于我们
            PIEAboutUsViewController* vc = [PIEAboutUsViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (row == 2) {
            [self SignOut];
        }
    }

}

- (void) UMCheckUpdateReturn:(id)sender {
    NSString* toUpdate = [sender objectForKey:@"update"];
    if ([toUpdate isEqualToString:@"NO"]) {
        [Hud text:@"已是最新版本"];
    } else {
        [self alert_goToAppstore];
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
                              [DDUserManager clearCurrentUser];
                              [DDSessionManager resetSharedInstance];
                              

                              
                              self.navigationController.viewControllers = @[];
                              PIELaunchViewController_Black *lvc = [[PIELaunchViewController_Black alloc] init];
                              [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}


-(void) alert_goToAppstore {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"检测到新版本" andMessage:@"是否前往 App Store 更新图派?"];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    [alertView addButtonWithTitle:@"欣然前往"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSString *iTunesLink = @"http://itunes.apple.com/app/id1056871759";
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}
-(void) alert_evaluation {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"图派感谢有你" andMessage:@"是否前往 App Store 对图派进行评分?"];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    [alertView addButtonWithTitle:@"前往"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSString *iTunesLink = @"http://itunes.apple.com/app/id1056871759";
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

-(void) clearCache {
    
//    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"确定要清理缓存吗？"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [[NSURLCache sharedURLCache]removeAllCachedResponses];
//        //                              DDHomePageManager *showHomepage = [DDHomePageManager new];
//        //                              [showHomepage clearHomePages];
//        [Hud success:@"清理缓存成功" inView:self.view];
//
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"😊" andMessage:@"确定要清理缓存吗？"];
    [alertView addButtonWithTitle:@"不清理"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    [alertView addButtonWithTitle:@"清理"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [[NSURLCache sharedURLCache]removeAllCachedResponses];
//                              DDHomePageManager *showHomepage = [DDHomePageManager new];
//                              [showHomepage clearHomePages];
                              [Hud success:@"清理缓存成功" inView:self.view];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}
@end
