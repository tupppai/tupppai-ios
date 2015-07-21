//
//  ATOMRecordModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/21/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMRecordModel.h"
#import "ATOMHTTPRequestOperationManager.h"

@implementation ATOMRecordModel
+ (NSURLSessionDataTask *)record :(NSDictionary*)param withBlock:(void (^)(NSError *,NSString*))block {
    NSLog(@"ATOMCommonModel post param %@",param);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/record" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ATOMRecordModel get responseObject%@",responseObject);
        NSLog(@"ATOMRecordModel get info%@",responseObject[@"info"]);
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret == 1) {
            NSString* url = [[responseObject objectForKey:@"data"]objectForKey:@"url"];
            if (block) {
                block(nil,url);
            }
        } else {
            NSError* error = [NSError new];
            if (block) {
                block(error,nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error,nil);
        }
    }];
}

@end
