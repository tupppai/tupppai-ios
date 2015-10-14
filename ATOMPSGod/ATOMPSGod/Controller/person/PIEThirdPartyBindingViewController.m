//
//  ATOMAccountBindingViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEThirdPartyBindingViewController.h"
#import "ATOMAccountBindingView.h"
#import "ATOMAccountBindingTableViewCell.h"
#import "DDMySettingsManager.h"
#import "DDShareSDKManager.h"
@interface PIEThirdPartyBindingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ATOMAccountBindingView *accountBindingView;

@end

@implementation PIEThirdPartyBindingViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"账号绑定";
    _accountBindingView = [ATOMAccountBindingView new];
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
    [DDUserManager DDGetUserInfoAndUpdateMe];
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
    return 35;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"登录账号";
            break;
        case 1:
            sectionName = @"社交账号绑定";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AccountBindingCell";
    ATOMAccountBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMAccountBindingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        if (row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"weibo"];
            cell.textLabel.text = @"新浪微博";
            [cell addSwitch];
            [cell.bindSwitch setOn:[DDUserManager currentUser].bindWeibo];
        }
        else if (row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"wechat"];
            cell.textLabel.text = @"微信";
            [cell addSwitch];
            [cell.bindSwitch setOn:[DDUserManager currentUser].bindWechat];
        }
        [cell.bindSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.bindSwitch.tag = indexPath.row;
    } else if (section == 0) {
        if (row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 25)];
            label.adjustsFontSizeToFitWidth = YES;
            NSString* phoneDesc ;
            if ([[DDUserManager currentUser].mobile isEqualToString:@"-1"] || ![DDUserManager currentUser].mobile) {
                label.text = @"未绑定";
                 phoneDesc = @"手机号";
            } else {
                label.text = @"已绑定";
                phoneDesc = [NSString stringWithFormat:@"手机号%@",[DDUserManager currentUser].mobile];
            }
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryView = label;
            cell.textLabel.text = phoneDesc;
        }
        else if (row == 1) {
            cell.textLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
   
    return cell;
    
}

-(void)toggleSwitch:(id)sender {
    UISwitch *bindSwitch = sender;
    NSString *type;
    NSString* openIDKey;
    int shareType = 99;
    switch (bindSwitch.tag) {
        case 0:
            type = @"weibo";
            shareType = SSDKPlatformTypeSinaWeibo;
            openIDKey = @"idstr";
            break;
        case 1:
            type = @"weixin";
            shareType = SSDKPlatformTypeWechat;
            openIDKey = @"openid";
            break;
        default:
            break;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:type forKey:@"type"];
    //1.如果想要绑定
    if (bindSwitch.on) {
        [DDShareSDKManager getUserInfo:shareType withBlock:^(NSDictionary *sourceData) {
            NSString* openID = [sourceData objectForKey:openIDKey];
            if (openID) {
                [param setObject:openID forKey:@"openid"];
            }
            [DDMySettingsManager setBindSetting:param withToggleBind:YES withBlock:^(NSError *error) {
                if (error) {
                    //绑定失败，回到原型
                    bindSwitch.on = NO;
                }else {
                    [Hud success:@"绑定成功" inView:self.view];
                }
            }];

        }];
    }
    //2.如果想要取消绑定
    else  {
        [DDMySettingsManager setBindSetting:param withToggleBind:NO withBlock:^(NSError *error) {
            //绑定失败，回到原型
            if (error) {
                bindSwitch.on = YES;
            } else {
                [Hud success:@"已解绑" inView:self.view];
            }
        }];
    }
}




@end
