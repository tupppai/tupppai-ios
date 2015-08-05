//
//  ATOMCommonModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/16/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMCommonModel : NSObject
+ (NSURLSessionDataTask *)get :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(NSError *))block;
+ (NSURLSessionDataTask *)post :(NSDictionary*)param withUrl:(NSString*)url withBlock:(void (^)(NSError *error ,int ret))block;
@end
