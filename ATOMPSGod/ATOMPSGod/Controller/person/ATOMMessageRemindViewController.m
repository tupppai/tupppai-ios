//
//  ATOMMessageRemindViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMessageRemindViewController.h"
#import "ATOMMessageRemindTableViewCell.h"
#import "ATOMShowSettings.h"
@interface ATOMMessageRemindViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *data;

@end

@implementation ATOMMessageRemindViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ATOMShowSettings getPushSetting:nil withBlock:^(NSDictionary *data, NSError *error) {
        if (data) {
            _data = data;
            [_tableView reloadData];
        }
    }];
}
- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.title = @"消息提醒";
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageRemindCell";
    ATOMMessageRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMessageRemindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.notificationSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.notificationSwitch.tag = indexPath.row;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            cell.textLabel.text = @"评论";
            cell.notificationSwitch.on = [[_data objectForKey:@"comment"]boolValue];
        } else if (row == 1) {
            cell.textLabel.text = @"帖子回复";
            cell.notificationSwitch.on = [[_data objectForKey:@"reply"]boolValue];
        } else if (row == 2) {
            cell.textLabel.text = @"关注通知";
            cell.notificationSwitch.on = [[_data objectForKey:@"follow"]boolValue];
        } else if (row == 3) {
            cell.textLabel.text = @"邀请通知";
            cell.notificationSwitch.on = [[_data objectForKey:@"invite"]boolValue];
        } else if (row == 4) {
            cell.notificationSwitch.on = [[_data objectForKey:@"system"]boolValue];
            cell.textLabel.text = @"系统通知";
        }
    }
    return cell;
}


-(void)toggleSwitch:(id)sender {
    UISwitch *notificationSwitch = sender;
    NSString *type;
    switch (notificationSwitch.tag) {
        case 0:
            type = @"comment";
            break;
        case 1:
            type = @"reply";
            break;
        case 2:
            type = @"follow";
            break;
        case 3:
            type = @"invite";
            break;
        case 4:
            type = @"system";
            break;
        default:
            break;
    }
//    type(必填): [comment|follow|invite|reply|system]
//    value(必填): 0|1 （0表示关闭，1表示开启）
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:type forKey:@"type"];
    if (notificationSwitch.on) {
        [param setObject:@1 forKey:@"value"];
    } else {
        [param setObject:@0 forKey:@"value"];
    }
    [ATOMShowSettings setPushSetting:param withBlock:^(NSError *error) {
        if (error) {
        }
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


@end
