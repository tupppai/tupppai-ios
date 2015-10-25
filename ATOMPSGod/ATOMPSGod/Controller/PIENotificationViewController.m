//
//  PIENotificationViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationViewController.h"
#import "PIERefreshTableView.h"
#import "PIENotificationManager.h"
#import "PIENotificationVM.h"

//#import "PIENotificationSystemTableViewCell.h"
#import "PIENotificationReplyTableViewCell.h"
//#import "PIENotificationLikeTableViewCell.h"
#import "PIENotificationFollowTableViewCell.h"
#import "PIENotificationCommentTableViewCell.h"

@interface PIENotificationViewController ()<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation PIENotificationViewController
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _source = [NSMutableArray array];
    _canRefreshFooter = YES;
    self.view = self.tableView;
//    [self getDataSource];
    [self.tableView.header beginRefreshing];
}

#pragma mark - GetDataSource
- (void)getDataSource {
    _currentIndex = 1;
    [self.tableView.footer endRefreshing];
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        if (source.count>0) {
            ws.source = [source mutableCopy];
            [ws.tableView reloadData];
            _canRefreshFooter = YES;
        }
        else {
            _canRefreshFooter = NO;
        }
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - GetDataSource
- (void)getMoreDataSource {
    [self.tableView.header endRefreshing];
    _currentIndex++;
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        if (source.count>0) {
            [ws.source addObjectsFromArray:source];
            [ws.tableView reloadData];
            _canRefreshFooter = YES;
        }
        else {
            _canRefreshFooter = NO;
        }
        [self.tableView.footer endRefreshing];
    }];
}

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getDataSource];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [self.tableView.footer endRefreshing];
    }
}
-(PIERefreshTableView *)tableView {
    if (!_tableView) {
        _tableView = [PIERefreshTableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.psDelegate = self;
        UINib* nib  = [UINib nibWithNibName:@"PIENotificationCommentTableViewCell" bundle:nil];
//        UINib* nib2 = [UINib nibWithNibName:@"PIENotificationLikeTableViewCell" bundle:nil];
        UINib* nib3 = [UINib nibWithNibName:@"PIENotificationFollowTableViewCell" bundle:nil];
        UINib* nib4 = [UINib nibWithNibName:@"PIENotificationReplyTableViewCell" bundle:nil];
//        UINib* nib5 = [UINib nibWithNibName:@"PIENotificationSystemTableViewCell" bundle:nil];
        [_tableView registerNib:nib  forCellReuseIdentifier:@"PIENotificationCommentTableViewCell"];
//        [_tableView registerNib:nib2 forCellReuseIdentifier:@"PIENotificationLikeTableViewCell"];
        [_tableView registerNib:nib3 forCellReuseIdentifier:@"PIENotificationFollowTableViewCell"];
        [_tableView registerNib:nib4 forCellReuseIdentifier:@"PIENotificationReplyTableViewCell"];
//        [_tableView registerNib:nib5 forCellReuseIdentifier:@"PIENotificationSystemTableViewCell"];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (_source.count > indexPath.row) {
            PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
            switch (vm.type) {
                case PIENotificationTypeComment:
                {
                    PIENotificationCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationCommentTableViewCell"];
                    [cell injectSauce:vm];
                    return cell;
                    break;
                }
                case PIENotificationTypeFollow:
                {
                    PIENotificationFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationFollowTableViewCell"];
                    [cell injectSauce:vm];
                    return cell;
                    break;
                }
                    //            case PIENotificationTypeLike:
                    //            {
                    //                PIENotificationLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationLikeTableViewCell"];
                    //                [cell injectSauce:vm];
                    //                return cell;
                    //                break;
                    //            }
                case PIENotificationTypeReply:
                {
                    PIENotificationReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationReplyTableViewCell"];
                    [cell injectSauce:vm];
                    return cell;
                    break;
                }
                    //            case PIENotificationTypeSystem:
                    //            {
                    //                PIENotificationSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationSystemTableViewCell"];
                    //                [cell injectSauce:vm];
                    //                return cell;
                    //                break;
                    //                
                    //            }
                default:
                    return nil;
                    break;
            }
        }
    }
    else {

        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"notify_system"];
            cell.textLabel.text = @"系统消息";
        }    else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"pieLike_selected"];
            cell.textLabel.text = @"收到的赞";
        }

        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }else {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,40)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100,40)];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    label.font = [UIFont boldSystemFontOfSize:13];
    switch (section)
    {
        case 1:
            label.text  = @"最近消息";
            break;
        default:
            break;
    }
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
        switch (vm.type) {
            case PIENotificationTypeComment:
                return 109;
                break;
            case PIENotificationTypeFollow:
                return 60;
                break;
                //        case PIENotificationTypeLike:
                //            return 0;
                //            break;
            case PIENotificationTypeReply:
                return 105;
                break;
                //        case PIENotificationTypeSystem:
                //            return 0;
                //            break;
            default:
                return 105;
                break;
        }
    }
    else {
        return 50;
    }
    return 0;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return _source.count;
    }
}



@end
