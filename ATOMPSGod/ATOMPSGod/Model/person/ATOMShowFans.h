//
//  ATOMShowFans.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowFans : NSObject

- (AFHTTPRequestOperation *)ShowFans:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *resultArray, NSError *error))block;

@end
