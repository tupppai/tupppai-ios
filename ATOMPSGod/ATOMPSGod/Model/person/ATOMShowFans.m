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

- (NSURLSessionDataTask *)ShowFans:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/myfans" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ShowFans responseObject %@",responseObject);
        int ret = [(NSString*)responseObject[@"ret"] intValue];
        if (ret == 1) {
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *dataArray = responseObject[@"data"];
            for (int i = 0; i < dataArray.count; i++) {
                ATOMFans *fans = [MTLJSONAdapter modelOfClass:[ATOMFans class] fromJSONDictionary:dataArray[i] error:NULL];
                [resultArray addObject:fans];
            }
            if (block) {
                block(resultArray, nil);
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
