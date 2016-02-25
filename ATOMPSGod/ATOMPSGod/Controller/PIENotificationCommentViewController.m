//
//  PIENotificationCommentViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/14/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationCommentViewController.h"
#import "PIENotificationVM.h"
#import "PIERefreshTableView.h"
#import "PIENotificationManager.h"
#import "PIENotificationCommentOnImageTableViewCell.h"
#import "PIENotificationCommentFromOtherTableViewCell.h"
#import "PIECommentViewController.h"
#import "PIEFriendViewController.h"

/* Variables */
@interface PIENotificationCommentViewController ()

@property (nonatomic, strong) NSMutableArray<PIENotificationVM *> *source_comment;
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, assign) NSInteger           currentIndex;
@property (nonatomic, assign) BOOL                canRefreshFooter;
@property (nonatomic, assign) BOOL                isfirstLoading;

@end

/* Protocols */
@interface PIENotificationCommentViewController (UITableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIENotificationCommentViewController (PIERefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIENotificationCommentViewController (DZNEmptyDataSet)
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@implementation PIENotificationCommentViewController

static NSString * PIENotificationCommentOnImageCellIdentifier =
@"PIENotificationCommentOnImageTableViewCell";

static NSString * PIENotificationCommentFromOtherCellIdentifier =
@"PIENotificationCommentFromOtherTableViewCell";


#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收到的消息";
    
    [self setupData];
    
    [self setupUI];
    
    [self setupGesture];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}


#pragma mark - data setup
- (void)setupData
{
    _source_comment   = [NSMutableArray<PIENotificationVM *> array];
    _canRefreshFooter = YES;
    _isfirstLoading   = YES;
}

#pragma mark - UI setup
- (void)setupUI
{
    self.view                           = self.tableView;
    self.tableView.emptyDataSetSource   = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - Gestures
- (void)setupGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(tapOnTableView:)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)tapOnTableView:(UITapGestureRecognizer *)tap
{
    CGPoint tapTableViewLocation
    = [tap locationInView:self.tableView];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForRowAtPoint:tapTableViewLocation];

    PIENotificationVM *viewModel   = self.source_comment[selectedIndexPath.row];
    PIEPageVM *pageVM              = [self transformNotificationVMToPageVM:viewModel];
    
    /*
        回复 -> PIECommentVC，没Header
        container -> PIECommentVC, 有Header
     */
    if (viewModel.originalCommentId == 0) {
        PIENotificationCommentOnImageTableViewCell *commentOnImageCell =
        [self.tableView cellForRowAtIndexPath:selectedIndexPath];
        
        CGPoint tapCellLocation = [tap locationInView:commentOnImageCell];
        
        if (CGRectContainsPoint(commentOnImageCell.replyLabel.frame,
                                tapCellLocation))
        {
            PIECommentViewController *commentVC = [[PIECommentViewController alloc] init];
            commentVC.shouldShowHeaderView = NO;
            commentVC.vm = pageVM;
            
            [self.navigationController pushViewController:commentVC animated:YES];
        }
        else if
            (CGRectContainsPoint(commentOnImageCell.containerView.frame, tapCellLocation))
        {
            PIECommentViewController *commentVC = [[PIECommentViewController alloc] init];
            commentVC.shouldShowHeaderView = YES;
            commentVC.vm = pageVM;
            [self.navigationController pushViewController:commentVC animated:YES];
        }
        else if
            (CGRectContainsPoint(commentOnImageCell.avatarView.frame,
                                 tapCellLocation) ||
             CGRectContainsPoint(commentOnImageCell.usernameLabel.frame,
                                 tapCellLocation))
        {
                PIEFriendViewController* friendVC =
                [PIEFriendViewController new];
                friendVC.pageVM = pageVM;

                [self.navigationController pushViewController:friendVC
                                                     animated:YES];
        }
    }else{
        PIENotificationCommentFromOtherTableViewCell *commentFromOtherCell =
        [self.tableView cellForRowAtIndexPath:selectedIndexPath];
        
        CGPoint tapCellLocation = [tap locationInView:commentFromOtherCell];
        
        if (CGRectContainsPoint(commentFromOtherCell.replyLabel.frame,
                                tapCellLocation)) {
            PIECommentViewController *commentVC = [[PIECommentViewController alloc] init];
            commentVC.shouldShowHeaderView = NO;
            commentVC.vm = pageVM;
            
            [self.navigationController pushViewController:commentVC animated:YES];
        }
        else if
            (CGRectContainsPoint(commentFromOtherCell.containerView.frame,
                                 tapCellLocation))
        {
            PIECommentViewController *commentVC = [[PIECommentViewController alloc] init];
            commentVC.shouldShowHeaderView = YES;
            commentVC.vm = pageVM;
            [self.navigationController pushViewController:commentVC animated:YES];
        }
        else if
            (CGRectContainsPoint(commentFromOtherCell.usernameLabel.frame,
                                 tapCellLocation) ||
             CGRectContainsPoint(commentFromOtherCell.avatarView.frame,
                                 tapCellLocation))
        {
            PIEFriendViewController* friendVC =
            [PIEFriendViewController new];
            friendVC.pageVM = pageVM;
            
            [self.navigationController pushViewController:friendVC
                                                 animated:YES];
        }
        
    }
}

