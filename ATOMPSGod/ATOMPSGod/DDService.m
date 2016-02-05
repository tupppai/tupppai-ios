//
//  DDProfileService.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/28/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDService.h"
//负责处理key，返回要的json，不做任何数据库操作，mantle操作，这些操作交给Manager
#import "Pingpp.h"

@implementation DDService

#pragma mark - Profile
+ (void)editAsk :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param url:URL_UKEditAsk block:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }    }];

}

+ (void)updateProfile :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param url:URL_PFUpdateProfile block:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }    }];
}
+ (void)signProceeding :(NSDictionary*)param withBlock:(void (^)(NSString*imageUrl))block {
    [[self class]GET:param url:URL_PFSignProceeding block:^(id responseObject) {
            NSString* url = [[responseObject objectForKey:@"data"]objectForKey:@"url"];
            if (block) { block(url); }
    }];
}

+ (void)getPushSetting:(void (^)(NSDictionary *data))block {
    [[self class]GET:nil url:URL_PFGetPushSetting block:^(id responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            if (block) {block(data);}
    }];
}

+ (void)getPhotos:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetPhotos block:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)getAsk:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetAsk block:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)getReply:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetReply block:^(id responseObject) {
        NSArray* dataArray = [responseObject objectForKey:@"data"];
        if (block) { block(dataArray); }
    }];
}
+ (void)getToHelp:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetToHelp block:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)getDone:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetDone block:^(id responseObject) {
        NSArray* dataArray = [responseObject objectForKey:@"data"];
        if (block) { block(dataArray); }
    }];
}

+ (void)getFollowPages:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetFollowPages block:^(id responseObject) {
        NSArray* dataArray = [responseObject objectForKey:@"data"];
        if (block) { block(dataArray); }
    }];
}
+ (void)getHotPages:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetHotPages block:^(id responseObject) {
        NSArray* dataArray = [responseObject objectForKey:@"data"];
        if (block) { block(dataArray); }
    }];
}

+ (void)getCommentedPages:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetCommentedPages block:^(id responseObject) {
        NSArray* dataArray = [responseObject objectForKey:@"data"];
        if (block) { block(dataArray); }
    }];
}
+ (void)getLikedPages:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetLikedPages block:^(id responseObject) {
        NSArray* dataArray = [responseObject objectForKey:@"data"];
        if (block) { block(dataArray); }
    }];
}

+ (void)setPushSetting:(NSDictionary *)param withBlock:(void (^) (BOOL success))block {
    [[self class]POST:param url:URL_PFsetPushSetting block:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }
    }];
}
+ (void) follow :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    BOOL status = [[param objectForKey:@"status"]boolValue];
    [[self class]POST:param url:URL_PFFollow block:^(id responseObject) {
        if (responseObject) {
            if (block) { block(YES); }
            if (status) {
                [Hud text:@"成功关注"];
                [DDUserManager currentUser].attentionNumber++;
            } else {
                [Hud text:@"取消关注成功"];
                [DDUserManager currentUser].attentionNumber--;
            }
        } else {
            if (block) { block(NO); }
        }
    }];
}
+ (void) deleteProceeding :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param url:URL_PFDeleteProceeding block:^(id responseObject) {
        if (responseObject) {
            if (block) {
                block(YES);
            }
        } else {
            if (block) {block(NO);}
        }
    }];
}
+ (void) updatePassword :(NSDictionary*)param withBlock:(void (^)(BOOL success,NSInteger ret))block {
    [[self class]POST:param url:URL_PFUpdatePasswordURL block:^(id responseObject) {
        if (responseObject) {
            NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
            if (block) {block(YES,ret);}
        } else {
            if (block) {block(NO,-1);}
        }
    }];
}

#pragma mark - Account

+ (void) updateToken :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param url:URL_ACUpdateToken block:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }
    }];
}

+ (void) resetPassword :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param url:URL_ACResetPassword block:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }
    }];
}

+ (void)getAuthCode:(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]GET:param url:URL_ACRequestAuthCode block:^(id responseObject) {
        if (responseObject) {
            if (block ) { block(YES); }
        } else {
            if (block ) { block(NO); }
        }
    }];
}

//+ (void) ddLogin :(NSDictionary*)param withBlock:(void (^)(NSDictionary* data , NSInteger status))block {
//    [[self class]POST:param url:URL_ACLogin block:^(id responseObject) {
//            NSDictionary* data = [responseObject objectForKey:@"data"];
//            NSInteger status = [(NSString*)[data objectForKey:@"status"]integerValue];
//            if (block) { block(data,status); }
//    }];
//}

