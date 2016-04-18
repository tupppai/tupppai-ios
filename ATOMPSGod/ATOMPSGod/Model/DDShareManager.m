//
//  ATOMShareModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/26/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDShareManager.h"
#import "MobClickSocialAnalytics.h"


//#import "DDSessionManager.h"
#import "OpenShareHeader.h"
#import "LxDBAnything.h"
#import "OpenshareAuthUser.h"
#import "TWSNSRequest.h"
#import "NSString+SNSAddition.h"

@implementation DDShareManager

+ (void) getShareInfo:(NSDictionary *)param withBlock:(void (^)(ATOMShare *))block {
    [DDService getShareInfo:param withBlock:^(NSDictionary *data) {
        ATOMShare *share = [MTLJSONAdapter modelOfClass:[ATOMShare class] fromJSONDictionary:data error:NULL];
        block(share);
    }];
}

//
//+ (void)getUserInfo:(SSDKPlatformType)type withBlock:(void (^)(NSString* openId ))block{
//    [ShareSDK getUserInfo:type conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            block(user.uid);
//        } else {
//            block(nil);
//            [Hud error:@"获取不到信息，请重试"];
//        }
//    }];
//}
//+ (void)authorize:(SSDKPlatformType)type withBlock:(void (^)(NSDictionary* ))block{
//    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            block(user.rawData);
//        } else {
//            [Hud error:@"获取不到信息，请重试"];
//        }
//    }];
//}
//+ (void)authorize2:(SSDKPlatformType)type withBlock:(void (^)(SSDKUser* user ))block{
//    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            block(user);
//        }else {
//            [Hud error:@"获取不到信息，请重试"];
//        }
//    }];
//}

+ (void)authorize_openshare:(ATOMAuthType)authType
                  withBlock:(void (^)(OpenshareAuthUser *user))block
                    Failure:(void (^)(NSDictionary *message, NSError *error))failureBlock
{
    /*
        自问自答：
        Q: 为什么一定要有一个FailureBlock回调到外面， 而不是把错误信息自己消化弹个窗就算了？
        A: 一般情况下，在图派APP中，假如分享、第三方登录失败，对这些失败的回馈操作充其量只需要弹个窗提示一下用户即可，其他一切都不变；
           唯一需要FailureBlock回调的场景，就是设定-> 账户安全-> 绑定第三方平台: 假如绑定失败，必须重置 UISwitch的UI
     */
    
    // 利用第三方登录，获得第三方平台用户的相应信息
    @weakify(self);
    switch (authType) {
        case ATOMAuthTypeWeibo: {
            if ([OpenShare isWeiboInstalled] == NO) {
                [Hud error:@"手机里没有安装微博APP"];
                if (failureBlock != nil) {
                    failureBlock(nil, nil);
                }
            }else{
                [OpenShare WeiboAuth:@"all"
                         redirectURI:@"https://api.weibo.com/oauth2/default.html"
                             Success:^(NSDictionary *message) {
                                 @strongify(self);
                                 [self weiboOAuthWithMessage:message
                                           completionHandler:^(OpenshareAuthUser *user) {
                                               if (block != nil) {
                                                   block(user);
                                               }
                                           }];
                             } Fail:^(NSDictionary *message, NSError *error) {
                                 [Hud error:@"获取不到信息，请重试"];
                                 if (failureBlock != nil) {
                                     failureBlock(message, error);
                                 }
                             }];
            }
            break;
        }
        case ATOMAuthTypeWeixin: {
            if ([OpenShare isWeixinInstalled] == NO) {
                [Hud error:@"手机里没有安装微信APP"];
                if (failureBlock != nil) {
                    failureBlock(nil, nil);
                }
            }
            else{
                [OpenShare WeixinAuth:@"snsapi_userinfo"
                              Success:^(NSDictionary *message) {
                                  @strongify(self);
                                  [self weixinOAuthWithMessage:message
                                             completionHandler:^(OpenshareAuthUser *user) {
                                                 if (block != nil) {
                                                     block(user);
                                                 }
                                             }];
                              } Fail:^(NSDictionary *message, NSError *error) {
                                  [Hud error:@"获取不到信息，请重试"];
                                  if (failureBlock != nil) {
                                      failureBlock(message, error);
                                  }
                              }];
            }
            break;
        }
        case ATOMAuthTypeQQ: {
            
            if ([OpenShare isQQInstalled] == NO) {
                [Hud error:@"手机没有安装QQ"];
                if (failureBlock != nil) {
                    failureBlock(nil, nil);
                }
            }
            else{
                [OpenShare QQAuth:@"get_user_info"
                          Success:^(NSDictionary *message) {
                              @strongify(self);
                              [self qqOAuthWithMessage:message
                                     completionHandler:^(OpenshareAuthUser *user) {
                                         if (block != nil) {
                                             block(user);
                                         }
                                     }];
                          } Fail:^(NSDictionary *message, NSError *error) {
                              [Hud error:@"获取不到信息，请重试"];
                              if (failureBlock != nil) {
                                  failureBlock(message, error);
                              }
                          }];
            }
            break;
        }
    }
}

