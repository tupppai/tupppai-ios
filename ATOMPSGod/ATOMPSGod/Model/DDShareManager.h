//
//  ATOMShareModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/26/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATOMShare.h"
#import "PIEPageVM.h"
//#import <ShareSDK/ShareSDK.h>
#import "OpenshareAuthUser.h"

//qq空间只能webpage ,其它均能传image
typedef NS_ENUM(NSInteger, ATOMShareType) {
    ATOMShareTypeWechatMoments = 0,
    ATOMShareTypeWechatFriends,
    ATOMShareTypeSinaWeibo,
    ATOMShareTypeQQZone,
    ATOMShareTypeQQFriends,
    ATOMShareTypeCopyLinks,
};

typedef NS_ENUM(NSUInteger, ATOMAuthType) {
    ATOMAuthTypeWeibo,
    ATOMAuthTypeWeixin,
    ATOMAuthTypeQQ
};

@interface DDShareManager : NSObject
+ (void)getUserInfo:(SSDKPlatformType)type withBlock:(void (^)(NSString* openId ))block;

//+ (void)authorize:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block;//to delete
//+ (void)authorize2:(SSDKPlatformType)type withBlock:(void (^)(SSDKUser* user ))block;

// 新需求：openshare -> ShareSDK, 第三方登录
+ (void)authorize_openshare:(ATOMAuthType)authType withBlock:(void (^)(OpenshareAuthUser *user))block;




+ (void)getRemoteShareInfo:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType withBlock:(void (^)(ATOMShare* share))block;
+(void)copy:(PIEPageVM*)vm;

//
//+ (void)postSocialShare3:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType block:(void (^)(BOOL success))block;
//
//+(void)postSocialShare2:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType block:(void (^)(BOOL success))block ;
+ (void)postSocialShare_openshare:(PIEPageVM *)vm
              withSocialShareType:(ATOMShareType)shareType
                            block:(void (^)(BOOL))block;

+ (void)bindUserWithThirdPartyPlatform:(NSString *)type openId:(NSString *)openId
                               failure:(void (^)(void))failure
                               success:(void (^)(void))success;
@end