//+ (void) ddRegister :(NSDictionary*)param withBlock:(void (^)(NSDictionary* data))block {
//    [[self class]POST:param url:URL_ACRegister block:^(id responseObject) {
//            NSDictionary *data = [ responseObject objectForKey:@"data"];
//                if (block) { block(data); }
//    }];
//}
//+ (void) dd3PartyAuth :(NSDictionary*)param with3PaType:(NSString *)type withBlock:(void (^)(BOOL isRegistered,NSDictionary*userObject))block {
//    NSString* url = [NSString stringWithFormat:@"%@%@",URL_AC3PaAuth,type];
//    [[self class]POST:param url:url block:^(id responseObject) {
//            NSDictionary *data = [ responseObject objectForKey:@"data"];
//            NSInteger isRegistered = [[data objectForKey:@"is_register"] integerValue];
//            NSDictionary* userObject = [data objectForKey:@"user_obj"];
//            if (block) { block(isRegistered,userObject); }
//    }];
//}

//+ (void) dd3PartyAuth :(NSDictionary*)param with3PaType:(NSString *)type withBlock:(void (^)(id responseObject))block {
//    NSString* url = [NSString stringWithFormat:@"%@%@",URL_AC3PaAuth,type];
//    [[self class]POST:param url:url block:^(id responseObject) {
//        if (block) { block(responseObject); }
//    }];
//}

//+ (void) checkPhoneRegistration:(NSDictionary*)param withBlock:(void (^)(NSNumber* isRegistered))block {
//    [[self class]GET:param url:URL_ACHasRegistered block:^(id responseObject) {
//        if (responseObject) {
//            NSDictionary *data = [ responseObject objectForKey:@"data"];
//            NSNumber* isRegistered = [data objectForKey:@"is_register"];
//            if (block) {
//                block(isRegistered);
//            }
//        }
//    }];
//}

+ (void)checkPhoneRegistration:(NSDictionary*)param withBlock:(void (^)(BOOL isRegistered))block {
    [[self class]GET:param url:URL_ACHasRegistered block:^(id responseObject) {
            NSDictionary *data = [ responseObject objectForKey:@"data"];
            BOOL isRegistered = [[data objectForKey:@"has_registered"]boolValue];
            if (block) {
                block(isRegistered);
            }
    }];
}

#pragma mark - Unknown

+ (void) postFeedBack :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param url:URL_UKSaveFeedback block:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }
    }];
}

+ (void)  ddSaveAsk :(NSDictionary*)param withBlock:(void (^)(NSInteger newImageID))block {
    [[self class]POST:param url:URL_UKSaveAsk block:^(id responseObject) {
        if (responseObject) {
            NSInteger newImageID = [[[ responseObject objectForKey:@"data"]objectForKey:@"ask_id"] integerValue];
            if (block) {block(newImageID);}
        } else {
            if (block) {block(-1);}
        }
    }];
}
+ (void)  ddSaveReply :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param url:URL_UKSaveReply block:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }
    }];
}
+ (void)ddGetMyInfo:(NSDictionary*)param withBlock:(void (^)(NSDictionary* data))block {
    [[self class]GET:param url:URL_PFGetUserInfo block:^(id responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
    }];
}
+ (void)ddGetMsg:(NSDictionary*)param withBlock:(void (^)(id data))block {
    [[self class]GET:param url:URL_UKGetMsg block:^(id responseObject) {
            id data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
    }];
}

+ (void)ddGetSearchContentResult:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]POST:param url:URL_UKGetContentSearch block:^(id responseObject) {
        id data = [responseObject objectForKey:@"data"];
        if (block) { block(data); }
    }];
}
+ (void)ddGetSearchUserResult:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]POST:param url:URL_UKGetUserSearch block:^(id responseObject) {
        id data = [responseObject objectForKey:@"data"];
        if (block) { block(data); }
    }];
}
+ (void)ddGetNotifications:(NSDictionary*)param withBlock:(void (^)(id data))block {
    [[self class]GET:param url:URL_NotiGetNotifications block:^(id responseObject) {
            id data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
    }];
}

+ (void)ddGetOtherUserInfo:(NSDictionary*)param withBlock:(void (^)(NSDictionary* data,NSArray *askArray,NSArray *replyArray))block {
    [[self class]GET:param url:URL_PFGetUserInfo block:^(id responseObject) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSArray *askArray = [data objectForKey:@"asks"];
            NSArray *replyArray = [data objectForKey:@"replies"];
            if (block) { block(data,askArray,replyArray); }
    }];
}


