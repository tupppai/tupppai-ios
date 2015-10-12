//
//  ATOMShowOtherUser.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDOtherUserManager.h"

#import "ATOMImageTipLabel.h"
#import "ATOMUser.h"
#import "PIEImageEntity.h"
@implementation DDOtherUserManager

+ (void)getOtherUserInfo:(NSDictionary *)param withBlock:(void (^)(ATOMUser *user))block {
    [DDService ddGetOtherUserInfo:param withBlock:^(NSDictionary *data, NSArray *askArray, NSArray *replyArray) {
        {

            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:NULL];
            if (block) {
                block(user);
            }
        }
    }];
}
+ (void)getFriendReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService ddGetReply:param withBlock:^(NSArray *returnArray) {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < returnArray.count; i++) {
                PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:returnArray[i] error:NULL];
                NSMutableArray* thumbArray = [NSMutableArray new];
                for (int i = 0; i<entity.askImageModelArray.count; i++) {
                    PIEImageEntity *entity2 = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:                    entity.askImageModelArray[i] error:NULL];
                    [thumbArray addObject:entity2];
                }
                
                if (thumbArray.count > 0) {
                    entity.askImageModelArray = thumbArray;
                } else {
                    entity.askImageModelArray = nil;
                }
                [array addObject:entity];
            }
            if (block) {
                if (array.count > 0) {
                    block(array);
                } else {
                    block (nil);
                }
            }
    }];
}
@end
