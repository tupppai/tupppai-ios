//
//  ATOMShowOtherUser.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDOtherUserManager.h"
#import "PIEPageEntity.h"
#import "ATOMImageTipLabel.h"
#import "ATOMUser.h"
@implementation DDOtherUserManager

+ (void)getOtherUserInfo:(NSDictionary *)param withBlock:(void (^)(ATOMUser *user))block {
    [DDService ddGetOtherUserInfo:param withBlock:^(NSDictionary *data, NSArray *askArray, NSArray *replyArray) {
        {
//            NSMutableArray *askReturnArray = [NSMutableArray array];
//            NSMutableArray *replyReturnArray = [NSMutableArray array];
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:NULL];
//            for (int i = 0; i < askArray.count; i++) {
//                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:askArray[i] error:NULL];
//                [askReturnArray addObject:homeImage];
//            }
//            
//            for (int i = 0; i < replyArray.count; i++) {
//                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:replyArray[i] error:NULL];
//                [replyReturnArray addObject:homeImage];
//            }
            
            if (block) {
                block(user);
            }
        }
    }];
}
+ (void)getFriendReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService ddGetFriendReply:param withBlock:^(NSArray *returnArray) {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < returnArray.count; i++) {
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:returnArray[i] error:NULL];
                [array addObject:homeImage];
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
+ (void)getFriendAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService ddGetFriendAsk:param withBlock:^(NSArray *returnArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < returnArray.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:returnArray[i] error:NULL];
            [array addObject:homeImage];
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
