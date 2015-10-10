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
extern NSString *URL_PFGetMyPhotos;
extern NSString *URL_PFGetMyAsk;
extern NSString * URL_PFGetMyToHelp;
extern NSString * URL_PFGetMyDone;
extern NSString * URL_PFGetOtherUserInfo;
extern NSString * URL_PFGetFriendReply;
extern NSString * URL_PFGetFriendAsk;
extern NSString * URL_PFGetMyCollection;
extern NSString * URL_PFGetFans;
extern NSString * URL_PFGetFollow;
extern NSString * URL_PFUpdateProfile;


#pragma mark - Account
extern NSString * URL_ACUpdateToken;
extern NSString * URL_ACResetPassword;
extern NSString * URL_ACRequestAuthCode;
extern NSString * URL_ACLogin;
extern NSString * URL_ACRegister;
extern NSString * URL_AC3PaAuth;

#pragma mark - Unknown
extern NSString * URL_UKSaveFeedback;
extern NSString * URL_UKGetMyInfo;
extern NSString * URL_UKGetMsg;
extern NSString * URL_UKSaveAsk;
extern NSString * URL_UKSaveReply;


#pragma mark - Newest
extern NSString * URL_NewestGetAsk;
extern NSString * URL_NewestGetReply;

#pragma mark - Elite
extern NSString * URL_PFGetMyFollowPages;
extern NSString * URL_PFGetHotPages;
@end
