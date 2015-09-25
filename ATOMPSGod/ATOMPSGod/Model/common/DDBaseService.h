//
//  ATOMBaseRequest.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSessionManager.h"
#import "DDServiceConstants.h"

@interface DDBaseService : NSObject
+ (void)GET :(NSDictionary*)param url:(NSString*)url block:(void (^)(id responseObject))block;
+ (void)POST :(NSDictionary*)param url:(NSString*)url block:(void (^)(id responseObject))block;
@end
