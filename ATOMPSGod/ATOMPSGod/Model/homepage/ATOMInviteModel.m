//
//  ATOMInviteModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/24/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMInviteModel.h"
#import "DDSessionManager.h"
#import "ATOMRecommendUser.h"
@implementation ATOMInviteModel
- (NSURLSessionDataTask *)showRecomendUsers:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *recommendMasters,NSMutableArray *recommendFriends, NSError *))block {
    //get_masters
    return [[DDSessionManager shareHTTPSessionManager] GET:@"profile/follows" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        NSMutableArray *recommendMasters;
        NSMutableArray *recommendFriends;
        if (ret != 1) {
            block(nil, nil,nil);
        }
        else {
            if ([ responseObject objectForKey:@"data"][@"recommends"]) {
                recommendMasters = [NSMutableArray array];
                NSArray *recommendData = [ responseObject objectForKey:@"data"][@"recommends"];
                for (NSDictionary* data in recommendData) {
                    ATOMRecommendUser *ru = [MTLJSONAdapter modelOfClass:[ATOMRecommendUser class] fromJSONDictionary:data error:NULL];
                    [recommendMasters addObject:ru];
                }
            }
            if ([[ responseObject objectForKey:@"data"]objectForKey:@"fellows"]) {
                recommendFriends = [NSMutableArray array];
                NSArray *recommendData2 = [[responseObject objectForKey:@"data"]objectForKey:@"fellows"];
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
        if (block) {
            block(nil,nil, error);
        }
    }];
    
}

+ (NSURLSessionDataTask *)invite:(NSDictionary *)param {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"invitation/invite" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret != 1) {
            
        } else {
            //ok
        }
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"invite error %@",error);
    }];
}
@end
