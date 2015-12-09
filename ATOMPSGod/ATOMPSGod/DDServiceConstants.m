//
//  DDServiceConstants.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/28/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDServiceConstants.h"

@implementation DDServiceConstants
NSString * URL_PFSignProceeding     = @"profile/downloadFile";
NSString * URL_PFDeleteProceeding   = @"profile/deleteDownloadRecord";
NSString * URL_PFGetPushSetting     = @"profile/get_push_settings";
NSString * URL_PFsetPushSetting     = @"profile/set_push_settings";
NSString * URL_PFFollow             = @"profile/follow";
NSString * URL_PFUpdatePasswordURL  = @"profile/updatePassword";
NSString * URL_PFGetPhotos          = @"profile/threads";
NSString * URL_PFGetAsk             = @"profile/asks";
NSString * URL_PFGetToHelp          = @"profile/downloaded";
NSString * URL_PFGetDone            = @"profile/replies";
NSString * URL_PFGetCommentedPages  = @"profile/comments";
NSString * URL_PFGetLikedPages      = @"profile/uped";
NSString * URL_PFGetOtherUserInfo   = @"profile/view";
NSString * URL_PFGetReply           = @"profile/replies";
NSString * URL_PFGetFriendAsk       = @"profile/asks";
NSString * URL_PFGetCollection      = @"Thread/subscribed";
NSString * URL_PFGetFans            = @"profile/fans";
NSString * URL_PFGetFollow          = @"profile/follows";
NSString * URL_PFUpdateProfile      = @"profile/update";
NSString * URL_ACUpdateToken        = @"account/updateToken";
NSString * URL_ACResetPassword      = @"account/resetPassword";
NSString * URL_ACRequestAuthCode    = @"account/requestAuthCode";
NSString * URL_ACLogin              = @"account/login";
NSString * URL_ACRegister           = @"account/register";
NSString * URL_AC3PaAuth            = @"auth/";
NSString * URL_ACHasRegistered      = @"account/hasRegistered";
NSString * URL_UKSaveFeedback       = @"feedback/save";
NSString * URL_UKGetInfo            = @"view/info";
NSString * URL_UKGetMsg             = @"message/list";
NSString * URL_UKSaveAsk            = @"ask/multi";
NSString * URL_UKSaveReply          = @"reply/multi";
NSString * URL_UKEditAsk            = @"ask/edit";
NSString * URL_UKGetShare           = @"app/share";
NSString * URL_NewestGetAsk         = @"ask/index";
NSString * URL_NewestGetReply       = @"reply/index";
NSString * URL_PFGetFollowPages     = @"Thread/timeline";
NSString * URL_PFGetHotPages        = @"Thread/popular";
NSString * URL_NotiGetNotifications = @"message/index";

NSString * URL_UKGetUserSearch    = @"user/search";
NSString * URL_UKGetContentSearch = @"thread/search";
NSString * URL_UKGetBanner        = @"banner/get_banner_list";

NSString * URL_ChannelHomeThreads      = @"/thread/home";
NSString * URL_ChannelGetActivities    = @"/thread/get_activity_threads";
NSString * URL_ChannelGetDetailThreads = @"/thread/get_threads_by_channel";

NSString * URL_ChannelLatestAskForPS     = @"/thread/get_threads_by_channel";
NSString * URL_ChannelUsersPS = @"/thread/get_threads_by_channel";


@end
