//
//  ATOMShowMyAsk.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/9/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PIEProceedingManager.h"

#import "ATOMImageTipLabel.h"

@implementation PIEProceedingManager
+ (void)getMyAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *dataArray))block {
    [DDService getAsk:param withBlock:^(NSArray *data) {
            NSMutableArray *resultArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
                [resultArray addObject:homeImage];
            }
            if (block) {  block(resultArray);}
    }];
}

+ (void)getMyToHelp:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService getToHelp:param withBlock:^(NSArray *data) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
            [resultArray addObject:homeImage];
        }
        if (block) { block(resultArray); }
    }];
}

+ (void)getMyDone:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *dataArray))block {
    [DDService getDone:param withBlock:^(NSArray *data) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
            [resultArray addObject:homeImage];
        }
        if (block) { block(resultArray); }
    }];
}
@end
