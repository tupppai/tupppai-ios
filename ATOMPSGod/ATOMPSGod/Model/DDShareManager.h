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

// 新需求：openshare -> ShareSDK, 第三方登录&分享

/**
 *  获取第三方社交平台的用户个人信息（头像、用户名、OpenID）
 *
 *  @param authType     社交平台（QQ, Weixin, Weibo)
 *  @param block        successBlock， 回调第三方用户
 *  @param failureBlock 无法获取第三方社交平台的用户信息（也许是没有安装对应的APP？）
 */
+ (void)authorize_openshare:(ATOMAuthType)authType
                  withBlock:(void (^)(OpenshareAuthUser *user))block
                    Failure:(void (^)(NSDictionary *message, NSError *error))failureBlock;

+ (void)getRemoteShareInfo:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType withBlock:(void (^)(ATOMShare* share))block;
+(void)copy:(PIEPageVM*)vm;


/**
 *  向第三方社交平台分享内容
 *
 *  @param vm        需要分享的PageVM
 *  @param shareType 分享的社交平台
 *  @param block     回调是否分享成功
 */
+ (void)postSocialShare_openshare:(PIEPageVM *)vm
              withSocialShareType:(ATOMShareType)shareType
                            block:(void (^)(BOOL))block;

/**
 *  向图派服务器发送绑定请求 
    auth/bind, POST, openid, type(qq, weixin or weibo)
 *
 *  @param type    绑定的社交平台
 *  @param openId  第三方用户的OpenID
 */
+ (void)bindUserWithThirdPartyPlatform:(NSString *)type openId:(NSString *)openId
                               failure:(void (^)(void))failure
                               success:(void (^)(void))success;
@end
