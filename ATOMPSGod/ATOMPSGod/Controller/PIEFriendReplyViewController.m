//
//  PIEFriendReplyViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendReplyViewController.h"
#import "DDOtherUserManager.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEFriendReplyViewController ()
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation PIEFriendReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _source = [NSMutableArray array];
    [self getDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - GetDataSource
- (void)getDataSource {
        WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
        [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(1) forKey:@"page"];
    [_source removeAllObjects];
    _currentIndex = 1;
    [DDOtherUserManager getFriendReply:param withBlock:^(NSMutableArray *returnArray) {
        for (PIEPageEntity *entity in returnArray) {
            DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
            [ws.source addObject:vm];
        }
    }];
}
@end
