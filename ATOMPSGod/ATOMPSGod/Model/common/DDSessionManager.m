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
        
        
//        NSString *baseURL = @"http://api.qiupsdashen.com/";

        NSString *baseURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"BASEURL"];

//#if DEBUG
//        NSString *baseURL = @"http://api.loiter.us/";
//#elif ADHOC
//        NSString *baseURL = @"http://api.loiter.us/";
//#else
//        NSString *baseURL = @"http://api.qiupsdashen.com/";
//#endif

        
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

+ (void)resetSharedInstance {
    _shareHTTPSessionManager = nil;
    NSString *baseURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"BASEURL"];
    _shareHTTPSessionManager = [[DDSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
}
@end




@implementation AFHTTPSessionManager(tracking)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(dataTaskWithRequest:completionHandler:);
        SEL swizzledSelector = @selector(xxx_dataTaskWithRequest:completionHandler:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

-(NSURLSessionDataTask *)xxx_dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    return [self xxx_dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        #if DEBUG
                NSLog(@"request  %@ \n responseObject \n %@ ,%@",request,responseObject,error);
        #endif
        
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NetworkErrorCall" object:nil]];
        }
        if (responseObject) {
            int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
            if (ret == 2) {
                // 服务器没有监测到“登陆态”——需要用户重新登录, 或者是因为游客状态想要做一些对服务器有着“写”操作的行为
                
                if ([DDUserManager currentUser].uid == kPIETouristUID) {
                    // 游客    -> "没有登录态" == "完成注册的最后一步：绑定手机号"
                    NSString *openID = [[NSUserDefaults standardUserDefaults]
                                        objectForKey:PIETouristOpenIdKey];
                    
                    NSString *prompt = [NSString stringWithFormat:
                                        @"ret == 2，游客没有登陆态\n openid = %@", openID];
                    [Hud text:prompt];
                    
                    // post notification
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:PIENetworkCallForFurtherRegistrationNotification
                     object:nil
                     userInfo:nil];
                }
                else{
                    // 正常用户 -> "没有登录态" == "重新登录"
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NetworkSignOutCall" object:nil]];
                    [Hud text:@"ret == 2, 正常用户没有登录态"];
                }
            } else if (ret != 1) {
                
                // ret != 1, 表示网络不正常，或者是某种数据的异常, 向用户显示info字段的消息
                
                NSString* info = [responseObject objectForKey:@"info"];
                NSDictionary* userInfo = [NSDictionary dictionaryWithObject:info forKey:@"info"];
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NetworkShowInfoCall" object:nil userInfo:userInfo]];
            }
        }
        if (completionHandler) {
            completionHandler(response,responseObject,error);
        }
    }];
}


@end