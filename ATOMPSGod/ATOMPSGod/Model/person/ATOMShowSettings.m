//
//  ATOMShowSettings.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/28/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMShowSettings.h"

@implementation ATOMShowSettings

+ (NSURLSessionDataTask *)getPushSetting:(NSDictionary *)param withBlock:(void (^)(NSDictionary *, NSError *))block {
    NSLog(@"getPushSetting param %@ ",param);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager]GET:@"user/get_push_settings" parameters:param success:^(NSURLSessionDataTask *task
, id responseObject) {
        NSLog(@"getPushSetting responseObject%@",responseObject);
        NSString* info = (NSString*)responseObject[@"info"];
        NSLog(@"getPushSetting info %@",info);
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
            if (block) {
                //                block(, nil);
            }
        } else {
            [Util TextHud:@"出现未知错误"];
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task
, NSError *error) {
        [Util TextHud:@"出现未知错误"];
        if (block) {
            block(nil, error);
        }
        NSLog(@"%@",error);
    }];

}



+ (NSURLSessionDataTask *)setPushSetting:(NSDictionary *)param withBlock:(void (^)(NSDictionary *, NSError *))block {
    NSLog(@"setPushSetting param %@ ",param);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:@"user/set_push_settings" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"toggleSetting param %@ responseObject%@",param,responseObject);
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        NSString* info = (NSString*)responseObject[@"info"];
        NSLog(@"toggleSetting info %@",info);
        if (ret == 1) {
            if (block) {
                //                block(, nil);
            }
        } else {
            [Util TextHud:@"出现未知错误"];
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util TextHud:@"出现未知错误"];
        if (block) {
            block(nil, error);
        }
        NSLog(@"%@",error);
    }];
}
@end
