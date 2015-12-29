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

+ (void)getFollow:(NSDictionary *)param withBlock:(void (^)(NSArray *recommendArray, NSArray *myFollowArray))block {
    [DDService ddGetFollow:param withBlock:^(NSArray *recommendArray, NSArray *myFollowArray) {

        NSArray* recommends = [MTLJSONAdapter modelsOfClass:[PIEUserModel class] fromJSONArray:recommendArray error:NULL];
        NSArray* followers = [MTLJSONAdapter modelsOfClass:[PIEUserModel class] fromJSONArray:myFollowArray error:NULL];

        if (block) {
            block(recommends, followers);
        }
    }];
}



@end
