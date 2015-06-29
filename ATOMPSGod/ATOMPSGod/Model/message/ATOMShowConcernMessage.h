//
//  ATOMShowConcernMessage.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowConcernMessage : NSObject

- (NSURLSessionDataTask *)ShowConcernMessage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *concernMessageArray, NSError *error))block;

@end
