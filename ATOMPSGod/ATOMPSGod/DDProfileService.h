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
+ (void)getMyReply:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block;

#pragma mark - Account
+ (void) updateToken :(NSDictionary*)param withBlock:(void (^)(BOOL success))block;
+ (void) resetPassword :(NSDictionary*)param withBlock:(void (^)(BOOL success))block;
+ (void)getAuthCode:(NSDictionary*)param withBlock:(void (^)(NSString *authcode))block;
+ (void) ddLogin :(NSDictionary*)param withBlock:(void (^)(NSDictionary* data , NSInteger status))block;
+ (void) ddRegister :(NSDictionary*)param withBlock:(void (^)(NSDictionary* data))block;
+ (void) dd3PartyAuth :(NSDictionary*)param with3PaType:(NSString *)type withBlock:(void (^)(BOOL isRegistered,NSDictionary*userObject))block ;
#pragma mark - Unknown
+ (void) postFeedBack :(NSDictionary*)param withBlock:(void (^)(BOOL success))block;
+ (void)ddGetMyInfo:(NSDictionary*)param withBlock:(void (^)(NSDictionary* data))block;

/*
 **评论通知，邀请通知，系统通知等。
 */
+ (void)ddGetMsg:(NSDictionary*)param withBlock:(void (^)(id data))block;
@end
