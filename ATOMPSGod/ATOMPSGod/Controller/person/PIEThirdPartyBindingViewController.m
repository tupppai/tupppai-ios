//
//  ATOMAccountBindingViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEThirdPartyBindingViewController.h"
#import "PIEAccountBindingView.h"
#import "PIEAccountBindingTableViewCell.h"
#import "DDMySettingsManager.h"

#import "PIEModifyPasswordViewController.h"
@interface PIEThirdPartyBindingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PIEAccountBindingView *accountBindingView;

@end

@implementation PIEThirdPartyBindingViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"帐号绑定";
    _accountBindingView = [PIEAccountBindingView new];
    self.view = _accountBindingView;
    _accountBindingView.accountBindingTableView.scrollEnabled = NO;
    _accountBindingView.accountBindingTableView.delegate = self;
    _accountBindingView.accountBindingTableView.dataSource = self;
}

#pragma mark - Click Event

- (void)clickCellRightButton:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor colorWithHex:0x00adef];
    } else {
        button.backgroundColor = [UIColor colorWithHex:0xcccccc];
    }
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [DDUserManager updateDBUserFromCurrentUser];
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

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,40)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100,40)];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];

    label.font = [UIFont boldSystemFontOfSize:13];
    switch (section)
    {
        case 0:
            label.text = @"登录账号";
            break;
        case 1:
            label.text  = @"社交账号绑定";
            break;
        default:
            break;
    }
    return view;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self.navigationController pushViewController:[PIEModifyPasswordViewController new] animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AccountBindingCell";
    PIEAccountBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PIEAccountBindingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        if (row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"pie_binding_sinaweibo"];
            cell.textLabel.text = @"新浪微博";
            [cell addSwitch];
            [cell.bindSwitch setOn:[DDUserManager currentUser].bindWeibo];
        }
        else if (row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"pie_binding_wechat"];
            cell.textLabel.text = @"微信";
            [cell addSwitch];
            [cell.bindSwitch setOn:[DDUserManager currentUser].bindWechat];
        }
        else if (row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"pie_binding_qq"];
            cell.textLabel.text = @"QQ";
            [cell addSwitch];
            [cell.bindSwitch setOn:[DDUserManager currentUser].bindQQ];
        }

        [cell.bindSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.bindSwitch.tag = indexPath.row;
    } else if (section == 0) {
        if (row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 25)];
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:14.0];
            NSString* phoneDesc ;
            if ([[DDUserManager currentUser].mobile isEqualToString:@"-1"] || ![DDUserManager currentUser].mobile) {
                label.text = @"未绑定";
                 phoneDesc = @"手机号";
            } else {
                label.text = @"已绑定";
                
                cell.phoneNumber = [DDUserManager currentUser].mobile;
                phoneDesc = @"手机号";
            }
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryView = label;
            cell.textLabel.text = phoneDesc;
        }
        else if (row == 1) {
            cell.textLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView* indicatorView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 14)];
            indicatorView.contentMode = UIViewContentModeScaleAspectFit;
            indicatorView.image = [UIImage imageNamed:@"pie_next"];
            cell.accessoryView = indicatorView;
        }
    }
   
    return cell;
    
}

-(void)toggleSwitch:(id)sender {
    UISwitch *bindSwitch = sender;
    NSString *type = @"";
    int shareType = 99;
    switch (bindSwitch.tag) {
        case 0:
            type = @"weibo";
            shareType = SSDKPlatformTypeSinaWeibo;
            break;
        case 1:
            type = @"weixin";
            shareType = SSDKPlatformTypeWechat;
            break;
        case 2:
            type = @"qq";
            shareType = SSDKPlatformTypeQQ;
            break;
        default:
            break;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:type forKey:@"type"];
    //1.如果想要绑定
    if (bindSwitch.on) {
        [DDShareManager getUserInfo:shareType withBlock:^(NSString *openId) {
            if (openId) {
                [param setObject:openId forKey:@"openid"];
            [DDMySettingsManager setBindSetting:param withToggleBind:YES withBlock:^(NSError *error) {
                if (error) {
                    //绑定失败，回到原型
                    bindSwitch.on = NO;
                }else {
                    switch (bindSwitch.tag) {
                        case 0:
                            [DDUserManager currentUser].bindWeibo = YES;

                            break;
                        case 1:
                            [DDUserManager currentUser].bindWechat = YES;
                            break;
                        case 2:
                            [DDUserManager currentUser].bindQQ = YES;
                            break;
                        default:
                            break;
                    }
                    [DDUserManager updateDBUserFromCurrentUser];
                    [Hud success:@"绑定成功" inView:self.view];
                }
            }];
            }
            else {
                bindSwitch.on = NO;
            }


        }];
    }
    //2.如果想要取消绑定
    else  {
        [DDMySettingsManager setBindSetting:param withToggleBind:NO withBlock:^(NSError *error) {
            //绑定失败，回到原型
            if (error) {
                bindSwitch.on = YES;
            } else {
                switch (bindSwitch.tag) {
                    case 0:
                        [DDUserManager currentUser].bindWeibo = NO;
                        
                        break;
                    case 1:
                        [DDUserManager currentUser].bindWechat = NO;
                        break;
                    case 2:
                        [DDUserManager currentUser].bindQQ = NO;
                        break;
                    default:
                        break;
                }
                [Hud success:@"已解绑" inView:self.view];
            }
        }];
    }
}




@end
