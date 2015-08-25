//
//  ATOMAccountBindingViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAccountBindingViewController.h"
#import "ATOMAccountBindingView.h"
#import "ATOMAccountBindingTableViewCell.h"
#import "ATOMShowSettings.h"
#import "ATOMShareSDKModel.h"
#import "ATOMShowUser.h"
@interface ATOMAccountBindingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ATOMAccountBindingView *accountBindingView;

@end

@implementation ATOMAccountBindingViewController

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
    [ATOMShowUser ShowUserInfo:^(ATOMUser *user, NSError *error) {
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSArray* list = @[@"社交账号绑定",@"手机号绑定"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-30, 35)];
    [label setFont:[UIFont fontWithName:@"Hiragino Sans GB W3" size:kFont14]];
    NSString *string = [list objectAtIndex:section];
    view.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHex:0x637685];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AccountBindingCell";
    ATOMAccountBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMAccountBindingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"weibo"];
            cell.textLabel.text = @"新浪微博";
            [cell addSwitch];
            [cell.bindSwitch setOn:[ATOMCurrentUser currentUser].bindWeibo];
        } else if (row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"wechat"];
            cell.textLabel.text = @"微信";
            [cell addSwitch];
            [cell.bindSwitch setOn:[ATOMCurrentUser currentUser].bindWechat];
        }
        [cell.bindSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.bindSwitch.tag = indexPath.row;
    } else if (section == 1) {
        cell.textLabel.text = @"手机号";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([[ATOMCurrentUser currentUser].mobile isEqualToString:@"-1"]) {
            cell.phoneNumber = @"未绑定";
        } else {
            cell.phoneNumber = [ATOMCurrentUser currentUser].mobile;
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
        [ATOMShareSDKModel getUserInfo:shareType withBlock:^(NSDictionary *sourceData) {
            NSString* openID = [sourceData objectForKey:openIDKey];
            if (openID) {
                [param setObject:openID forKey:@"openid"];
            }
            [ATOMShowSettings setBindSetting:param withToggleBind:YES withBlock:^(NSError *error) {
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
        [ATOMShowSettings setBindSetting:param withToggleBind:NO withBlock:^(NSError *error) {
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
