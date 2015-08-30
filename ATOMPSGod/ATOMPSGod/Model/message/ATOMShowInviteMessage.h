//
//  ATOMShowInviteMessage.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowInviteMessage : NSObject

+ (void)getInviteMsg:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block;

@end
