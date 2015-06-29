//
//  ATOMShowAttention.h
//  ATOMPSGod
//
//  Created by atom on 15/5/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowAttention : NSObject

- (NSURLSessionDataTask *)ShowAttention:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *resultArray, NSError *error))block;

@end
