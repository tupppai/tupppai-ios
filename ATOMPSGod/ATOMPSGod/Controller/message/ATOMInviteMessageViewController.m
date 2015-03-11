//
//  ATOMInviteMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteMessageViewController.h"
#import "ATOMInviteMessageTableViewCell.h"
#import "ATOMNoDataView.h"

@interface ATOMInviteMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *inviteMessageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ATOMNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ATOMInviteMessageViewController

#pragma mark - Lazy Initialize

- (ATOMNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [ATOMNoDataView new];
    }
    return _noDataView;
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _dataSource = [NSMutableArray array];
    [_tableView reloadData];
}

- (void)createUI {
    self.title = @"邀请通知";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _inviteMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _inviteMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_inviteMessageView.bounds];
    _tableView.tableFooterView = [UIView new];
    [_inviteMessageView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - Click Event

- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    [_dataSource removeAllObjects];
    if (_dataSource.count == 0) {
        self.view = self.noDataView;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InviteMessageCell";
    ATOMInviteMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMInviteMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}
































@end
