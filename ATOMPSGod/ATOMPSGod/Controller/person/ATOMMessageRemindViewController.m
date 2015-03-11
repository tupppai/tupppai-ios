//
//  ATOMMessageRemindViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMessageRemindViewController.h"
#import "ATOMMessageRemindTableViewCell.h"

@interface ATOMMessageRemindViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ATOMMessageRemindViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [UIView new];
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageRemindCell";
    ATOMMessageRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMessageRemindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            cell.themeLabel.text = @"评论";
        } else if (row == 1) {
            cell.themeLabel.text = @"帖子回复";
        } else if (row == 2) {
            cell.themeLabel.text = @"帖子提醒";
        } else if (row == 3) {
            cell.themeLabel.text = @"邀请通知";
        } else if (row == 4) {
            cell.themeLabel.text = @"系统通知";
        } else if (row == 5) {
            cell.themeLabel.text = @"私聊";
        }
    }
    
    return cell;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static int padding10 = 10;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(padding10, padding10 * 0.5, SCREEN_WIDTH - padding10 * 2, 22.5 - padding10);
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, nil];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"打开后将推送相应内容的消息" attributes:attributeDict];
    titleLabel.attributedText = attributeStr;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHex:0xededed];
    [headerView addSubview:titleLabel];
    
    return headerView;
}














@end
