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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 36;
    } else {
        return 53;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AccountBindingCell";
    ATOMAccountBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMAccountBindingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.rightButton addTarget:self action:@selector(clickCellRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.themeImageView.image = [UIImage imageNamed:@"weibo"];
        cell.themeLabel.text = @"新浪微博";
    } else if (row == 1) {
        cell.themeImageView.image = [UIImage imageNamed:@"qq"];
        cell.themeLabel.text = @"QQ";
    } else if (row == 2) {
        cell.themeImageView.image = [UIImage imageNamed:@"wechat"];
        cell.themeLabel.text = @"微信";
        cell.rightButton.hidden = YES;
    } else if (row == 3) {
        cell.themeImageView.image = [UIImage imageNamed:@"tel"];
        cell.phoneNumber = @"17731321949";
        [cell.rightButton setTitle:@"修改" forState:UIControlStateNormal];
    } else if (row == 4) {
        [cell setFootCell];
    }
    return cell;
    
}
















@end
