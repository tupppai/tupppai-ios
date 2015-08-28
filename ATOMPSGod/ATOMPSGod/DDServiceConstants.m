//
//  DDServiceConstants.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/28/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDServiceConstants.h"

@implementation DDServiceConstants
#pragma mark - Profile
NSString * URL_PFSignProceeding = @"profile/downloadFile";
NSString * URL_PFDeleteProceeding = @"profile/deleteDownloadRecord";
NSString * URL_PFGetPushSetting= @"profile/get_push_settings";
NSString * URL_PFsetPushSetting = @"profile/set_push_settings";
NSString * URL_PFFollow = @"profile/follow";
NSString * URL_PFUpdatePasswordURL = @"profile/updatePassword";

#pragma mark - Account
NSString * URL_ACUpdateToken = @"account/updateToken";
NSString * URL_ACResetPassword = @"account/resetPassword";
NSString * URL_ACRequestAuthCode = @"account/requestAuthCode";

#pragma mark - Unknown
NSString * URL_UKSave = @"feedback/save";

//NSString * URL_PF = @"";
//NSString * URL_PF = @"";
//NSString * URL_PF = @"";
//NSString * URL_PF = @"";
//NSString * URL_PF = @"";

@end
