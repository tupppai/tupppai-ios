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
NSString * URL_PFGetMyReply = @"profile/replies";
NSString * URL_PFGetMyAsk = @"profile/asks";
NSString * URL_PFGetMyProceeding = @"profile/downloaded";
NSString * URL_PFGetOtherUserInfo = @"profile/view";
NSString * URL_PFGetMyCollection = @"Thread/subscribed";
NSString * URL_PFGetFans = @"profile/fans";
NSString * URL_PFGetFollow = @"profile/follows";

#pragma mark - Account
NSString * URL_ACUpdateToken = @"account/updateToken";
NSString * URL_ACResetPassword = @"account/resetPassword";
NSString * URL_ACRequestAuthCode = @"account/requestAuthCode";
NSString * URL_ACLogin = @"account/login";
NSString * URL_ACRegister = @"account/register";
NSString * URL_AC3PaAuth = @"auth/";

#pragma mark - Unknown
NSString * URL_UKSaveFeedback = @"feedback/save";
NSString * URL_UKGetMyInfo = @"view/info";
NSString * URL_UKGetMsg = @"message/list";
NSString * URL_UKSaveAsk = @"ask/save";
NSString * URL_UKSaveReply = @"reply/save";

//@"ask/save"
//NSString * URL_UKGetReplyMsg = @"view/info";
//NSString * URL_UKGetFollowMsg = @"view/info";
//NSString * URL_UKGetInviteMsg = @"view/info";

//NSString * URL_PF = @"";
//NSString * URL_PF = @"";
//NSString * URL_PF = @"";
//NSString * URL_PF = @"";
//NSString * URL_PF = @"";

@end