#pragma mark - Network request for Data Models
- (void)getDataSource{
    [self.tableView.mj_footer endRefreshing];
    _currentIndex = 1;
    
    WS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [params setObject:@(1) forKey:@"page"];
    [params setObject:@(timeStamp) forKey:@"last_updated"];
    [params setObject:@(15) forKey:@"size"];
    [params setObject:@"comment" forKey:@"type"];
    
    [PIENotificationManager
     getNotifications:params
     block:^(NSArray *source_comment) {
         _isfirstLoading = NO;
         if (source_comment.count > 0) {
             weakSelf.source_comment = [source_comment mutableCopy];
             _canRefreshFooter = YES;
         }else{
             _canRefreshFooter = NO;
         }
         [weakSelf.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
     }];
    
}

- (void)getMoreDataSource{
    [self.tableView.mj_header endRefreshing];
    
    _currentIndex ++;
    
    WS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [params setObject:@(_currentIndex) forKey:@"page"];
    [params setObject:@(timeStamp) forKey:@"last_updated"];
    [params setObject:@(15) forKey:@"size"];
    [params setObject:@"comment" forKey:@"type"];
    
    [PIENotificationManager
     getNotifications:params
     block:^(NSArray *source_comment) {
         [self.tableView.mj_footer endRefreshing];
         if (source_comment.count < 15) {
             _canRefreshFooter = NO;
         }
         else{
             _canRefreshFooter = YES;
         }
         [weakSelf.source_comment addObjectsFromArray:source_comment];
         [weakSelf.tableView reloadData];
     }];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _source_comment.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIENotificationVM *vm = [_source_comment objectAtIndex:indexPath.row];
    
    if (vm.originalCommentId == 0) {
        /*
            原始评论ID为0，说明本次评论的消息来自于他人对图片（求P或帮P）的评论, desc字段为图片的描述
         */
        PIENotificationCommentOnImageTableViewCell *commentOnImageCell =
        [tableView
         dequeueReusableCellWithIdentifier:PIENotificationCommentOnImageCellIdentifier];
        
        [commentOnImageCell injectSauce:vm];
        
        return commentOnImageCell;
    }else{
        /*
            原始评论ID不为零，说明本次评论的消息来自于他人对本用户评论的评论， desc字段为原评论
         */
        
        PIENotificationCommentFromOtherTableViewCell *commentFromOtherCell =
        [tableView
         dequeueReusableCellWithIdentifier:PIENotificationCommentFromOtherCellIdentifier];
        
        [commentFromOtherCell injectSauce:vm];
        
        return commentFromOtherCell;
        
    }
    return nil;
    
}

#pragma mark - <UITableViewDelegate>
/* nothing yet */

#pragma mark - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshUp:(UITableView *)tableView
{
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    }else {
        [Hud text:@"已经拉到底啦"];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)didPullRefreshDown:(UITableView *)tableView
{
    [self getDataSource];
}

#pragma mark - <DZNEmptyDataSetSource>
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"pie_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无收到的评论喔～";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return  [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


#pragma mark - <DZNEmptyDataSetDelegate>
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    /**
     如果是第一次点击页面导致没有数据的话，不要显示这个空白页
     */
    if (_isfirstLoading) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}


#pragma mark - lazy loadings
- (PIERefreshTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[PIERefreshTableView alloc] init];
        
        UINib *commentOnImageCellNib =
        [UINib nibWithNibName:@"PIENotificationCommentOnImageTableViewCell"
                       bundle:nil];
        [_tableView registerNib:commentOnImageCellNib
         forCellReuseIdentifier:PIENotificationCommentOnImageCellIdentifier];
        
        
        UINib *commentFromOtherCellNib =
        [UINib nibWithNibName:@"PIENotificationCommentFromOtherTableViewCell"
                       bundle:nil];
        [_tableView registerNib:commentFromOtherCellNib
         forCellReuseIdentifier:PIENotificationCommentFromOtherCellIdentifier];
        
        
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.psDelegate = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 10);
        
        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight          = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma mark - private helpers
- (PIEPageVM*)transformNotificationVMToPageVM:(PIENotificationVM*)vm {
    PIEPageModel *model = [PIEPageModel new];
    model.imageURL    = vm.imageUrl;
    model.ID          = vm.targetID;
    model.askID       = vm.askID;
    model.type = vm.targetType;
    model.avatar   = vm.avatarUrl;
    model.uid      = vm.senderID;
    model.nickname    = vm.username;
    PIEPageVM* pageVM  = [[PIEPageVM alloc]initWithPageEntity:model];
    return pageVM;
}

@end