+ (void)getRemoteShareInfo:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType withBlock:(void (^)(ATOMShare* share))block {
    NSMutableDictionary* param = [NSMutableDictionary new];
    NSString* shareTypeToServer = @"";
    MobClickSocialWeibo *   weibo=[[MobClickSocialWeibo alloc] initWithPlatformType:MobClickSocialTypeFacebook weiboId:nil usid:nil param:nil];
    
    if (shareType == ATOMShareTypeWechatFriends) {
        shareTypeToServer = @"wechat_friend";
        weibo=[[MobClickSocialWeibo alloc] initWithPlatformType:MobClickSocialTypeWxsesion weiboId:nil usid:nil param:nil];
    } else if (shareType == ATOMShareTypeWechatMoments) {
        shareTypeToServer = @"wechat_timeline";
        weibo=[[MobClickSocialWeibo alloc] initWithPlatformType:MobClickSocialTypeWxtimeline weiboId:nil usid:nil param:nil];

    } else if (shareType == ATOMShareTypeSinaWeibo) {
        weibo=[[MobClickSocialWeibo alloc] initWithPlatformType:MobClickSocialTypeSina weiboId:nil usid:nil param:nil];
        shareTypeToServer = @"weibo";
    }  else if (shareType == ATOMShareTypeQQFriends) {
        weibo=[[MobClickSocialWeibo alloc] initWithPlatformType:MobClickSocialTypeQQ weiboId:nil usid:nil param:nil];

        shareTypeToServer = @"qq_timeline";
    } else if (shareType == ATOMShareTypeQQZone) {
        weibo=[[MobClickSocialWeibo alloc] initWithPlatformType:MobClickSocialTypeQzone weiboId:nil usid:nil param:nil];

        shareTypeToServer = @"qq_friend";
    } else if (shareType == ATOMShareTypeCopyLinks) {
        weibo=[[MobClickSocialWeibo alloc] initWithPlatformType:@"copy" weiboId:nil usid:nil param:nil];
        shareTypeToServer = @"copy";
    }
    NSArray* array = [NSArray arrayWithObject:weibo];
    [MobClickSocialAnalytics postWeiboCounts:array appKey:@"55b1ecdbe0f55a1de9001164" topic:vm.content completion:nil];
    [param setObject:shareTypeToServer forKey:@"share_type"];
    [param setObject:@(vm.type) forKey:@"type"];
    [param setObject:@(vm.ID) forKey:@"target_id"];
    [self getShareInfo:param withBlock:^(ATOMShare *share) {
        if (block) {
            block (share);
        }
    }];
}

+(void)copy:(PIEPageVM*)vm {
    [self getRemoteShareInfo:vm withSocialShareType:ATOMShareTypeCopyLinks withBlock:^(ATOMShare *share) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (share == nil) {
            [Hud text:@"数据为空"];
            return ;
        }
        pasteboard.string = share.url;
        [Hud success:@"成功复制到粘贴板"];
    }];
}

