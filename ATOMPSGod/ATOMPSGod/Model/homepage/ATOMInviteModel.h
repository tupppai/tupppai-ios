//
//  ATOMInviteModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/24/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMInviteModel : NSObject
- (NSURLSessionDataTask *)showRecomendUsers:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *recommendMasters,NSMutableArray *recommendFriends, NSError *))block;
+ (NSURLSessionDataTask *)invite:(NSDictionary *)param;
@end
