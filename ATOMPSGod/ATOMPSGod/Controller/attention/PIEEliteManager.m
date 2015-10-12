//
//  PIEEliteManager.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteManager.h"

#import "PIEImageEntity.h"
@implementation PIEEliteManager
+ (void)getMyFollow:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService getFollowPages:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
            NSMutableArray* thumbArray = [NSMutableArray new];
            for (int i = 0; i<entity.askImageModelArray.count; i++) {
                PIEImageEntity *entity2 = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:                    entity.askImageModelArray[i] error:NULL];
                [thumbArray addObject:entity2];
            }
            entity.askImageModelArray = thumbArray;
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
            PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
            if (entity) {
                NSMutableArray* thumbArray = [NSMutableArray new];
                for (int i = 0; i<entity.askImageModelArray.count; i++) {
                    PIEImageEntity *entity2 = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:                    entity.askImageModelArray[i] error:NULL];
                    [thumbArray addObject:entity2];
                }
                entity.askImageModelArray = thumbArray;
                [returnArray addObject:entity];
            }
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