/*
+(void)postSocialShare2:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType block:(void (^)(BOOL success))block {
    
    //先获取服务器传输过来的信息
    [Hud activity:@""];
    [self getRemoteShareInfo:vm withSocialShareType:shareType withBlock:^(ATOMShare *share) {
        [Hud dismiss];
        if (share == nil) {
            [Hud text:@"获取分享信息失败"];
            return ;
        }
            NSString* shareTitle = share.title;
            NSString* desc = share.desc;
            if ([shareTitle isEqualToString:@""]) {
                shareTitle = @"我在#图派#app分享了一张图片，你也来看看吧";
            }
            if ([desc isEqualToString:@""]) {
                desc = @"我在#图派#app分享了一张图片，你也来看看吧";
            }
            NSURL* sUrl = [[NSURL alloc]initWithString:share.url];
            
            NSString* imageUrl_trimmed = [share.imageUrl trimToImageWidth:100];
            NSURL* imageUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",imageUrl_trimmed]];
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            //注释掉的话 微博自动分享
            [shareParams SSDKEnableUseClientShare];
        
            if (shareType == ATOMShareTypeWechatFriends) {
                if ([share.type isEqualToString:@"image" ]) {
                    //这里要自己生成图片
                    [Util generateShareImageFromViewModel:vm block:^(UIImage *img2) {
                        [shareParams SSDKSetupWeChatParamsByText:desc title:nil url:nil thumbImage:nil image:img2 musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                        [self shareStep2:SSDKPlatformTypeWechat withShareParams:shareParams block:^(BOOL success) {
                            if (block) {
                                block(success);
                            }
                        }];

                    }];
                }    else   {
                    [DDService sd_downloadImage:vm.imageURL withBlock:^(UIImage *image) {
                        
                    [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:sUrl thumbImage:image image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                    [self shareStep2:SSDKPlatformTypeWechat withShareParams:shareParams block:^(BOOL success) {
                        if (block) {
                            block(success);
                        }
                    }];
                    }];
                }

                
            }
            else if (shareType == ATOMShareTypeWechatMoments) {
                if ([share.type isEqualToString:@"image" ]) {
                   [Util generateShareImageFromViewModel:vm block:^(UIImage *image) {
                                  [shareParams SSDKSetupWeChatParamsByText:nil title:@"图派" url:nil thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                       [self shareStep2:SSDKPlatformSubTypeWechatTimeline withShareParams:shareParams block:^(BOOL success) {
                           if (block) {
                               block(success);
                           }
                       }];


                        }];
                }
                else {
                    [DDService sd_downloadImage:vm.imageURL withBlock:^(UIImage *image) {
                        [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:sUrl thumbImage:image image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                        [self shareStep2:SSDKPlatformSubTypeWechatTimeline withShareParams:shareParams block:^(BOOL success) {
                            if (block) {
                                block(success);
                            }
                        }];
                    }];

                }
            }
            else if (shareType == ATOMShareTypeSinaWeibo) {
                if ([share.type isEqualToString:@"image"]) {
                    [Util generateShareImageFromViewModel:vm block:^(UIImage *img) {
                        [shareParams SSDKSetupSinaWeiboShareParamsByText:desc title:nil image:img url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeImage];
                        [self shareStep2:SSDKPlatformTypeSinaWeibo withShareParams:shareParams block:^(BOOL success) {
                            if (block) {
                                block(success);
                            }
                        }];

                    }];
                } else {
                    [DDService sd_downloadImage:vm.imageURL withBlock:^(UIImage *image) {
                        [shareParams SSDKSetupSinaWeiboShareParamsByText:desc title:shareTitle image:image url:sUrl latitude:0 longitude:0 objectID:nil type:SSDKContentTypeWebPage];
                        [self shareStep2:SSDKPlatformTypeSinaWeibo withShareParams:shareParams block:^(BOOL success) {
                            if (block) {
                                block(success);
                            }
                        }];
                    }];

                }

            }
            else if (shareType == ATOMShareTypeQQFriends) {
                if ([share.type isEqualToString:@"image" ]) {
                    [Util generateShareImageFromViewModel:vm block:^(UIImage *img) {
                        [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:img type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                        [self shareStep2:SSDKPlatformSubTypeQQFriend withShareParams:shareParams block:^(BOOL success) {
                            if (block) {
                                block(success);
                            }
                        }];
                    }];
                }
                else {
                        [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                        [self shareStep2:SSDKPlatformSubTypeQQFriend withShareParams:shareParams block:^(BOOL success) {
                            if (block) {
                                block(success);
                            }
                        }];
                }


            }
            else if (shareType == ATOMShareTypeQQZone) {
                    [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
                    [self shareStep2:SSDKPlatformSubTypeQZone withShareParams:shareParams block:^(BOOL success) {
                        if (block) {
                            block(success);
                        }
                }];

            }
        
    }];

}
*/
/*
    第三版postSocialShare与第二版的主要区别：
    － 分享的时候具体是显示什么图片，由服务器决定（即：使用-[ATOMShare imageUrl])，而不是自带的viewModel的图片。
    - 一直没搞清楚第二版的postSocialShare是什么鬼，为什么要有这么多的判断？
 
 */

