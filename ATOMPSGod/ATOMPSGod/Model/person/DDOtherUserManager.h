//
//  ATOMShowOtherUser.h
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDOtherUserManager : NSObject

+ (void)getOtherUserInfo:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *askReturnArray,NSMutableArray *replyReturnArray,ATOMUser *user))block;
@end
