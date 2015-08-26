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
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager]GET:@"profile/get_push_settings" parameters:param success:^(NSURLSessionDataTask *task
, id responseObject) {
        NSString* info = (NSString*)[ responseObject objectForKey:@"info"];
        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
        if (ret == 1) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            if (block && data) {
                block(data,nil);
            }
        } else {
            
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task
, NSError *error) {
        
        if (block) {
            block(nil, error);
        }
        NSLog(@"%@",error);
    }];

}



+ (NSURLSessionDataTask *)setPushSetting:(NSDictionary *)param withBlock:(void (^)(NSError *))block {
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:@"profile/set_push_settings" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
        if (ret == 1) {
            if (block) {
                block(nil);
            }
        } else {
            NSError* error = [NSError new];
            if (block) {
                block(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}
+ (NSURLSessionDataTask *)setBindSetting:(NSDictionary *)param withToggleBind:(BOOL)bind withBlock:(void (^)(NSError *))block {
    NSString* url = bind?@"auth/bind":@"auth/unbind";
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"setBindSetting param %@ responseObject%@",param,responseObject);
        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
        NSString* info = (NSString*)[ responseObject objectForKey:@"info"];
        NSLog(@"setBindSetting info %@",info);
        if (ret == 1) {
            if (block) {
                block(nil);
            }
        } else {
            NSError* error = [NSError new];
            if (block) {
                block(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

@end
