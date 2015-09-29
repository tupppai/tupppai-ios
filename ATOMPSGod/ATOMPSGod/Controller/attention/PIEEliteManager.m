//
//  PIEEliteManager.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteManager.h"

@implementation PIEEliteManager
+ (void)getMyFollow:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService getMyFollowPages:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEEliteEntity *entity = [MTLJSONAdapter modelOfClass:[PIEEliteEntity class] fromJSONDictionary:data[i] error:NULL];
            [returnArray addObject:entity];
        }
        if (block) {
            if (returnArray.count > 0) {
                block(returnArray);
            } else {
                block(nil);
            }
        }
    }];
}

+ (void)getHotPages:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService getHotPages:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEEliteEntity *entity = [MTLJSONAdapter modelOfClass:[PIEEliteEntity class] fromJSONDictionary:data[i] error:NULL];
            [returnArray addObject:entity];
        }
        if (block) {
            if (returnArray.count > 0) {
                block(returnArray);
            } else {
                block(nil);
            }
        }
    }];
}


@end
