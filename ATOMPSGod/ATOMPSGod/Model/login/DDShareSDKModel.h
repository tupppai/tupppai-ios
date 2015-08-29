//
//  ATOMShareSDKModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface DDShareSDKModel : NSObject
+ (void)getUserInfo:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block;
+(void)postSocialShare:(NSInteger)id withSocialShareType:(ATOMSocialShareType)shareType withPageType:(ATOMPageType)pageType;
+ (void)authorize:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block;
@end
