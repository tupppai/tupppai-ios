//
//  ATOMShowReply.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/1/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowReply : NSObject
+ (NSURLSessionDataTask *)ShowMyReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block;
@end
