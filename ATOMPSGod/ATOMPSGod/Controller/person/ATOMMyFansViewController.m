//
//  ATOMMyFansViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyFansViewController.h"
#import "ATOMMyFansTableViewCell.h"

@interface ATOMMyFansViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *myFansView;

@end

@implementation ATOMMyFansViewController

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"我的粉丝";
    _myFansView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myFansView;
    _tableView = [[UITableView alloc] initWithFrame:_myFansView.bounds];
    _tableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _tableView.tableFooterView = [UIView new];
    [_myFansView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - Click Event

- (void)clickCellAttentionButton:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor colorWithHex:0x838383];
        [button setTitle:@"相互关注" forState:UIControlStateNormal];
    } else {
        button.backgroundColor = [UIColor colorWithHex:0x00adef];
        [button setTitle:@"关注" forState:UIControlStateNormal];
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
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyFansCell";
    ATOMMyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMyFansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.attentionButton addTarget:self action:@selector(clickCellAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
    
}



@end
