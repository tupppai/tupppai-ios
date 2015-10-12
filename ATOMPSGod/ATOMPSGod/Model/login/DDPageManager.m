//
//  ATOMSubmitUserInfomation.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDPageManager.h"
#import "ATOMUser.h"

#import "ATOMImageTipLabel.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@implementation DDPageManager

+ (void)getPhotos:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService getPhotos:param withBlock:^(NSArray *data) {
            NSMutableArray *returnArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
                [returnArray addObject:homeImage];
            }
            if (block) { block(returnArray); }
    }];
}

+ (void)getAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService getAsk:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
            [returnArray addObject:homeImage];
        }
        if (block) { block(returnArray); }
    }];
}

+ (void)getReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService getReply:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
            [returnArray addObject:homeImage];
        }
        if (block) { block(returnArray); }
    }];
}

+ (void)getCollection:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService ddGetCollection:param withBlock:^(NSArray* data) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
            [resultArray addObject:homeImage];
        }
        if (block) {
            block(resultArray);
        }
    }];
}
@end
