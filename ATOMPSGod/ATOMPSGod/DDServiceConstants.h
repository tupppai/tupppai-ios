//
//  DDServiceConstants.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/28/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDServiceConstants : NSObject
#pragma mark - Profile
extern NSString *URL_PFSignProceeding;
extern NSString *URL_PFDeleteProceeding;
extern NSString *URL_PFGetPushSetting;
extern NSString *URL_PFsetPushSetting;
extern NSString *URL_PFFollow;
extern NSString *URL_PFUpdatePasswordURL;


#pragma mark - Account
extern NSString * URL_ACUpdateToken;
extern NSString * URL_ACResetPassword;
extern NSString * URL_ACRequestAuthCode;

#pragma mark - Unknown
extern NSString * URL_UKSave;

@end
