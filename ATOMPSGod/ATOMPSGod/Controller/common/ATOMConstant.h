//
//  ATOMConstant.h
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMConstant : NSObject

extern CGFloat const kTableHeaderHeight;
extern CGFloat const kfcAvatarWidth;
extern CGFloat const kUserHeaderButtonWidth2;
extern CGFloat const kPublishTimeLabelWidth;
extern CGFloat const kUserBigHeaderButtonWidth;
extern CGFloat const kShareButtonWidth;
extern CGFloat const kUserNameLabelWidth;
extern CGFloat const kfcPSWidth;
extern CGFloat const kfcPSHeight;
//extern CGFloat const kfcButtonWidth;

extern CGFloat const kfcButtonHeight;
extern CGFloat const kfcButtonWidth;
extern CGFloat const kfcTopViewHeight;
extern CGFloat const kfcGapViewHeight;
extern CGFloat const kfcBottomViewHeight;
extern CGFloat const kfcAddtionViewHeight;
extern CGFloat const kfcReplierWidth;
extern CGFloat const kfcReplierGap;
extern NSInteger const kfcReplierDefaultQuantity;
extern CGFloat const kfcImageHeightDefault;
extern CGFloat const kfcImageHeightMax;
extern NSString * const kfcMaxNumberString;


extern NSInteger const kPagePadding;

extern NSInteger const kPadding5;
extern NSInteger const kPadding10;
extern NSInteger const kPadding13;
extern NSInteger const kPadding15;
extern NSInteger const kPadding20;
extern NSInteger const kPadding25;
extern NSInteger const kPadding28;
extern NSInteger const kPadding30;
extern NSInteger const kPadding35;

extern CGFloat const kFont10;
extern CGFloat const kFont12;
extern CGFloat const kFont13;
extern CGFloat const kFont14;
extern CGFloat const kFont15;

extern NSUInteger const kCommentTextViewMaxLength;
extern NSInteger const kLineWidth;

extern CGFloat const kUsernameFontSize;
extern CGFloat const kPublishTimeFontSizeBig;
extern CGFloat const kPublishTimeFontSizeSmall;
extern CGFloat const kTitleSizeForEmptyDataSet;

extern NSString * const kFontNameDefault;
extern NSString * const kUserNameFont;
extern NSString * const kPublishTimeFont;

#define PIEColorHex 0xFFEF00

/** 临时赋予“游客”状态的用户的UID */
extern NSInteger const kPIETouristUID;

/** "临时身份证"，记录在本地NSUserDefault里面的openID (from ShareSDK) 
 
    赋值： PIELaunchViewController_Black的 －adHocUserFromShareSDK
    撤销这个临时身份证：临时用户 -> 正式用户的那一瞬间
 */
extern NSString * const PIETouristOpenIdKey;

/**
 *  "临时身份证"的来源， 可能取值： @"qq", @"weibo", @"weixin"
 
    赋值： PIELaunchViewController_Black的 －adHocUserFromShareSDK
    撤销这个临时身份证：临时用户 -> 正式用户的那一瞬间
 */
extern NSString * const PIETouristLoginTypeStringKey;

/** 游客没有登录态，被服务器截获的时候就会发出这个通知，通知游客用户输入手机号码转正 */
extern NSString * const PIENetworkCallForFurtherRegistrationNotification;


/** 更新消息状态的通知 */
extern NSString * const PIEUpdateNotificationStatusNotification;


/**
    消息通知的类型
 */
typedef NS_ENUM(NSInteger, PIENotificationType) {
    PIENotificationTypeSystem  = 0,         // 系统通知
    PIENotificationTypeComment = 1,         // 我收到的评论
    PIENotificationTypeReply   = 2,         // 有人帮我P图
    PIENotificationTypeFollow  = 3,         // 有人关注我
    PIENotificationTypeLike    = 5,         // 我收到的赞
};

/** 接收到的所有远程通知数量（系统通知，收到的评论， etc.） */
extern NSString * const PIENotificationCountAllKey;

/** 接收到的系统消息通知数量 */
extern NSString * const PIENotificationCountSystemKey;

/** 接收到的“我收到的评论”的通知数量 */
extern NSString * const PIENotificationCountCommentKey;

/** 接收到的"有人帮我P图"的通知的数量 */
extern NSString * const PIENotificationCountReplyKey;

/** 接收到的“有人关注我”的通知的数量 */
extern NSString * const PIENotificationCountFollowKey;

/** 接收到的“我收到的赞”的通知的数量 */
extern NSString * const PIENotificationCountLikeKey;

/** 接收到除了（系统通知 ＋ 收到的赞 + 收到的评论）以外的其他通知的数量 */
extern NSString * const PIENotificationCountOthersKey;


/** 是否有接收到新消息(BOOL) 
 
    Appdelegate didReceiveRemoteNotification -> YES
    PIENotificationViewController viewWillDisappear -> NO
    唯一一次读取值：PIEMeViewController updateNotificationStatus
 
 */
extern NSString * const PIEHasNewNotificationFlagKey;

/** 重复点击tabbar上的“图派”， 刷新PIEChannelViewController*/
extern NSString * const PIERefreshNavigationChannelFromTabBarNotification;

/** 重复点击tabbar上的“进行中”， 刷新PIEProceedingViewController的两个子控制器 */
extern NSString * const PIEPrefreshNavigationProceedingFromTabBarNotification;


/**===================== 支付，和钱💰相关 */

/** thread/reward 余额不足 */
extern NSInteger kPIERewardFailedInteger;

/** thread/reward 顺利打赏 */
extern NSInteger kPIERewardSuccessInteger;

/** money/charge  最低充值金额 */
extern double kPIEChargeMinimumAmount;





@end
