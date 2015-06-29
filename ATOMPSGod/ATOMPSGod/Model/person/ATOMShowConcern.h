//
//  ATOMShowConcern.h
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowConcern : NSObject

- (NSURLSessionDataTask *)ShowMyConcern:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *recommendConcernArray, NSMutableArray *myConcernArray, NSError *error))block;
- (NSURLSessionDataTask *)ShowOtherConcern:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *resultArray, NSError *error))block;

@end
