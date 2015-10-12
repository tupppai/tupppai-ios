//
//  ATOMShowCollection.m
//  ATOMPSGod
//
//  Created by atom on 15/4/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMyCollectionManager.h"

#import "ATOMImageTipLabel.h"

@implementation DDMyCollectionManager

+ (void)getMyCollection:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService ddGetMyCollection:param withBlock:^(NSArray* data) {
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
