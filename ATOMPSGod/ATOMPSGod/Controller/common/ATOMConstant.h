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


/** 游客没有登录态，被服务器截获的时候就会发出这个通知，通知游客用户输入手机号码转正 */
extern NSString * const PIENetworkCallForFurtherRegistrationNotification;


@end
