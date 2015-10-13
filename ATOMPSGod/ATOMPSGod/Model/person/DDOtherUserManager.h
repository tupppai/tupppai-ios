//
//  ATOMShowOtherUser.h
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDOtherUserManager : NSObject

+ (void)getOtherUserInfo:(NSDictionary *)param withBlock:(void (^)(ATOMUser *user))block;
+ (void)getFriendReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block;
//+ (void)getAskWithReplies:(NSDictionary *)param withBlock:(void (^)(NSArray *returnArray))block;
@end
