//
//  ATOMShowMyAsk.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/9/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PIEProceedingManager.h"

//

@implementation PIEProceedingManager
+ (void)getMyAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *dataArray))block {
    [DDService getAsk:param withBlock:^(NSArray *data) {
            NSMutableArray *resultArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                PIEPageModel *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageModel class] fromJSONDictionary:data[i] error:NULL];
                [resultArray addObject:homeImage];
            }
            if (block) {  block(resultArray);}
    }];
}

+ (void)getMyToHelp:(NSDictionary *)param withBlock:(void (^)(NSArray *))block {
    [DDService getToHelp:param withBlock:^(NSArray *data) {
        NSArray *resultArray = [MTLJSONAdapter modelsOfClass:[PIEPageModel class] fromJSONArray:data error:nil];
        if (block) { block(resultArray); }
    }];
}

+ (void)getMyDone:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *dataArray))block {
    [DDService getDone:param withBlock:^(NSArray *data) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageModel *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageModel class] fromJSONDictionary:data[i] error:NULL];
            [resultArray addObject:homeImage];
        }
        if (block) { block(resultArray); }
    }];
}
@end
