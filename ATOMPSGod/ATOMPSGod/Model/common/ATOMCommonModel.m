//
//  ATOMCommonModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/16/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMCommonModel.h"
#import "ATOMHTTPRequestOperationManager.h"

@implementation ATOMCommonModel
+ (NSURLSessionDataTask *)post :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(NSError *))block {
    NSLog(@"ATOMCommonModel post param %@",param);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ATOMCommonModel post responseObject%@",responseObject);
        NSLog(@"ATOMCommonModel post info%@",responseObject[@"info"]);
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
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

+ (NSURLSessionDataTask *)get :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(NSError *))block {
    NSLog(@"ATOMCommonModel post param %@",param);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ATOMCommonModel post responseObject%@",responseObject);
        NSLog(@"ATOMCommonModel post info%@",responseObject[@"info"]);
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
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
