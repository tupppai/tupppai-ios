//
//  ATOMCurrentUser.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIELaunchViewController.h"
#import <ShareSDK/SSDKUser.h>
#import "PIEEntityUser.h"

@class PIEEntityUser;

typedef enum {
    ATOMSignUpWechat = 0,
    ATOMSignUpWeibo,
    ATOMSignUpMobile,
    ATOMSignUpQQ
}ATOMSignUpType;

@interface DDUserManager : NSObject


/**
 *  省份provinceName,provinceID,城市cityName,cityID
 */
@property (nonatomic, strong) NSMutableDictionary *region;
/**
 *  通过第三方平台可能获取到的数据
 */

@property (nonatomic, strong) SSDKUser *sdkUser;

@property (nonatomic, strong) NSDictionary *sourceData;
/**
 *  注册类型 weixin = 0 ,weibo = 1 ,mobile = 3
 */
@property (nonatomic, assign) ATOMSignUpType signUpType;
/**
 *  用户唯一ID
 */
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, copy) NSString *token;

/**
 *  man:1 woman:0
 */
@property (nonatomic, assign) BOOL sex;

/**
 *  关注数
 */
@property (nonatomic, assign) NSInteger attentionNumber;
/**
 *  粉丝数
 */
@property (nonatomic, assign) NSInteger fansNumber;
/**
 *  被点赞数
 */
@property (nonatomic, assign) NSInteger likeNumber;
/**
 *  求P数
 */
@property (nonatomic, assign) NSInteger uploadNumber;
/**
 *  回复作品数
 */
@property (nonatomic, assign) NSInteger replyNumber;
@property (nonatomic, assign) NSInteger praisedCount;

@property (nonatomic, assign) bool bindWechat;
@property (nonatomic, assign) bool bindWeibo;
@property (nonatomic, assign) bool bindQQ;


+ (PIEEntityUser *)currentUser;

- (NSMutableDictionary *)dictionaryFromModel;

- (void)setCurrentUser:(PIEEntityUser *)user;
-(void)tellMeEveryThingAboutYou;
+ (void)saveAndUpdateUser:(PIEEntityUser *)user;
+(void)fetchUserInDBToCurrentUser:(void (^)(BOOL))block;
-(void)wipe;

+ (void)updateDBUserFromCurrentUser;
+ (void)DDGetUserInfoAndUpdateMe;
+ (void )DDRegister:(NSDictionary *)param withBlock:(void (^)(BOOL success))block ;
+ (void )DDLogin:(NSDictionary*)param withBlock:(void (^)(BOOL succeed))block ;
+ (void)DD3PartyAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegistered,NSString* info))block;

@end
