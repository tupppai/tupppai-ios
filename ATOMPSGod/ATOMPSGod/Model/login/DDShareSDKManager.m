//
//  ATOMShareSDKModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

@implementation DDShareSDKManager
////shareSDK 获取 用户手机的第三方平台的信息
//+ (void)getUserInfo:(SSDKPlatformType)type withBlock:(void (^)(NSString* openId ))block{
//    [ShareSDK getUserInfo:type conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            block(user.uid);
//        } else {
//            block(nil);
//        }
//    }];
//}
//+ (void)authorize:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block{
//    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            block(user.rawData);
//        }
//    }];
//}
//+ (void)authorize2:(SSDKPlatformType)type withBlock:(void (^)(SSDKUser* user ))block{
//    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            block(user);
//        }
//    }];
//}
//
//+ (void)getRemoteShareInfo:(DDPageVM*)vm withSocialShareType:(ATOMShareType)shareType withBlock:(void (^)(ATOMShare* share))block {
//    NSMutableDictionary* param = [NSMutableDictionary new];
//    NSString* shareTypeToServer;
//    if (shareType == ATOMShareTypeWechatFriends) {
//        shareTypeToServer = @"weixin";
//    } else if (shareType == ATOMShareTypeWechatMoments) {
//        shareTypeToServer = @"weixin";
//    } else if (shareType == ATOMShareTypeSinaWeibo) {
//        shareTypeToServer = @"weibo";
//    }  else if (shareType == ATOMShareTypeQQFriends) {
//        shareTypeToServer = @"qqzone";
//    } else if (shareType == ATOMShareTypeQQZone) {
//        shareTypeToServer = @"qqfriends";
//    } else if (shareType == ATOMShareTypeCopyLinks) {
//        shareTypeToServer = @"copylinks";
//    }
//    DDShareManager* shareModel = [DDShareManager new];
//    [param setObject:shareTypeToServer forKey:@"share_type"];
//    [param setObject:@(vm.type) forKey:@"type"];
//    [param setObject:@(vm.ID) forKey:@"target_id"];
//    [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
//        if (block) {
//            block (share);
//        }
//    }];
//}
//+(void)postSocialShare2:(DDPageVM*)vm withSocialShareType:(ATOMShareType)shareType{
//    //先获取服务器传输过来的信息
//    [self getRemoteShareInfo:vm withSocialShareType:shareType withBlock:^(ATOMShare *share) {
//        if (share) {
//            NSString* shareTitle = share.title;
//            NSString* desc = share.desc;
//            if ([shareTitle isEqualToString:@""]) {
//                shareTitle = @"我在＃图派＃分享了一张图片，你也来看看吧";
//            }
//            if ([desc isEqualToString:@""]) {
//                desc = @"＃求p＃，＃你的作品真心棒棒的❤️＃";
//            }
//            UIImage* img  ;
//   
//            NSURL* sUrl = [[NSURL alloc]initWithString:share.url];
//            NSURL* imageUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",vm.imageURL]];
//            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//            //注释掉的话 微博自动分享
//            [shareParams SSDKEnableUseClientShare];
//            if (shareType == ATOMShareTypeWechatFriends) {
//                [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//                [self shareStep2:SSDKPlatformTypeWechat withShareParams:shareParams];
//                
//            } else if (shareType == ATOMShareTypeWechatMoments) {
//                [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
//                [self shareStep2:SSDKPlatformSubTypeWechatTimeline withShareParams:shareParams];
//            } else if (shareType == ATOMShareTypeSinaWeibo) {
//                [DDService downloadImage:vm.imageURL withBlock:^(UIImage *image) {
//                    [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@ %@",desc,sUrl] title:shareTitle image:image url:sUrl latitude:0 longitude:0 objectID:nil type:SSDKContentTypeImage];
//                    
//                    [self shareStep2:SSDKPlatformTypeSinaWeibo withShareParams:shareParams];
//                }];
//            } else if (shareType == ATOMShareTypeQQFriends) {
//                [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:imageUrl type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
//                [self shareStep2:SSDKPlatformSubTypeQQFriend withShareParams:shareParams];
//            } else if (shareType == ATOMShareTypeQQZone) {
//                [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:imageUrl type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
//                [self shareStep2:SSDKPlatformSubTypeQZone withShareParams:shareParams];
//            }
//
//            
//        }
//    }];
//
//
//}
//
//
//+(void) shareStep2:(SSDKPlatformType)platformType withShareParams:(NSMutableDictionary*) shareParams {
//    //进行分享
//    [ShareSDK share:platformType
//         parameters:shareParams
//     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//         switch (state) {
//             case SSDKResponseStateSuccess:
//             {
//                 break;
//             }
//             case SSDKResponseStateFail:
//             {
//                 break;
//             }
//             case SSDKResponseStateCancel:
//             {
//                 break;
//             }
//             default:
//                 break;
//         }
//         
//     }];
//}
//
//+(void)postSocialShare:(NSInteger)id withSocialShareType:(ATOMShareType)shareType withPageType:(NSInteger)pageType {
//    DDShareManager* shareModel = [DDShareManager new];
//    NSMutableDictionary* param = [NSMutableDictionary new];
//    NSString* shareTypeToServer;
//    if (shareType == ATOMShareTypeWechatFriends) {
//        shareTypeToServer = @"weixin";
//    } else if (shareType == ATOMShareTypeWechatMoments) {
//        shareTypeToServer = @"weixin";
//    } else if (shareType == ATOMShareTypeSinaWeibo) {
//        shareTypeToServer = @"weibo";
//    }  else if (shareType == ATOMShareTypeQQFriends) {
//        shareTypeToServer = @"qqzone";
//    } else if (shareType == ATOMShareTypeQQZone) {
//        shareTypeToServer = @"qqfriends";
//    }
//    
//    [param setObject:shareTypeToServer forKey:@"share_type"];
//    [param setObject:@(pageType) forKey:@"type"];
//    [param setObject:@(id) forKey:@"target_id"];
//    [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
//        if (share) {
//            [self shareStep1:share withShareType:shareType];
//        }
//    }];
//}
//+ (void)shareStep1:(ATOMShare*)share  withShareType:(ATOMShareType)shareType {
//    NSString* shareUrl;
//    if ([share.type isEqualToString:@"image"]) {
//        shareUrl = share.imageUrl;
//    } else {
//        shareUrl = share.url;
//    }
//    NSString* shareTitle;
//    UIImage* img = [UIImage imageNamed:@"psps"];
//    NSURL* sUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",share.url]];
//    NSURL* imageUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",share.imageUrl]];
//    
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    //注释产生 微博自动分享
//    [shareParams SSDKEnableUseClientShare];
//    
//    if (shareType == ATOMShareTypeWechatFriends) {
//        shareTitle = [NSString stringWithFormat:@"%@",share.title];
//        [shareParams SSDKSetupWeChatParamsByText:share.desc title:shareTitle url:sUrl thumbImage:imageUrl image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//        [self shareStep2:SSDKPlatformTypeWechat withShareParams:shareParams];
//        
//    } else if (shareType == ATOMShareTypeWechatMoments) {
//        shareTitle = [NSString stringWithFormat:@"%@",share.title];
//        [shareParams SSDKSetupWeChatParamsByText:share.desc title:shareTitle url:sUrl thumbImage:imageUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
//        [self shareStep2:SSDKPlatformSubTypeWechatTimeline withShareParams:shareParams];
//    } else if (shareType == ATOMShareTypeSinaWeibo) {
//        shareTitle = [NSString stringWithFormat:@"强哥爱众人%@,%@",share.title,share.desc];
//        [shareParams SSDKSetupSinaWeiboShareParamsByText:shareTitle title:shareTitle image:img url:sUrl latitude:0 longitude:0 objectID:nil type:SSDKContentTypeImage];
//        [self shareStep2:SSDKPlatformTypeSinaWeibo withShareParams:shareParams];
//    } else if (shareType == ATOMShareTypeQQFriends) {
//        [shareParams SSDKSetupQQParamsByText:@"强哥爱众人" title:@"" url:sUrl thumbImage:imageUrl image:imageUrl type:SSDKContentTypeText forPlatformSubType:SSDKPlatformSubTypeQQFriend];
//        [self shareStep2:SSDKPlatformSubTypeQQFriend withShareParams:shareParams];
//    } else if (shareType == ATOMShareTypeQQZone) {
//        [shareParams SSDKSetupQQParamsByText:@"强哥爱众人" title:@"ss" url:sUrl thumbImage:imageUrl image:imageUrl type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
//        [self shareStep2:SSDKPlatformSubTypeQZone withShareParams:shareParams];
//    }
//}
@end
