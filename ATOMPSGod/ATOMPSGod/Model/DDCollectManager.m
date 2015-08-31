//
//  ATOMCollectModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/2/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDCollectManager.h"
#import "DDSessionManager.h"

@implementation DDCollectManager
+ (NSURLSessionDataTask *)toggleCollect:(NSDictionary *)param withPageType:(ATOMPageType)type withID:(NSInteger)ID withBlock:(void (^)(NSError *))block {
        NSString* url;
        if (type == ATOMPageTypeAsk) {
            url = [NSString stringWithFormat:@"ask/focusask/%zd",ID];
        }   if (type == ATOMPageTypeReply) {
            url = [NSString stringWithFormat:@"reply/collectreply/%zd",ID];
        }
    return [[DDSessionManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
            if (ret == 1) {
                if (block) {
                    block(nil);
                }
            } else {
                if (block) {
                    block(nil);
                }
            }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}
@end
