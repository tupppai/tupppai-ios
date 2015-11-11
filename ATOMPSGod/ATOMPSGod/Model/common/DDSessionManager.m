//
//  DDSessionManager.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDSessionManager.h"

@implementation DDSessionManager

static dispatch_once_t onceToken;
static DDSessionManager *_shareHTTPSessionManager = nil;

+ (instancetype)shareHTTPSessionManager {
    dispatch_once(&onceToken, ^{
//        NSString *baseURL = @"http://android.loiter.us/v1/";
#if DEBUG
            NSString *baseURL = @"http://api.loiter.us/";
#else
        NSString *baseURL = @"http://api.qiupsdashen.com/";
#endif
        _shareHTTPSessionManager = [[DDSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
//        [_shareHTTPSessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            switch (status) {
//                case AFNetworkReachabilityStatusUnknown:
//                    NSLog(@"未知网络");
//                    break;
//                case AFNetworkReachabilityStatusNotReachable:
//                    NSLog(@"网络连接失败");
//                    break;
//                case AFNetworkReachabilityStatusReachableViaWWAN:
//                    NSLog(@"3G网络已连接");
//                    break;
//                case AFNetworkReachabilityStatusReachableViaWiFi:
//                    NSLog(@"WiFi网络已连接");
//                    break;
//                default:
//                    break;
//            }
//        }];
//        [_shareHTTPSessionManager.reachabilityManager startMonitoring];
        _shareHTTPSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _shareHTTPSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//        [_shareHTTPSessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//        [_shareHTTPSessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [_shareHTTPSessionManager.requestSerializer setTimeoutInterval:8];
    });
    return _shareHTTPSessionManager;
}













@end