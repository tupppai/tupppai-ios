//
//  ATOMCurrentUser.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATOMLaunchViewController.h"
@class ATOMUser;

@interface ATOMCurrentUser : NSObject


/**
 *  省份provinceName,provinceID,城市cityName,cityID
 */
@property (nonatomic, strong) NSMutableDictionary *region;
/**
 *  通过第三方平台可能获取到的数据
 */
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
@property (nonatomic, assign) NSInteger locationID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
/**
 *  man:1 woman:0
 */
@property (nonatomic, assign) NSInteger sex;
/**
 *  背景图url
 */
@property (nonatomic, copy) NSString *backgroundImage;
/**
 *  被关注注数
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
/**
 *  进行中数
 */
@property (nonatomic, assign) NSInteger proceedingNumber;
/**
 *  关注求P数
 */
@property (nonatomic, assign) NSInteger attentionUploadNumber;
/**
 *  关注作品数
 */
@property (nonatomic, assign) NSInteger attentionWorkNumber;
@property (nonatomic, assign) NSInteger avatarID;
@property (nonatomic, assign) bool bindWechat;
@property (nonatomic, assign) bool bindWeibo;


+ (ATOMCurrentUser *)currentUser;

- (NSMutableDictionary *)dictionaryFromModel;

- (void)setCurrentUser:(ATOMUser *)user;
-(void)tellMeEveryThingAboutYou;
- (void)saveAndUpdateUser:(ATOMUser *)user;
-(void)fetchCurrentUserInDB:(void (^)(BOOL))block;
-(void)wipe;
@end