+ (void)ddGetReply:(NSDictionary*)param withBlock:(void (^)(NSArray *returnArray))block {
    [[self class]GET:param url:URL_PFGetReply block:^(id responseObject) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
    }];
}
+ (void)ddGetAskWithReplies:(NSDictionary*)param withBlock:(void (^)(NSArray *returnArray))block {
    [[self class]GET:param url:URL_PFGetFriendAsk block:^(id responseObject) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
    }];
}
+ (void)getShareInfo:(NSDictionary*)param withBlock:(void (^)(NSDictionary *))block {
    [[self class]GET:param url:URL_UKGetShare block:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        if (block) { block(data);}
    }];
}
+ (void)ddGetCollection:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetCollection block:^(id responseObject) {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
    }];
}
+ (void)ddGetFans:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetFans block:^(id responseObject) {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
    }];
}

+ (void)ddGetFollow:(NSDictionary*)param withBlock:(void (^)(NSArray* recommendArray,NSArray* myFollowArray))block {
    [[self class]GET:param url:URL_PFGetFollow block:^(id responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSArray *recommendArray = [data objectForKey:@"recommends"];
            NSArray *myFollowArray = [data objectForKey:@"fellows"];

            if (block) { block(recommendArray,myFollowArray); }
    }];
}
+ (void)ddGetNewestAsk:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_NewestGetAsk block:^(id responseObject) {
        if (responseObject) {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        } else {
            if (block) { block(nil); }
        }
    }];
}

+ (void)ddGetNewestReply:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_NewestGetReply block:^(id responseObject) {
        if (responseObject) {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        } else {
            if (block) { block(nil); }
        }
    }];
}

+ (void)toggleLike:(BOOL)like ID:(NSInteger)ID type:(PIEPageType)type  withBlock:(void (^)(BOOL success))block {
    NSString* url;
    if (type == PIEPageTypeAsk) {
        url = [NSString stringWithFormat:@"ask/upask/%zd",ID];
    } else if (type == PIEPageTypeReply) {
        url = [NSString stringWithFormat:@"reply/upreply/%zd",ID];
    }
    NSInteger status = like?1:0;
    NSDictionary *param = [NSDictionary dictionaryWithObject:@(status) forKey:@"status"];
    [DDBaseService GET:param url:url block:^(id responseObject) {
        if (responseObject) {
            block(YES);
        } else {
            block(NO);
        }
    }];
}

+ (void)sd_downloadImage:(NSString*)url withBlock:(void (^)(UIImage* image))block {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (block && !error) {
            block(image);
        } else {
            block(nil);
        }
    }];
}
+ (void)loveReply:(NSMutableDictionary*)param ID:(NSInteger)ID  withBlock:(void (^)(BOOL succeed))block {
    NSString* url = [NSString stringWithFormat:@"reply/loveReply/%zd",ID];
 
    [DDBaseService GET:param url:url block:^(id responseObject) {
        if (responseObject) {
            block(YES);
        } else {
            block(NO);
        }
    }];}

+ (void)charge:(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    
    [DDBaseService POST:param url:@"money/charge" block:^(id responseObject) {
        NSDictionary *dictionaryData = [responseObject objectForKey:@"data"];
        if (dictionaryData == nil) {
            if (block) {
                block(NO);
            }
            return ;
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryData options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

        
        [Pingpp createPayment:jsonString appURLScheme:@"2088122565280825" withCompletion:^(NSString *result, PingppError *error) {
            if ([result isEqualToString:@"success"]) {
                // 支付成功
                if (block) {
                    block(YES);
                }
                [Hud text:@"支付成功"];
                
            } else {
                // 支付失败或取消
                if (block) {
                    block(NO);
                }
                [Hud text:@"支付失败或取消"];
            }
        }];
    }];
    
}

+ (void)withdraw:(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    
    [DDBaseService POST:param url:@"money/transfer" block:^(id responseObject) {
//        NSDictionary *dictionaryData = [responseObject objectForKey:@"data"];
//        if (dictionaryData == nil) {
//            if (block) {
//                block(NO);
//            }
//            return ;
//        }
        if (responseObject) {
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryData options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        

//        [Pingpp createPayment:jsonString appURLScheme:@"2088122565280825" withCompletion:^(NSString *result, PingppError *error) {
//            if ([result isEqualToString:@"success"]) {
//                if (block) {
//                    block(YES);
//                }
//                [Hud text:@"提现成功"];
//                
//            } else {
//                // 支付失败或取消
//                if (block) {
//                    block(NO);
//                }
//                [Hud text:@"提现失败或取消"];
//            }
//        }];
    }];
    
}
@end
