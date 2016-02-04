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

typedef void(^requestResultBlock)(void);


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
    view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
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
        cell.bindSwitch.tag = indexPath.row;
        [cell.bindSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
    } else if (section == 0) {
        if (row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 25)];
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:14.0];
            NSString* phoneDesc ;
            if ([[DDUserManager currentUser].mobile isEqualToString:@"-1"] || [DDUserManager currentUser].mobile.length < 8) {
                label.text = @"未绑定";
                 phoneDesc = @"手机号";
            } else {
                label.text = @"已绑定";
                
                if ([DDUserManager currentUser].mobile) {
                    cell.phoneNumber = [DDUserManager currentUser].mobile;
                }
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
    NSString *type;
    SSDKPlatformType shareType = SSDKPlatformTypeUnknown;
    switch (bindSwitch.tag) {
        case 0:{
            type = @"weibo";
            shareType = SSDKPlatformTypeSinaWeibo;
            break;
        }
        case 1:{
            type = @"weixin";
            shareType = SSDKPlatformTypeWechat;
            break;
        }
        case 2:{
            type = @"qq";
            shareType = SSDKPlatformTypeQQ;
            break;
        }
        default:
            break;
    }
    
    //1.如果想要绑定
    if (bindSwitch.on) {
        // 弹出第三方的登录界面，目标只有openid
        [DDShareManager
         authorize2:shareType
         withBlock:^(SSDKUser *user) {
             // 取得openID之后，开始手机与第三方openID的绑定
             NSString *openId = user.uid;
             
             [self
              bindUserWithThirdPartyPlatform:type
              openId:openId
              failure:^{
                  /*绑定失败，重置UI*/
                  bindSwitch.on = NO;
              }
              success:^{
                  // 重置currentUser单例并且同步到本地沙盒
                  NSString *prompt =
                  [NSString stringWithFormat:@"成功绑定%@",type];
                  [Hud text:prompt];
                  
                  // 重置currentUser单例并且同步到本地沙盒
                  switch (bindSwitch.tag) {
                      case 0:{
                          [DDUserManager currentUser].bindWeibo = YES;
                          break;
                      }
                      case 1:{
                          [DDUserManager currentUser].bindWechat = YES;
                          break;
                      }
                      case 2:{
                          [DDUserManager currentUser].bindQQ = YES;
                          break;
                      }
                      default:
                          break;
                  }
                  [DDUserManager updateCurrentUserInDatabase];
                  
              }];
         }];
        
    }
    //2.如果想要取消绑定
    else  {
        [self
         unbindUserWithThirdPartyPlatform:type
         failure:^{
             /* 解绑失败，重置UI */
             bindSwitch.on = YES;
         } success:^{
             NSString *prompt =
             [NSString stringWithFormat:@"已经解绑%@",type];
             [Hud text:prompt];
             // 重置currentUser单例并且同步到本地沙盒
             switch (bindSwitch.tag) {
                 case 0:{
                     [DDUserManager currentUser].bindWeibo = NO;
                     break;
                 }
                 case 1:{
                     [DDUserManager currentUser].bindWechat = NO;
                     break;
                 }
                 case 2:{
                     [DDUserManager currentUser].bindQQ = NO;
                     break;
                 }
                 default:
                     break;
             }
             [DDUserManager updateCurrentUserInDatabase];
         }];
    }
}


#pragma mark - private helpers
- (void)unbindUserWithThirdPartyPlatform: (NSString *)type
                                 failure:(void (^) (void))failure
                                 success:(void (^) (void))success
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:type forKey:@"type"];
    /*
     auth/unbind, POST, (type = weixin, weibo or qq)
     */
    [Hud activity:@"解绑中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = type;
    [DDBaseService POST:params url:@"auth/unbind"
                  block:^(id responseObject) {
                      [Hud dismiss];
                      if (responseObject == nil) {
                          if (failure) {
                              failure();
                          }
                      }else{
                          if (success) {
                              success();
                          }
                      }
                  }];
}

- (void)bindUserWithThirdPartyPlatform:(NSString *)type openId:(NSString *)openId
                               failure:(void (^)(void))failure
                               success:(void (^)(void))success
{
    /*
        auth/bind, POST, openid, type(qq, weixin or weibo)
     */
    
    NSMutableDictionary *params = [NSMutableDictionary <NSString *, NSString *> new];
    params[@"type"]             = type;
    params[@"openid"]           = openId;
    
    [Hud activity:@"绑定中..."];
    [DDBaseService POST:params
                    url:@"auth/bind"
                  block:^(id responseObject) {
                      [Hud dismiss];
                      
                      if (responseObject == nil) {
                          if (failure != nil) {
                              failure();
                          }
                      }else{
                          if (success != nil) {
                              success();
                          }
                      }
                  }];
}

@end
