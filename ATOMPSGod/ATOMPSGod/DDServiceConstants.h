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
extern NSString *URL_PFGetPhotos;
extern NSString *URL_PFGetAsk;
extern NSString * URL_PFGetToHelp;
extern NSString * URL_PFGetDone;
extern NSString * URL_PFGetUserInfo;
extern NSString * URL_PFGetReply;
extern NSString * URL_PFGetFriendAsk;
extern NSString * URL_PFGetCollection;
extern NSString * URL_PFGetFans;
extern NSString * URL_PFGetFollow;
extern NSString * URL_PFUpdateProfile;
extern NSString * URL_PFGetCommentedPages;
extern NSString * URL_PFGetLikedPages;


#pragma mark - Account
extern NSString * URL_ACUpdateToken;
extern NSString * URL_ACResetPassword;
extern NSString * URL_ACRequestAuthCode;
extern NSString * URL_ACLogin;
extern NSString * URL_ACRegister;
extern NSString * URL_AC3PaAuth;
extern NSString * URL_ACHasRegistered;

#pragma mark - Unknown
extern NSString * URL_UKSaveFeedback;
extern NSString * URL_UKGetMsg;
extern NSString * URL_UKSaveAsk;
extern NSString * URL_UKSaveReply;
extern NSString * URL_UKEditAsk;
extern NSString * URL_UKGetShare;
extern NSString * URL_UKGetUserSearch;
extern NSString * URL_UKGetContentSearch;
extern NSString * URL_UKGetBanner;

#pragma mark - Newest
extern NSString * URL_NewestGetAsk;
extern NSString * URL_NewestGetReply;

#pragma mark - Elite
extern NSString * URL_PFGetFollowPages;
extern NSString * URL_PFGetHotPages;

#pragma mark - Channels

/**
 *  首页（活动+频道）
    接受参数
    get:
    page:页面，默认为1
    size:页面数目，默认为10
    last_updated:最后下拉更新的时间戳（10位）

 */
extern NSString * URL_ChannelHomeThreads;

/**
 *  获取活动相关作品
    接受参数
    get:
    activity_id:活动id
    page:页面，默认为1
    size:页面数目，默认为10
    last_updated:最后下拉更新的时间戳（10位）
 */
extern NSString * URL_ChannelGetActivities;

/**
 *  
    接受参数
    get:
    channel_id: 频道id
    page:页面，默认为1
    size:页面数目，默认为10
    last_updated:最后下拉更新的时间戳（10位）
 */
extern NSString * URL_ChannelGetDetailThreads;


/**
 *  获取某频道的最新求P
 */
extern NSString * URL_ChannelLatestAskForPS;

/**
 *  获取在某频道中， 用户（复数）的PS作品
 */
extern NSString * URL_ChannelUsersPS;

/**
 *  获取某频道的活动
 */
extern NSString * URL_ChannelActivity;

#pragma mark - Notification
extern NSString * URL_NotiGetNotifications;


@end
