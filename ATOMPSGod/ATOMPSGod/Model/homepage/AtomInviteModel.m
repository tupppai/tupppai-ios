//
//  ATOMInviteModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/24/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMInviteModel.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMRecommendUser.h"
@implementation ATOMInviteModel
- (NSURLSessionDataTask *)showMasters:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *recommendMasters,NSMutableArray *recommendFriends, NSError *))block {
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/get_recommend_users" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"showMasters responseObject%@",responseObject);
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        NSMutableArray *recommendMasters;
        NSMutableArray *recommendFriends;

        if (ret != 1) {
            [Util TextHud:@"出现未知错误"];
            block(nil, nil,nil);
        }
        else {
            if (responseObject[@"data"][@"recommends"]) {
                NSLog(@"showMasters responseObject recommend%@",responseObject[@"data"][@"recommends"]);

                recommendMasters = [NSMutableArray array];
                NSArray *recommendData = responseObject[@"data"][@"recommends"];
                for (NSDictionary* data in recommendData) {
                    NSLog(@"recommendMasters for");
                    ATOMRecommendUser *ru = [MTLJSONAdapter modelOfClass:[ATOMRecommendUser class] fromJSONDictionary:data error:NULL];
                    [recommendMasters addObject:ru];
                }
                NSLog(@"recommendMasters  %@",recommendMasters);

            }
            if (responseObject[@"data"][@"fellows"]) {
                recommendFriends = [NSMutableArray array];
                NSArray *recommendData2 = responseObject[@"data"][@"fellows"];
                for (NSDictionary* data in recommendData2) {
                    ATOMRecommendUser *ru = [MTLJSONAdapter modelOfClass:[ATOMRecommendUser class] fromJSONDictionary:data error:NULL];
                    [recommendFriends addObject:ru];
                }
            }
            if (block) {
                block(recommendMasters,recommendFriends,nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util TextHud:@"出现未知错误"];
        if (block) {
            block(nil,nil, error);
        }
    }];
    
}
@end
