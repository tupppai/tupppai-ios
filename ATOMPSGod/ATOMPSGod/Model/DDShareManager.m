//
//  ATOMShareModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/26/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDShareManager.h"
#import "DDSessionManager.h"
@implementation DDShareManager
- (NSURLSessionDataTask *)getShareInfo:(NSDictionary *)param withBlock:(void (^)(ATOMShare *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"app/share" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            ATOMShare *share = [MTLJSONAdapter modelOfClass:[ATOMShare class] fromJSONDictionary:[ responseObject objectForKey:@"data"] error:NULL];
            if (block) {
                block(share, nil);
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
