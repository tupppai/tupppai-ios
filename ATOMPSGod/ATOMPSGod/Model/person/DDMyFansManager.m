//
//  ATOMShowFans.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMyFansManager.h"
#import "ATOMFans.h"

@implementation DDMyFansManager

+ (void)getMyFans:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService ddGetMyFans:param withBlock:^(NSArray *data) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            ATOMFans *fans = [MTLJSONAdapter modelOfClass:[ATOMFans class] fromJSONDictionary:data[i] error:NULL];
            [resultArray addObject:fans];
        }
        if (block) {
            block(resultArray);
        }
    }];
}

@end
