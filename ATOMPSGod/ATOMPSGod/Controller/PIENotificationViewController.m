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

#import "PIENotificationSystemTableViewCell.h"
#import "PIENotificationReplyTableViewCell.h"
#import "PIENotificationLikeTableViewCell.h"
#import "PIENotificationFollowTableViewCell.h"
#import "PIENotificationCommentTableViewCell.h"

@interface PIENotificationViewController ()<UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, strong) PIERefreshTableView *tableView;

@end

@implementation PIENotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _source = [NSMutableArray array];
    self.view = self.tableView;
    [self getDataSource];

}

#pragma mark - GetDataSource
- (void)getDataSource {
    WS(ws);
    NSLog(@"getDataSource PIENotificationViewController");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
//    _currentPage = 1;
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [PIENotificationManager getNotifications:param block:^(NSArray *source) {
        ws.source = [source mutableCopy];
        [ws.tableView reloadData];
    }];
}

-(PIERefreshTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PIERefreshTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TAB_HEIGHT-NAV_HEIGHT)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.psDelegate = self;
        UINib* nib  = [UINib nibWithNibName:@"PIENotificationCommentTableViewCell" bundle:nil];
        UINib* nib2 = [UINib nibWithNibName:@"PIENotificationLikeTableViewCell" bundle:nil];
        UINib* nib3 = [UINib nibWithNibName:@"PIENotificationFollowTableViewCell" bundle:nil];
        UINib* nib4 = [UINib nibWithNibName:@"PIENotificationReplyTableViewCell" bundle:nil];
        UINib* nib5 = [UINib nibWithNibName:@"PIENotificationSystemTableViewCell" bundle:nil];
        [_tableView registerNib:nib  forCellReuseIdentifier:@"PIENotificationCommentTableViewCell"];
        [_tableView registerNib:nib2 forCellReuseIdentifier:@"PIENotificationLikeTableViewCell"];
        [_tableView registerNib:nib3 forCellReuseIdentifier:@"PIENotificationFollowTableViewCell"];
        [_tableView registerNib:nib4 forCellReuseIdentifier:@"PIENotificationReplyTableViewCell"];
        [_tableView registerNib:nib5 forCellReuseIdentifier:@"PIENotificationSystemTableViewCell"];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
            case PIENotificationTypeLike:
            {
                PIENotificationLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationLikeTableViewCell"];
                [cell injectSauce:vm];
                return cell;
                break;
            }
            case PIENotificationTypeReply:
            {
                PIENotificationReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationReplyTableViewCell"];
                [cell injectSauce:vm];
                return cell;
                break;
            }
            case PIENotificationTypeSystem:
            {
                PIENotificationSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIENotificationSystemTableViewCell"];
                [cell injectSauce:vm];
                return cell;
                break;
                
            }
            default:
                break;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIENotificationVM* vm = [_source objectAtIndex:indexPath.row];
    switch (vm.type) {
        case PIENotificationTypeComment:
             return 109;
            break;
        case PIENotificationTypeFollow:
            return 60;
            break;
        case PIENotificationTypeLike:
            return 60;
            break;
        case PIENotificationTypeReply:
            return 105;
            break;
        case PIENotificationTypeSystem:
            return 100;
            break;
        default:
            break;
    }
    NSLog(@"return 0");
    return 0;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _source.count;
}



@end
