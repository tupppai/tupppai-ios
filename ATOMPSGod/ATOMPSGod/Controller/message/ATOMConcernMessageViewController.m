//
//  ATOMConcernMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMConcernMessageViewController.h"
#import "ATOMConcernMessageTableViewCell.h"
#import "ATOMNoDataView.h"

@interface ATOMConcernMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *concernMessageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ATOMNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ATOMConcernMessageViewController

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
}

- (void)createUI {
    self.title = @"关注通知";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _concernMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _concernMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_concernMessageView.bounds];
    _tableView.tableFooterView = [UIView new];
    [_concernMessageView addSubview:_tableView];
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
    static NSString *CellIdentifier = @"ConcernMessageCell";
    ATOMConcernMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMConcernMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}


@end
