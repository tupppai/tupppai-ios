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
#import <ShareSDK/ShareSDK.h>

//qq空间只能webpage ,其它均能传image
typedef NS_ENUM(NSInteger, ATOMShareType) {
    ATOMShareTypeWechatMoments = 0,
    ATOMShareTypeWechatFriends,
    ATOMShareTypeSinaWeibo,
    ATOMShareTypeQQZone,
    ATOMShareTypeQQFriends,
    ATOMShareTypeCopyLinks,
};
@interface DDShareManager : NSObject
+ (void)getUserInfo:(SSDKPlatformType)type withBlock:(void (^)(NSString* openId ))block;
+(void)postSocialShare2:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType block:(void (^)(BOOL success))block ;
+ (void)authorize:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block;//to delete
+ (void)authorize2:(SSDKPlatformType)type withBlock:(void (^)(SSDKUser* user ))block;
+ (void)getRemoteShareInfo:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType withBlock:(void (^)(ATOMShare* share))block;
+(void)copy:(PIEPageVM*)vm;


+ (void)postSocialShare3:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType block:(void (^)(BOOL success))block;

@end