/*
+ (void)postSocialShare3:(PIEPageVM*)vm withSocialShareType:(ATOMShareType)shareType block:(void (^)(BOOL success))block {
    
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
            NSURL* sUrl = [[NSURL alloc]initWithString:share.url];
            NSString* imageUrl_trimmed = [share.imageUrl trimToImageWidth:100];
            NSURL* imageUrl = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",imageUrl_trimmed]];
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKEnableUseClientShare];
            
            if (shareType == ATOMShareTypeWechatFriends) {
                    [DDService sd_downloadImage:share.imageUrl withBlock:^(UIImage *image) {
                        [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:sUrl thumbImage:image image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                        [self shareStep2:SSDKPlatformTypeWechat withShareParams:shareParams block:^(BOOL success) {
                            if (block) {
                                block(success);
                            }
                        }];
                    }];
            }
            else if (shareType == ATOMShareTypeWechatMoments) {
                    [DDService sd_downloadImage:share.imageUrl withBlock:^(UIImage *image)
                     {
                        [shareParams SSDKSetupWeChatParamsByText:desc title:shareTitle url:sUrl thumbImage:image image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                        [self shareStep2:SSDKPlatformSubTypeWechatTimeline withShareParams:shareParams block:^(BOOL success) {
                            if (block) {
                                block(success);
                            }
                        }];
                    }];
            }
            else if (shareType == ATOMShareTypeSinaWeibo) {
                [DDService sd_downloadImage:share.imageUrl withBlock:^(UIImage *image) {
                    [shareParams SSDKSetupSinaWeiboShareParamsByText:desc title:shareTitle image:image url:sUrl latitude:0 longitude:0 objectID:nil type:SSDKContentTypeWebPage];
                    [self shareStep2:SSDKPlatformTypeSinaWeibo withShareParams:shareParams block:^(BOOL success) {
                        if (block) {
                            block(success);
                        }
                    }];
                }];
            }
            else if (shareType == ATOMShareTypeQQFriends) {
                [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                [self shareStep2:SSDKPlatformSubTypeQQFriend withShareParams:shareParams block:^(BOOL success) {
                    if (block) {
                        block(success);
                    }
                }];
            }
            else if (shareType == ATOMShareTypeQQZone) {
                [shareParams SSDKSetupQQParamsByText:desc title:shareTitle url:sUrl thumbImage:imageUrl image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
                [self shareStep2:SSDKPlatformSubTypeQZone withShareParams:shareParams block:^(BOOL success) {
                    if (block) {
                        block(success);
                    }
                }];
                
            }
        }
    }];
    
    
}
*/

/*
+(void) shareStep2:(SSDKPlatformType)platformType withShareParams:(NSMutableDictionary*) shareParams block:(void (^)(BOOL success))block {
    //进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 if (block) {
                     block(YES);
                     [Hud success:@"分享成功"];
                 }
                 break;
             }
             case SSDKResponseStateFail:
             {
                 if (block) {
                     block(NO);
                     [Hud text:@"分享失败,您可能没有安装客户端"];
                 }
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 if (block) {
                     block(NO);
                     [Hud text:@"取消分享"];
                 }
                 break;
             }
             default:
                 break;
         }
         
     }];
}
*/

