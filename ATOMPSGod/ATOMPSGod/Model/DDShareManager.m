//
//  ATOMShareModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/26/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDShareManager.h"
//#import "DDSessionManager.h"
@implementation DDShareManager

+ (void) getShareInfo:(NSDictionary *)param withBlock:(void (^)(ATOMShare *))block {
    [DDService getShareInfo:param withBlock:^(NSDictionary *data) {
        ATOMShare *share = [MTLJSONAdapter modelOfClass:[ATOMShare class] fromJSONDictionary:data error:NULL];
        block(share);
    }];
}


+ (void)getUserInfo:(SSDKPlatformType)type withBlock:(void (^)(NSString* openId ))block{
    [ShareSDK getUserInfo:type conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            block(user.uid);
        } else {
            block(nil);
        }
    }];
}
+ (void)authorize:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block{
    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            block(user.rawData);
        }
    }];
}
+ (void)authorize2:(SSDKPlatformType)type withBlock:(void (^)(SSDKUser* user ))block{
    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            block(user);
        }
    }];
}

+ (void)getRemoteShareInfo:(DDPageVM*)vm withSocialShareType:(ATOMShareType)shareType withBlock:(void (^)(ATOMShare* share))block {
    NSMutableDictionary* param = [NSMutableDictionary new];
    NSString* shareTypeToServer = @"";
    if (shareType == ATOMShareTypeWechatFriends) {
        shareTypeToServer = @"wechat_friend";
    } else if (shareType == ATOMShareTypeWechatMoments) {
        shareTypeToServer = @"wechat_timeline";
    } else if (shareType == ATOMShareTypeSinaWeibo) {
        shareTypeToServer = @"weibo";
    }  else if (shareType == ATOMShareTypeQQFriends) {
        shareTypeToServer = @"qq_timeline";
    } else if (shareType == ATOMShareTypeQQZone) {
        shareTypeToServer = @"qq_friend";
    } else if (shareType == ATOMShareTypeCopyLinks) {
        shareTypeToServer = @"copy";
    }
    [param setObject:shareTypeToServer forKey:@"share_type"];
    [param setObject:@(vm.type) forKey:@"type"];
    [param setObject:@(vm.ID) forKey:@"target_id"];
    [self getShareInfo:param withBlock:^(ATOMShare *share) {
        if (block) {
            block (share);
        }
    }];
}

+(void)copy:(DDPageVM*)vm {
    [self getRemoteShareInfo:vm withSocialShareType:ATOMShareTypeCopyLinks withBlock:^(ATOMShare *share) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = share.url;
        [Hud success:@"成功复制到粘贴板"];
    }];
}
+(void)postSocialShare2:(DDPageVM*)vm withSocialShareType:(ATOMShareType)shareType{
    
    //先获取服务器传输过来的信息
    [self getRemoteShareInfo:vm withSocialShareType:shareType withBlock:^(ATOMShare *share) {
        if (share) {
            NSString* shareTitle = share.title;
            NSString* desc = share.desc;
            if ([shareTitle isEqualToString:@""]) {
                shareTitle = @"我在#图派#app分享了一张图片，你也来看看吧";
            }
            if ([desc isEqualToString:@""]) {
                desc = @"我在#图派#app分享了一张图片，你也来看看吧";
            }
            UIImage* img = [UIImage imageNamed:@"psps"];
            
            NSURL* sUrl = [[NSURL alloc]initWithString:share.url];
            NSURL* imageUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",share.imageUrl]];
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            //注释掉的话 微博自动分享
            [shareParams SSDKEnableUseClientShare];
            
            
            if (shareType == ATOMShareTypeWechatFriends) {
                if ([share.type isEqualToString:@"image" ]) {
                    //这里要自己生成图片
                    [Util imageWithVm:vm block:^(UIImage *img2) {
                        NSLog(@"ATOMShareTypeWechatFriends %@",img2);
                        [shareParams SSDKSetupWeChatParamsByText:desc title:nil url:nil thumbImage:nil image:img2 musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                        [self shareStep2:SSDKPlatformTypeWechat withShareParams:shareParams];

                    }];
                }    else   {
                    [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:sUrl thumbImage:sUrl image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                    [self shareStep2:SSDKPlatformTypeWechat withShareParams:shareParams];

                }

                
            }
            
            
            else if (shareType == ATOMShareTypeWechatMoments) {
//                SSDKContentType contentType = SSDKContentTypeWebPage;
                if ([share.type isEqualToString:@"image" ]) {
                   [Util imageWithVm:vm block:^(UIImage *image) {
                                  [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:nil thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                       [self shareStep2:SSDKPlatformSubTypeWechatTimeline withShareParams:shareParams];

                        }];
                }
                else {
                    [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:sUrl thumbImage:nil image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                    [self shareStep2:SSDKPlatformSubTypeWechatTimeline withShareParams:shareParams];
                }
            }
            
            
            else if (shareType == ATOMShareTypeSinaWeibo) {
                if ([share.type isEqualToString:@"image"]) {
                    [Util imageWithVm:vm block:^(UIImage *img) {
                        [shareParams SSDKSetupSinaWeiboShareParamsByText:desc title:nil image:img url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeImage];
                        [self shareStep2:SSDKPlatformTypeSinaWeibo withShareParams:shareParams];
                    }];
                } else {
                        [shareParams SSDKSetupSinaWeiboShareParamsByText:desc title:shareTitle image:nil url:sUrl latitude:0 longitude:0 objectID:nil type:SSDKContentTypeWebPage];
                        [self shareStep2:SSDKPlatformTypeSinaWeibo withShareParams:shareParams];
                }

            }
            else if (shareType == ATOMShareTypeQQFriends) {
                SSDKContentType contentType = SSDKContentTypeWebPage;
                if ([share.type isEqualToString:@"image" ]) {
                    contentType = SSDKContentTypeImage;
                }
                [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:imageUrl type:contentType forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                [self shareStep2:SSDKPlatformSubTypeQQFriend withShareParams:shareParams];
            } else if (shareType == ATOMShareTypeQQZone) {
                [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:imageUrl type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
                [self shareStep2:SSDKPlatformSubTypeQZone withShareParams:shareParams];
            }
            
            
        }
    }];
    
    
}


+(void) shareStep2:(SSDKPlatformType)platformType withShareParams:(NSMutableDictionary*) shareParams {
    //进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 break;
             }
             case SSDKResponseStateFail:
             {
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
         
     }];
}

@end
