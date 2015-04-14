//
//  ATOMShowConcernMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowConcernMessage.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMConcernMessage.h"

@implementation ATOMShowConcernMessage

- (AFHTTPRequestOperation *)ShowConcernMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"message/follow" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *concernMessageArray = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        for (int i = 0; i < dataArray.count; i++) {
            ATOMConcernMessage *concernMessage = [MTLJSONAdapter modelOfClass:[ATOMConcernMessage class] fromJSONDictionary:dataArray[i] error:NULL];
            [concernMessageArray addObject:concernMessage];
        }
        if (block) {
            block(concernMessageArray, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
