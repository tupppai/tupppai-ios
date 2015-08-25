//
//  ATOMShowUser.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMShowUser.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMUser.h"
@implementation ATOMShowUser
+ (NSURLSessionDataTask *)ShowUserInfo:(void (^)(ATOMUser *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/info" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
        if (ret == 1) {
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:[ responseObject objectForKey:@"data"] error:NULL];
            //保存更新数据库的user,并更新currentUser
            [[ATOMCurrentUser currentUser]saveAndUpdateUser:user];
            if (block) {
                block(nil, nil);
            }
        } else {
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
