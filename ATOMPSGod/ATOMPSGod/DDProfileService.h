//
//  DDProfileService.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/28/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBaseService.h"

@interface DDProfileService : DDBaseService

#pragma mark - Profile

/*
 **标记用户下载了此素材,返回图片的url.
 */
+ (void)signProceeding :(NSDictionary*)param withBlock:(void (^)(NSString*imageUrl))block;
+ (void)getPushSetting:(void (^)(NSDictionary *data))block;
+ (void)setPushSetting:(NSDictionary *)param withBlock:(void (^) (BOOL success))block;
+ (void) follow :(NSDictionary*)param withBlock:(void (^)(BOOL success))block;
+ (void) updatePassword :(NSDictionary*)param withBlock:(void (^)(BOOL success,NSInteger ret))block;
+ (void) deleteProceeding :(NSDictionary*)param withBlock:(void (^)(BOOL success))block;

#pragma mark - Account

+ (void) updateToken :(NSDictionary*)param withBlock:(void (^)(BOOL success))block;

@end
