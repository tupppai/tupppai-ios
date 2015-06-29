//
//  ATOMShowReplyMessage.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowReplyMessage : NSObject

- (NSURLSessionDataTask *)ShowReplyMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *replyMessageArray, NSError *error))block;

@end
