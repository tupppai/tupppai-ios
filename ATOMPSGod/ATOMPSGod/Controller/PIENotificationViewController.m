//
//  PIENotificationViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationViewController.h"

@interface PIENotificationViewController ()
@property (nonatomic, strong) NSMutableArray *source;

@end

@implementation PIENotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _source = [NSMutableArray array];
    [self getDataSource];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
//    _currentPage = 1;
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDService ddGetNotifications:param withBlock:^(id data) {
        
    }];}


@end
