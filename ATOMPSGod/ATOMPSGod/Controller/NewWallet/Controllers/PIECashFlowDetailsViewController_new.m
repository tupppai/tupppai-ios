//
//  PIECashFlowDetailsViewController_new.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/4/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECashFlowDetailsViewController_new.h"
#import "LxDBAnything.h"
#import "PIERefreshTableView.h"
#import "PIECashFlowModel.h"
#import "PIEMyWalletManager.h"
#import "PIECashFlowDetailTableViewCell.h"


@interface PIECashFlowDetailsViewController_new ()
<
    /* Protocols */
    UITableViewDelegate, UITableViewDataSource,
    PWRefreshBaseTableViewDelegate
>

@property (nonatomic, strong) NSMutableArray <PIECashFlowModel *> *source_cashFlow;
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation PIECashFlowDetailsViewController_new

static NSString *PIECashFlowDetailTableViewCellIdentifier =
@"PIECashFlowDetailTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupData];
    [self setupSubviews];
    
    [self loadNewCashFlowDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI components setup
- (void)setupSubviews
{
    PIERefreshTableView *tableView = ({
        PIERefreshTableView *tableView = [[PIERefreshTableView alloc] init];
        tableView.delegate   = self;
        tableView.dataSource = self;
        tableView.psDelegate = self;
        
        tableView.showsVerticalScrollIndicator   = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        
        
        tableView.mj_header.hidden = YES;
        
        tableView.separatorColor =
        UITableViewCellSeparatorStyleNone;
        
        // register cell
        [tableView registerNib:[UINib nibWithNibName:@"PIECashFlowDetailTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:PIECashFlowDetailTableViewCellIdentifier];
        
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
    self.tableView = tableView;
}

#pragma mark - Data Initial setup
- (void)setupData
{
    _canRefreshFooter = YES;
    _source_cashFlow  = [NSMutableArray<PIECashFlowModel *> new];
    _currentIndex     = 1;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _source_cashFlow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIECashFlowDetailTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:PIECashFlowDetailTableViewCellIdentifier];
    [cell injectModel:_source_cashFlow[indexPath.row]];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshUp:(UITableView *)tableView
{
    [self loadMoreCashFlowDetails];
}

#pragma mark - Network request
- (void)loadNewCashFlowDetails
{
    _currentIndex = 1;
    NSDictionary *params = @{@"page":@(_currentIndex),
                             @"size":@10};
    @weakify(self);
    [PIEMyWalletManager
     transactionDetails:params
     block:^(NSArray<PIECashFlowModel *> *retArray) {
         @strongify(self);
         [_source_cashFlow removeAllObjects];
         [_source_cashFlow addObjectsFromArray:retArray];
         [self.tableView reloadData];
     } failure:^{
         /* do nothing */
     }];
}

- (void)loadMoreCashFlowDetails
{
    _currentIndex ++;
    NSDictionary *params = @{@"page":@(_currentIndex),
                             @"size":@10};
    
    @weakify(self);
    [PIEMyWalletManager
     transactionDetails:params
     block:^(NSArray<PIECashFlowModel *> *retArray) {
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
         [_source_cashFlow addObjectsFromArray:retArray];
         [self.tableView reloadData];
     } failure:^{
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
     }];
}

@end
