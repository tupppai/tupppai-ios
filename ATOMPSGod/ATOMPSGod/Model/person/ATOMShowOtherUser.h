//
//  ATOMShowOtherUser.h
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowOtherUser : NSObject

+ (NSURLSessionDataTask *)ShowOtherUser:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *askReturnArray,NSMutableArray *replyReturnArray,ATOMUser *user, NSError *))block ;
@end
