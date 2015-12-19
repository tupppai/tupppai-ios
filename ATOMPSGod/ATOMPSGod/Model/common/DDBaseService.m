//
//  ATOMBaseRequest.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDBaseService.h"

@implementation DDBaseService

+ (void) GET :(NSDictionary*)param url:(NSString*)url block:(void (^)(id responseObject))block {
    if (url) {

//        NSLog(@"GET%@",param);

        [[DDSessionManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
            if (ret == 1) {
                if (block) {
                    block(responseObject);
                }
            } else {
                if (block) {
                    block(nil);
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) {
                block(nil);
            }
        }];
    }
    else if (block) {
        block(nil);
    }
}

+ (void) POST :(NSDictionary*)param url:(NSString*)url block:(void (^)(id responseObject))block {
    if (url) {
//        NSLog(@"POST%@",param);
         [[DDSessionManager shareHTTPSessionManager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
             
            NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
            if (ret == 1) {
                if (block) {
                    block(responseObject);
                }
            } else {
                if (block) {
                    block(nil);
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) {
                block(nil);
            }
        }];
    } else if (block) {
        block(nil);
    }
}




@end
