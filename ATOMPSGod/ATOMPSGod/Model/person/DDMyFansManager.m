//
//  ATOMShowFans.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMyFansManager.h"
#import "PIEEntityFan.h"

@implementation DDMyFansManager

+ (void)getMyFans:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService ddGetFans:param withBlock:^(NSArray *data) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEEntityFan *fans = [MTLJSONAdapter modelOfClass:[PIEEntityFan class] fromJSONDictionary:data[i] error:NULL];
            [resultArray addObject:fans];
        }
        if (block) {
            block(resultArray);
        }
    }];
}

@end
