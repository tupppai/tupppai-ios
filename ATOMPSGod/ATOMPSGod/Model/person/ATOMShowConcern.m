//
//  ATOMShowConcern.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowConcern.h"
#import "DDSessionManager.h"
#import "DDFollow.h"

@implementation ATOMShowConcern

+ (NSURLSessionDataTask *)GetFollow:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSMutableArray *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"profile/follows" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        int ret = [(NSString*)[ responseObject objectForKey:@"ret"] intValue];
        if (ret == 1) {
            
            //返回数据
            NSMutableArray *retRecommend = [NSMutableArray array];
            NSMutableArray *retMine = [NSMutableArray array];
            NSDictionary* data = [responseObject objectForKey:@"data"];
            
            if (data) {
                NSArray *recommend = [data objectForKey:@"recommends"];
                NSArray *mine = [data objectForKey:@"fellows"];
                for (int i = 0; i < recommend.count; i++) {
                    DDFollow *concern = [MTLJSONAdapter modelOfClass:[DDFollow class] fromJSONDictionary:recommend[i] error:NULL];
                    [retRecommend addObject:concern];
                }
                for (int i = 0; i < mine.count; i++) {
                    DDFollow *concern = [MTLJSONAdapter modelOfClass:[DDFollow class] fromJSONDictionary:mine[i] error:NULL];
                    [retMine addObject:concern];
                }
                
                if (block) {
                    block(retRecommend, retMine, nil);
                }
            }
        } else {
            if (block) {
                block(nil,nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, nil, error);
        }
    }];
}

























@end
