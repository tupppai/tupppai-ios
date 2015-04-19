//
//  ATOMHTTPRequestOperationManager.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHTTPRequestOperationManager.h"

@implementation ATOMHTTPRequestOperationManager

static dispatch_once_t onceToken;
static ATOMHTTPRequestOperationManager *_sharedRequestOperationManager = nil;

+ (instancetype)sharedRequestOperationManager {
    dispatch_once(&onceToken, ^{
        NSString *baseURL = @"http://android.loiter.us/v1/";
//        NSString *baseURL = @"http://android.qiupsdashen.com/v1/";
        _sharedRequestOperationManager = [[ATOMHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        [_sharedRequestOperationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"网络连接失败");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3G网络已连接");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"WiFi网络已连接");
                    break;
                default:
                    break;
            }
        }];
        [_sharedRequestOperationManager.reachabilityManager startMonitoring];
//        _sharedRequestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sharedRequestOperationManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [_sharedRequestOperationManager.requestSerializer setTimeoutInterval:25];
        [_sharedRequestOperationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _sharedRequestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return _sharedRequestOperationManager;
}



















@end