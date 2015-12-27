//
//  ATOMShowOtherUser.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDOtherUserManager.h"

//
#import "PIEUserModel.h"
#import "PIEModelImage.h"
@implementation DDOtherUserManager

+ (void)getUserInfo:(NSDictionary *)param withBlock:(void (^)(PIEUserModel *user))block {
    [DDService ddGetOtherUserInfo:param withBlock:^(NSDictionary *data, NSArray *askArray, NSArray *replyArray) {
        {

            PIEUserModel* user = [MTLJSONAdapter modelOfClass:[PIEUserModel class] fromJSONDictionary:data error:NULL];
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
                PIEPageModel *entity = [MTLJSONAdapter modelOfClass:[PIEPageModel class] fromJSONDictionary:returnArray[i] error:NULL];
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
