//
//  ATOMMyViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyConcernViewController.h"
#import "ATOMMyConcernTableViewCell.h"
#import "ATOMMyConcernTableHeaderView.h"
#import "ATOMMyConcernTableFooterView.h"

@interface ATOMMyConcernViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *myConcernView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ATOMMyConcernViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"我的关注";
    _myConcernView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myConcernView;
    _tableView = [[UITableView alloc] initWithFrame:_myConcernView.bounds];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _tableView.tableFooterView = [UIView new];
    [_myConcernView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - Click Event

- (void)clickAttentionButton:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor colorWithHex:0x838383];
        [button setTitle:@"相互关注" forState:UIControlStateNormal];
    } else {
        button.backgroundColor = [UIColor colorWithHex:0x00adef];
        [button setTitle:@"关注" forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 28.5;
    } else if (section == 1) {
        return 0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        ATOMMyConcernTableFooterView *footerView = [ATOMMyConcernTableFooterView new];
        return footerView;
    } else if (section == 1) {
        return nil;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ATOMMyConcernTableHeaderView *headerView = [ATOMMyConcernTableHeaderView new];
    if (section == 0) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0xf80630];
        headerView.titleLabel.text = @"推荐关注";
    } else if (section == 1) {
        headerView.littleVerticalView.backgroundColor = [UIColor colorWithHex:0x00adef];
        headerView.titleLabel.text = @"我的关注";
    }
    return headerView;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyConcernCell";
    ATOMMyConcernTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMyConcernTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.attentionButton addTarget:self action:@selector(clickAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}




















@end
