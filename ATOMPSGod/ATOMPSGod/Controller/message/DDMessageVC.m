//
//  ATOMMyMessageViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMessageVC.h"
#import "ATOMMyMessageTableViewCell.h"
#import "DDMsgCommentVC.h"
#import "DDMsgInviteVC.h"
#import "DDMsgFollowVC.h"
#import "DDMsgPostReplyVC.h"

@interface DDMessageVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *myMessageView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DDMessageVC

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"ReceiveRemoteNotification" object:nil];
}

-(void)refreshTableView {
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createUI {
    self.navigationItem.title = @"我的消息";
    _myMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _myMessageView;
    _tableView = [[UITableView alloc] initWithFrame:_myMessageView.bounds];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [_myMessageView addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyMessageCell";
    ATOMMyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMMyMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_comment"];
        cell.imageView.frame = CGRectMake(100, 0, 0, 0);
        cell.textLabel.text = @"评论";
    } else if (row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_draft"];
        cell.textLabel.text = @"帖子回复";
    } else if (row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_follow"];
        cell.textLabel.text = @"关注通知";
    } else if (row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_invite"];
        cell.textLabel.text = @"邀请通知";
    } else if (row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"ic_news_setting"];
        cell.textLabel.text = @"系统通知";
    }
    NSString* badgeKey = [NSString stringWithFormat:@"NotifyType%zd",indexPath.row];
    cell.badgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:badgeKey]intValue];
    NSLog(@"number %d badgeKey %@",[[[NSUserDefaults standardUserDefaults]objectForKey:badgeKey]intValue],badgeKey);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.topViewController != self) {
        return;
    }
    NSInteger row = indexPath.row;
    
    //clear badge
    NSString* badgeKey = [NSString stringWithFormat:@"NotifyType%zd",row];
    [[NSUserDefaults standardUserDefaults]setObject:@(0) forKey:badgeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    ATOMMyMessageTableViewCell *cell = (ATOMMyMessageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.badgeNumber = 0;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (row == 0) {
        DDMsgCommentVC *cmvc = [DDMsgCommentVC new];
        [self pushViewController:cmvc animated:YES];
    } else if (row == 1) {
        DDMsgPostReplyVC *trmvc = [DDMsgPostReplyVC new];
        [self pushViewController:trmvc animated:YES];
    } else if (row == 2) {
        DDMsgFollowVC *cmvc = [DDMsgFollowVC new];
        [self pushViewController:cmvc animated:YES];
    } else if (row == 3) {
        DDMsgInviteVC *imvc = [DDMsgInviteVC new];
        [self pushViewController:imvc animated:YES];
    } else if (row == 4) {
        [Util showWeAreWorkingOnThisFeature];
    }
}





























@end
