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
NSString * URL_PFGetPhotos = @"profile/threads";
NSString * URL_PFGetAsk = @"profile/asks";
NSString * URL_PFGetToHelp = @"profile/downloaded";
NSString * URL_PFGetDone = @"profile/replies";
NSString * URL_PFGetCommentedPages = @"profile/comments";
NSString * URL_PFGetLikedPages = @"profile/uped";


NSString * URL_PFGetOtherUserInfo = @"profile/view";
NSString * URL_PFGetReply = @"profile/replies";
NSString * URL_PFGetFriendAsk = @"profile/asksWithReplies";
NSString * URL_PFGetCollection = @"Thread/subscribed";
NSString * URL_PFGetFans = @"profile/fans";
NSString * URL_PFGetFollow = @"profile/follows";

NSString * URL_PFUpdateProfile = @"profile/update";

#pragma mark - Account
NSString * URL_ACUpdateToken = @"account/updateToken";
NSString * URL_ACResetPassword = @"account/resetPassword";
NSString * URL_ACRequestAuthCode = @"account/requestAuthCode";
NSString * URL_ACLogin = @"account/login";
NSString * URL_ACRegister = @"account/register";
NSString * URL_AC3PaAuth = @"auth/";
NSString * URL_ACHasRegistered = @"account/hasRegistered";

#pragma mark - Unknown
NSString * URL_UKSaveFeedback = @"feedback/save";
NSString * URL_UKGetInfo = @"view/info";
NSString * URL_UKGetMsg = @"message/list";
NSString * URL_UKSaveAsk = @"ask/multi";
NSString * URL_UKSaveReply = @"reply/save";
NSString * URL_UKEditAsk = @"ask/edit";

#pragma mark - Newest
NSString * URL_NewestGetAsk = @"ask/index";
NSString * URL_NewestGetReply = @"reply/index";

#pragma mark - Elite
NSString * URL_PFGetFollowPages = @"Thread/timeline";
NSString * URL_PFGetHotPages = @"Thread/popular";

#pragma mark - Notification
NSString * URL_NotiGetNotifications = @"message/index";
@end
