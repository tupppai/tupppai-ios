//
//  ATOMShowConcern.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDFollowManager.h"
#import "PIEEntityFollow.h"

@implementation DDFollowManager

+ (void)getFollow:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *recommendArray, NSMutableArray *myFollowArray))block {
    [DDService ddGetFollow:param withBlock:^(NSArray *recommendArray, NSArray *myFollowArray) {
        NSMutableArray *retRecommend = [NSMutableArray array];
        NSMutableArray *retMine = [NSMutableArray array];
        for (int i = 0; i < recommendArray.count; i++) {
            PIEEntityFollow *concern = [MTLJSONAdapter modelOfClass:[PIEEntityFollow class] fromJSONDictionary:recommendArray[i] error:NULL];
            [retRecommend addObject:concern];
        }
        for (int i = 0; i < myFollowArray.count; i++) {
            PIEEntityFollow *concern = [MTLJSONAdapter modelOfClass:[PIEEntityFollow class] fromJSONDictionary:myFollowArray[i] error:NULL];
            [retMine addObject:concern];
        }
        if (block) {
            block(retRecommend, retMine);
        }
    }];
}



@end
