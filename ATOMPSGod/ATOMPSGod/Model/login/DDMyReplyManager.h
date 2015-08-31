//
//  ATOMSubmitUserInfomation.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMyReplyManager : NSObject
+ (void)getMyReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block;
@end
