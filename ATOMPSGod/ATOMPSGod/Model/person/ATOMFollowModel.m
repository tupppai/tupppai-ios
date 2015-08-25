//
//  ATOMFollowModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/9/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMFollowModel.h"
#import "ATOMHTTPRequestOperationManager.h"

@implementation ATOMFollowModel
+ (NSURLSessionDataTask *)follow :(NSDictionary*)param withType:(BOOL)toFollow withBlock:(void (^)(NSError *))block {
    NSString* url = toFollow == YES ? @"user/follow":@"user/unfollow";
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
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
