//
//  ATOMShowSettings.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/28/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATOMHTTPRequestOperationManager.h"

@interface ATOMShowSettings : NSObject
+ (NSURLSessionDataTask *)getPushSetting:(NSDictionary *)param withBlock:(void (^)(NSDictionary *, NSError *))block;
+ (NSURLSessionDataTask *)setPushSetting:(NSDictionary *)param withBlock:(void (^)(NSDictionary *, NSError *))block;
@end