+ (void)postSocialShare_openshare:(PIEPageVM *)vm
              withSocialShareType:(ATOMShareType)shareType
                            block:(void (^)(BOOL))block
{
    NSDictionary *thirdplatformChineseDict =
    @{@(ATOMShareTypeQQZone):@"QQ",
      @(ATOMShareTypeQQFriends):@"QQ",
      @(ATOMShareTypeSinaWeibo):@"微博",
      @(ATOMShareTypeWechatFriends):@"微信",
      @(ATOMShareTypeWechatMoments):@"微信"};
    
    if ([self hasInstalledShareType:shareType] == NO) {
        NSString *prompt =
        [NSString stringWithFormat:@"手机没有安装%@的APP，分享不了",thirdplatformChineseDict[@(shareType)]];
        
        [Hud error:prompt];
        if (block != nil) {
            block(NO);
        }
    }
    else{
        //先获取服务器传输过来的信息
        [self
         getRemoteShareInfo:vm
         withSocialShareType:shareType
         withBlock:^(ATOMShare *share) {
             if (share != nil) {
                 NSString* shareTitle = share.title;
                 NSString* desc = share.desc;
                 if ([shareTitle isEqualToString:@""]) {
                     shareTitle = @"我在#图派#app分享了一张图片，你也来看看吧";
                 }
                 if ([desc isEqualToString:@""]) {
                     desc = @"我在#图派#app分享了一张图片，你也来看看吧";
                 }
                 NSString* imageUrl_trimmed = [share.imageUrl trimToImageWidth:100];
                 
                 // Create OSMessage for OpenShare
                 OSMessage *message = [[OSMessage alloc] init];
                 message.title      = shareTitle;
                 message.link       = share.url;
                 message.desc       = share.desc;
                 
                 [DDService
                  sd_downloadImage:imageUrl_trimmed
                  withBlock:^(UIImage *image) {
                      message.thumbnail = image;
                      message.image     = image;
                      
                      // sharing by OpenShare
                      if (shareType == ATOMShareTypeWechatFriends) {
                          [OpenShare
                           shareToWeixinSession:message
                           Success:^(OSMessage *message) {
                               [Hud success:@"成功分享到微信"];
                               if (block != nil) {
                                   block(YES);
                               }
                           }
                           Fail:^(OSMessage *message, NSError *error) {
                               [Hud error:@"分享到微信失败"];
                               if (block != nil) {
                                   block(NO);
                               }
                           }];
                      }
                      else if (shareType == ATOMShareTypeWechatMoments){
                          [OpenShare
                           shareToWeixinTimeline:message
                           Success:^(OSMessage *message) {
                               [Hud success:@"成功分享到微信朋友圈"];
                               if (block != nil) {
                                   block(YES);
                               }
                           } Fail:^(OSMessage *message, NSError *error) {
                               [Hud error:@"没有分享到微信朋友圈"];
                               if (block != nil) {
                                   block(NO);
                               }
                           }];
                      }
                      else if (shareType == ATOMShareTypeSinaWeibo){
                          [OpenShare
                           shareToWeibo:message
                           Success:^(OSMessage *message) {
                               [Hud success:@"成功分享到微博"];
                               if (block != nil) {
                                   block(YES);
                               }
                               
                           } Fail:^(OSMessage *message, NSError *error) {
                               [Hud error:@"没有分享到微博"];
                               if (block != nil) {
                                   block(NO);
                               }
                           }];
                      }
                      else if (shareType == ATOMShareTypeQQFriends){
                          [OpenShare
                           shareToQQFriends:message
                           Success:^(OSMessage *message) {
                               [Hud success:@"顺利分享QQ好友"];
                               if (block != nil) {
                                   block(YES);
                               }
                               
                           } Fail:^(OSMessage *message, NSError *error) {
                               [Hud error:@"没有分享到QQ好友"];
                               if (block != nil) {
                                   block(NO);
                               }
                           }];
                      }
                      else if (shareType == ATOMShareTypeQQZone){
                          [OpenShare
                           shareToQQZone:message
                           Success:^(OSMessage *message) {
                               [Hud success:@"顺利分享QQ空间"];
                               if (block != nil) {
                                   block(YES);
                               }
                           } Fail:^(OSMessage *message, NSError *error) {
                               [Hud error:@"没有分享到QQ好友"];
                               if (block != nil) {
                                   block(NO);
                               }
                           }];
                      }
                  }];
             }
         }];
    }
    
    
    
}

+ (void)bindUserWithThirdPartyPlatform:(NSString *)type openId:(NSString *)openId
                               failure:(void (^)(void))failure
                               success:(void (^)(void))success
{
    /*
     auth/bind, POST, openid, type(qq, weixin or weibo)
     */
    
    NSMutableDictionary *params = [NSMutableDictionary <NSString *, NSString *> new];
    params[@"type"]             = type;
    params[@"openid"]           = openId;
    
    [Hud activity:@"绑定中..."];
    [DDBaseService POST:params
                    url:@"auth/bind"
                  block:^(id responseObject) {
                      [Hud dismiss];
                      
                      if (responseObject == nil) {
                          if (failure != nil) {
                              failure();
                          }
                      }else{
                          if (success != nil) {
                              success();
                          }
                      }
                  }];
}


