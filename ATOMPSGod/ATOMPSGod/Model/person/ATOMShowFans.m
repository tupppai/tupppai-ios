//
//  ATOMShowFans.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowFans.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMFans.h"

@implementation ATOMShowFans

- (AFHTTPRequestOperation *)ShowFans:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"user/myfans" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultArray = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        for (int i = 0; i < dataArray.count; i++) {
            ATOMFans *fans = [MTLJSONAdapter modelOfClass:[ATOMFans class] fromJSONDictionary:dataArray[i] error:NULL];
            [resultArray addObject:fans];
        }
        if (block) {
            block(resultArray, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
