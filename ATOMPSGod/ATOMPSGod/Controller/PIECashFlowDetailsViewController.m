//
//  PIECashFlowDetailsViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/21/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECashFlowDetailsViewController.h"
#import "PIERefreshTableView.h"

@interface PIECashFlowDetailsViewController ()
<
    UITableViewDelegate,UITableViewDataSource,
    PWRefreshBaseTableViewDelegate
>

@end

@implementation PIECashFlowDetailsViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UI basic setup
- (void)setupNavBar
{
    self.navigationItem.title = @"零钱明细";
}

- (void)setupSubviews
{
    PIERefreshTableView *tableView = ({
        PIERefreshTableView *tableView = [[PIERefreshTableView alloc] init];
        tableView.delegate   = self;
        tableView.dataSource = self;
        tableView;
    });
    
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - <UITableViewDelegate>



@end
