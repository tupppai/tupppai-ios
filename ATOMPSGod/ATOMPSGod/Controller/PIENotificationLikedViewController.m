//
//  PIENotificationLikedViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/26/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationLikedViewController.h"
#import "PIERefreshTableView.h"
#import "PIENotificationManager.h"
#import "PIENotificationVM.h"
#import "PIENotificationLikeTableViewCell.h"
#import "PIEFriendViewController.h"
#import "PIECarouselViewController2.h"

@interface PIENotificationLikedViewController ()<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;

@end

@implementation PIENotificationLikedViewController
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收到的赞";
    _source = [NSMutableArray array];
    _canRefreshFooter = YES;
    _isfirstLoading = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.view = self.tableView;
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];

}


#pragma mark - GetDataSource
- (void)getDataSource {
    _currentIndex = 1;
    [self.tableView.mj_footer endRefreshing];
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@"like" forKey:@"type"];
    
    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        ws.isfirstLoading = NO;
        if (source.count>0) {
            ws.source = [source mutableCopy];
            _canRefreshFooter = YES;
        }
        else {
            _canRefreshFooter = NO;
        }
        
        [ws.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - GetDataSource
- (void)getMoreDataSource {
    [self.tableView.mj_header endRefreshing];
    _currentIndex++;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@"like" forKey:@"type"];
    
    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        if (source.count>0) {
            [ws.source addObjectsFromArray:source];
            [ws.tableView reloadData];
            _canRefreshFooter = YES;
        }
        else {
            _canRefreshFooter = NO;
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}
-(PIERefreshTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PIERefreshTableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.psDelegate = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 10);
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnTableView:)];
        [_tableView addGestureRecognizer:tapGes];
        
        UINib* nib2 = [UINib nibWithNibName:@"PIENotificationLikeTableViewCell" bundle:nil];
        [_tableView registerNib:nib2 forCellReuseIdentifier:@"PIENotificationLikeTableViewCell"];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tapOnTableView:(UITapGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    if (selectedIndexPath.section == 0) {
        PIENotificationVM* vm = [_source objectAtIndex:selectedIndexPath.row];
            PIENotificationLikeTableViewCell* cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
            CGPoint p = [gesture locationInView:cell];
       if (CGRectContainsPoint(cell.avatarView.frame,p) || (CGRectContainsPoint(cell.usernameLabel.frame,p))) {
                PIEFriendViewController* vc = [PIEFriendViewController new];
                vc.uid = vm.senderID;
                vc.name = vm.username;
                [self.navigationController pushViewController:vc animated:YES];
       } else  if (CGRectContainsPoint(cell.pageImageView.frame,p)) {
                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                PIEPageVM* pageVM = [self transformNotificationVMToPageVM:vm];
                vc.pageVM = pageVM;
                [self.navigationController presentViewController:vc animated:YES completion:nil];

//                [self.navigationController pushViewController:vc animated:YES];
            }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_source.count > indexPath.row) {
        PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
        PIENotificationLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationLikeTableViewCell"];
        [cell injectSauce:vm];
        return cell;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _source.count;
}


#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没收到赞喔～";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_isfirstLoading;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - private helpers
- (PIEPageVM*)transformNotificationVMToPageVM:(PIENotificationVM*)vm {
    PIEPageModel* model = [PIEPageModel new];
    model.ID = vm.model.targetID;
    model.type = vm.model.targetType;
    model.imageURL = vm.model.imageUrl;
    model.avatar = vm.model.avatarUrl;
    model.askID = vm.model.askID;
    model.nickname = vm.model.username;
    model.uid = vm.model.senderID;
    model.uploadTime = vm.model.time;
    PIEPageVM* pageVM  = [[PIEPageVM alloc]initWithPageEntity:model];
    return pageVM;
}


@end