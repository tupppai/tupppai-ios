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

-(void)postSocialShare:(NSInteger)id withSocialShareType:(ATOMSocialShareType)shareType withPageType:(ATOMPageType)pageType {
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
//                [self postSocialShareShareSdk:share withShareType:shareType];
            }
        }];
}
- (void)postSocialShareShareSdk:(ATOMShare*)share  withShareType:(ATOMSocialShareType)shareType {
//
        SSDKPlatformType type;
        NSString* shareUrl;
//
        if ([share.type isEqualToString:@"image"]) {
            shareUrl = share.imageUrl;
        } else {
            shareUrl = share.url;
        }
//
        NSString* shareTitle;
    UIImage* img = [UIImage imageNamed:@"1"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

//
        if (shareType == ATOMShareTypeWechatFriends) {
//            type = ShareTypeWeixiSession;
            [shareParams SSDKSetupWeChatParamsByText:@"" title:@"" url:nil thumbImage:img image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformTypeWechat];
                shareTitle = [NSString stringWithFormat:@"%@",share.title];
        } else if (shareType == ATOMShareTypeWechatMoments) {
//            type = ShareTypeWeixiTimeline;
            shareTitle = [NSString stringWithFormat:@"%@",share.title];
        } else if (shareType == ATOMShareTypeSinaWeibo) {
//            type = SSCShareTypeSinaWeibo;
            shareTitle = [NSString stringWithFormat:@"#求PS大神#%@!点击链接%@",share.title,shareUrl];
        }
//        NSString *str=[[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"];
//        NSData *fileData = [NSData dataWithContentsOfFile:str];
//    
//        id<ISSContent> publishContent = [ShareSDK content:shareTitle //微博显示的文字
//                                           defaultContent:share.title
//                                                    image:[ShareSDK imageWithData:fileData fileName:@"image" mimeType:@"Application/Image"]
//                                                    title:shareTitle
//                                                      url:shareUrl
//                                              description:share.desc
//                                                mediaType:SSPublishContentMediaTypeImage];
//        [ShareSDK clientShareContent:publishContent //内容对象
//                                type:type //平台类型
//                       statusBarTips:NO
//                              result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
//                                  [[KShareManager mascotAnimator]dismiss];
//                                  if (state == SSPublishContentStateSuccess)
//                                  {
//                                      NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
//                                  }
//                                  else if (state == SSPublishContentStateFail)
//                                  {
//                                      NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
//                                  }
//                              }];
//}

+(void) share {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:@[[UIImage imageNamed:@"1"]]
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeText];
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeWechat
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}
@end
