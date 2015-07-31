//
//  ATOMCollectModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/2/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMCollectModel.h"
#import "ATOMHTTPRequestOperationManager.h"

@implementation ATOMCollectModel
+ (NSURLSessionDataTask *)toggleCollect:(NSDictionary *)param withPageType:(ATOMPageType)type withID:(NSInteger)ID withBlock:(void (^)(NSError *))block {
        NSString* url;
        if (type == ATOMPageTypeAsk) {
            url = [NSString stringWithFormat:@"ask/focusask/%ld",(long)ID];
        }   if (type == ATOMPageTypeReply) {
            url = [NSString stringWithFormat:@"reply/collectreply/%ld",(long)ID];
        }
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"toggleCollect url %@ param%@",url,param);
            NSLog(@"toggleCollect responseObject%@",responseObject);
            NSLog(@"toggleCollect info%@",[ responseObject objectForKey:@"info"]);
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
