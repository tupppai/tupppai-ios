//
//  DDSessionManager.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDSessionManager.h"

@implementation DDSessionManager

static DDSessionManager *shareInstance = nil;

+ (instancetype)shareHTTPSessionManager {
    if (shareInstance == nil) {
        NSString *baseURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"BASEURL"];
        shareInstance = [[DDSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        shareInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
        shareInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        [shareInstance.requestSerializer setTimeoutInterval:8];
    }
    return shareInstance;

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

}

/**
 *  清理本地cookies，并且重置shareHttpSessionManger
 */
+ (void)resetSharedInstance {
    NSArray *cookies =
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: shareInstance.baseURL];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    shareInstance = nil;
}
@end




@implementation AFHTTPSessionManager(tracking)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(dataTaskWithHTTPMethod:URLString:parameters:success:failure:);
        SEL swizzledSelector = @selector(xxx_dataTaskWithHTTPMethod:URLString:parameters:success:failure:);
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

-(NSURLSessionDataTask *)xxx_dataTaskWithHTTPMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    
    /*签名
     parameters根据key从小到大排序，把排序后对应的value拼接成string1
     string2 = md5(tupppaisignmd5)
     string3 = 当月的第几天
     string4 = string1~string2~string3
     string5 = [[[string4 lowercase] md5]md5]
     string5就是签名
     */
    NSArray *sortedKeys = [[parameters allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    for (NSString *key in sortedKeys) {
        NSObject *obj = [parameters objectForKey: key];
        
        //array->jsonString再去签名
        if ([obj isKindOfClass:[NSArray class]]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]lowercaseString];
            [sortedValues addObject: jsonString];
        } else {
            [sortedValues addObject: obj];
        }

    }

    NSString *jointValuesString = [sortedValues componentsJoinedByString:@""];

    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay) fromDate:date];
    NSInteger dayOfMonth = [components day];
    
    NSString *jointString =
    [[NSString stringWithFormat:@"%@%@%zd",jointValuesString,[@"tupppaisignmd5" md5],dayOfMonth]lowercaseString];
    
    NSString *signingString = [[jointString md5]md5];
    
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setObject:signingString forKey:@"verify"];
    [params setObject:@"2" forKey:@"v"];
    
    return [self xxx_dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters success:^(NSURLSessionDataTask * dataTask, id responseObject) {
        
#if DEBUG
        NSLog(@"%@,%@,%@",URLString,params,responseObject);
#endif
        if (responseObject) {
            

            int ret = [[ responseObject objectForKey:@"ret"] intValue];
            if (ret == 2) {
                // 服务器没有监测到“登陆态”——需要用户重新登录, 或者是因为游客状态想要做一些对服务器有着“写”操作的行为
                
                if ([DDUserManager currentUser].uid == kPIETouristUID) {
                    // 游客    -> "没有登录态" == "完成注册的最后一步：绑定手机号"
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:PIENetworkCallForFurtherRegistrationNotification
                     object:nil
                     userInfo:nil];
                }
                else{
                    // 正常用户 -> "没有登录态" == "重新登录"
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NetworkSignOutCall" object:nil]];
                }
            } else if (ret != 1) {
                
                // ret != 1, 表示网络不正常，或者是某种数据的异常, 向用户显示info字段的消息
                NSString* info = [responseObject objectForKey:@"info"];
                NSDictionary* userInfo = [NSDictionary dictionaryWithObject:info forKey:@"info"];
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NetworkShowInfoCall" object:nil userInfo:userInfo]];
            }
        }
        success(dataTask,responseObject);
    } failure:^(NSURLSessionDataTask * dataTask, NSError * error) {
                if (error) {
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NetworkErrorCall" object:nil]];
                }
        failure(dataTask,error);
    }

            ];
}



@end