//
//  ATOMShareSDKModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMShareSDKModel.h"
@implementation ATOMShareSDKModel
//shareSDK 获取 用户手机的第三方平台的信息
+ (void)getUserInfo:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block{
    [ShareSDK getUserInfo:type conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSLog(@"第三平台user rawData%@ ",user.rawData);
        block(user.rawData);
    }];
}
+ (void)authorize:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block{

    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSLog(@"第三平台user rawData%@ ",user.rawData);
        block(user.rawData);
    }];
}

+(void)postSocialShare:(NSInteger)id withSocialShareType:(ATOMSocialShareType)shareType withPageType:(ATOMPageType)pageType {
        ATOMShareModel* shareModel = [ATOMShareModel new];
        NSMutableDictionary* param = [NSMutableDictionary new];
        NSString* shareTypeToServer;
        if (shareType == ATOMShareTypeWechatFriends) {
            shareTypeToServer = @"weixin";
        } else if (shareType == ATOMShareTypeWechatMoments) {
            shareTypeToServer = @"weixin";
        } else if (shareType == ATOMShareTypeSinaWeibo) {
            shareTypeToServer = @"weibo";
        }
        [param setObject:shareTypeToServer forKey:@"share_type"];
        [param setObject:@(pageType) forKey:@"type"];
        [param setObject:@(id) forKey:@"target_id"];
        [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
            if (share) {
                [self shareStep1:share withShareType:shareType];
            }
        }];
}
+ (void)shareStep1:(ATOMShare*)share  withShareType:(ATOMSocialShareType)shareType {
    NSLog(@"ATOMShare url%@,title%@,desc%@,imgurl%@",share.url,share.title,share.desc,share.imageUrl);
        NSString* shareUrl;
        if ([share.type isEqualToString:@"image"]) {
            shareUrl = share.imageUrl;
        } else {
            shareUrl = share.url;
        }
        NSString* shareTitle;
    UIImage* img = [UIImage imageNamed:@"psps"];
    NSURL* sUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",share.url]];
    NSURL* imageUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",share.imageUrl]];

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (shareType == ATOMShareTypeWechatFriends) {
            shareTitle = [NSString stringWithFormat:@"%@",share.title];
            [shareParams SSDKSetupWeChatParamsByText:share.desc title:shareTitle url:sUrl thumbImage:imageUrl image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            [self shareStep2:SSDKPlatformTypeWechat withShareParams:shareParams];

        } else if (shareType == ATOMShareTypeWechatMoments) {
            shareTitle = [NSString stringWithFormat:@"%@",share.title];
            [shareParams SSDKSetupWeChatParamsByText:share.desc title:shareTitle url:sUrl thumbImage:imageUrl image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            [self shareStep2:SSDKPlatformSubTypeWechatTimeline withShareParams:shareParams];
        } else if (shareType == ATOMShareTypeSinaWeibo) {
            shareTitle = [NSString stringWithFormat:@"\"%@,%@\" ! 求PS大神显灵，还不快戳",share.title,share.desc];
            [shareParams SSDKSetupSinaWeiboShareParamsByText:shareTitle title:shareTitle image:img url:sUrl latitude:0 longitude:0 objectID:nil type:SSDKContentTypeImage];
            [self shareStep2:SSDKPlatformTypeSinaWeibo withShareParams:shareParams];
        }
}

+(void) shareStep2:(SSDKPlatformType)platformType withShareParams:(NSMutableDictionary*) shareParams {
    //进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [Util ShowTSMessageSuccess:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {

#if DEBUG
                 NSString* errorMsg = [error.userInfo objectForKey:@"error_message"];

                                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                      message:[NSString stringWithFormat:@"%@", errorMsg]
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"确定"
                                                                            otherButtonTitles:nil];
                                  [alertView show];
#else
                 [Util ShowTSMessageError:@"分享失败"];
#endif

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