#pragma mark - OpenShare private helpers
// TODO: 以后重构到Openshare里面

// NSDictionary -> OpenshareAuthUser

+ (void)weixinOAuthWithMessage:(NSDictionary *)message
             completionHandler:(void (^)(OpenshareAuthUser* user))completionHandler
{
    NSString *url =
    [NSString
     stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
     kSNSPlatformWeixinID, kSNSPlatformWeixinSecret, message[@"code"]];
    
    [TWSNSRequest get:url completionHandler:^(NSDictionary *data, NSError *error) {
        NSString *accessToken = data[@"access_token"];
        NSString *openid = data[@"openid"];
        
        NSString *userInfoUrl =
        [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=zh_CN", accessToken, openid];
        [TWSNSRequest get:userInfoUrl
        completionHandler:^(NSDictionary *userInfo, NSError *error) {
            NSMutableDictionary *completeUserInfo = userInfo.mutableCopy;
            [completeUserInfo addEntriesFromDictionary:message];
            // 就地捏出一个OpenshareAuthUser出来

            OpenshareAuthUser *authUser = [OpenshareAuthUser new];
            authUser.rawData            = completeUserInfo;
            authUser.nickname           = completeUserInfo[@"nickname"];
            authUser.icon               = completeUserInfo[@"headimgurl"];
            authUser.uid                = completeUserInfo[@"openid"];
            completionHandler(authUser);
        }];
    }];
}

+ (void)weiboOAuthWithMessage:(NSDictionary *)message
            completionHandler:(void (^)(OpenshareAuthUser* user))completionHandler
{
    NSString *url        = @"https://api.weibo.com/2/users/show.json";
    NSDictionary *params = @{@"source": kSNSPlatformWeiboID,
                             @"access_token": message[@"accessToken"],
                             @"uid": message[@"userID"]};
    [TWSNSRequest get:url
               params:params
    completionHandler:^(NSDictionary *data, NSError *error) {
        NSMutableDictionary *completeUserInfo = data.mutableCopy;
        [completeUserInfo addEntriesFromDictionary:message];
        // 就地捏出一个OpenshareAuthUser出来
        OpenshareAuthUser *authUser = [[OpenshareAuthUser alloc] init];
        authUser.nickname           = completeUserInfo[@"screen_name"];
        authUser.icon               = completeUserInfo[@"avatar_large"];
        authUser.uid                = completeUserInfo[@"idstr"];
        authUser.rawData            = completeUserInfo;
        completionHandler(authUser);
    }];
}

+ (void)qqOAuthWithMessage:(NSDictionary *)message
         completionHandler:(void (^)(OpenshareAuthUser* user))completionHandler
{
    NSString *url = @"https://graph.qq.com/user/get_user_info";
    NSDictionary *params = @{@"oauth_consumer_key": kSNSPlatformQQID,
                             @"access_token": message[@"access_token"],
                             @"openid": message[@"openid"]};
    [TWSNSRequest get:url
               params:params
    completionHandler:^(NSDictionary *data, NSError *error) {
        NSMutableDictionary *completeUserInfo = data.mutableCopy;
        [completeUserInfo addEntriesFromDictionary:message];
        
        // 自己手捏一个OpenshareAuth
        OpenshareAuthUser *authUser = [OpenshareAuthUser new];
        authUser.nickname = completeUserInfo[@"nickname"];
        authUser.icon     = completeUserInfo[@"figureurl_qq_2"];
        authUser.uid      = completeUserInfo[@"openid"];
        authUser.rawData  = completeUserInfo;
        completionHandler(authUser);
    }];
}

/**
 *  ATOMShareType -> BOOL
 *
 *  判断对应的第三方平台是否已经在手机安装了APP
 */
+ (BOOL)hasInstalledShareType:(ATOMShareType)shareType
{
    switch (shareType) {
        case ATOMShareTypeWechatMoments:
        case ATOMShareTypeWechatFriends: {
            return [OpenShare isWeixinInstalled];
            break;
        }
        case ATOMShareTypeSinaWeibo: {
            return [OpenShare isWeiboInstalled];
            break;
        }
        case ATOMShareTypeQQZone:
        case ATOMShareTypeQQFriends: {
            return [OpenShare isQQInstalled];
            break;
        }
        case ATOMShareTypeCopyLinks: {
            return NO;
            break;
        }
    }
    return NO;
}

@end
