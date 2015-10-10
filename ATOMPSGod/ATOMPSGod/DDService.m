//
//  DDProfileService.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/28/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDService.h"
//负责处理key，返回要的json，不做任何数据库操作，mantle操作，这些操作交给Manager
@implementation DDService

#pragma mark - Profile

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

+ (void)getMyPhotos:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetMyPhotos block:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)getMyAsk:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetMyAsk block:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)getMyToHelp:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetMyToHelp block:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)getMyDone:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetMyDone block:^(id responseObject) {
        NSArray* dataArray = [responseObject objectForKey:@"data"];
        if (block) { block(dataArray); }
    }];
}

+ (void)getMyFollowPages:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetMyFollowPages block:^(id responseObject) {
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
    [[self class]POST:param url:URL_PFFollow block:^(id responseObject) {
        if (responseObject) {
            if (block) { block(YES); }
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

+ (void)getAuthCode:(NSDictionary*)param withBlock:(void (^)(NSString *authcode))block {
    [[self class]GET:param url:URL_ACRequestAuthCode block:^(id responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* authcode = [data objectForKey:@"code"];
            if (block && authcode) { block(authcode); }
    }];
}

+ (void) ddLogin :(NSDictionary*)param withBlock:(void (^)(NSDictionary* data , NSInteger status))block {
    [[self class]POST:param url:URL_ACLogin block:^(id responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSInteger status = [(NSString*)[data objectForKey:@"status"]integerValue];
            if (block) { block(data,status); }
    }];
}

+ (void) ddRegister :(NSDictionary*)param withBlock:(void (^)(NSDictionary* data))block {
    [[self class]POST:param url:URL_ACRegister block:^(id responseObject) {
        if (responseObject) {
            NSDictionary *data = [ responseObject objectForKey:@"data"];
                if (block) { block(data); }
        }
    }];
}
+ (void) dd3PartyAuth :(NSDictionary*)param with3PaType:(NSString *)type withBlock:(void (^)(BOOL isRegistered,NSDictionary*userObject))block {
    NSString* url = [NSString stringWithFormat:@"%@%@",URL_AC3PaAuth,type];
    [[self class]POST:param url:url block:^(id responseObject) {
        if (responseObject) {
            NSDictionary *data = [ responseObject objectForKey:@"data"];
            NSInteger isRegistered = [[data objectForKey:@"is_register"] integerValue];
            NSDictionary* userObject = [data objectForKey:@"user_obj"];
            if (block) { block(isRegistered,userObject); }
        }
    }];
}



#pragma mark - Unknown

+ (void) postFeedBack :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param url:URL_UKSaveFeedback block:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
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
    [[self class]GET:param url:URL_UKGetMyInfo block:^(id responseObject) {
        if (responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        } 
    }];
}
+ (void)ddGetMsg:(NSDictionary*)param withBlock:(void (^)(id data))block {
    [[self class]GET:param url:URL_UKGetMsg block:^(id responseObject) {
        if (responseObject) {
            id data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        }
    }];
}

+ (void)ddGetOtherUserInfo:(NSDictionary*)param withBlock:(void (^)(NSDictionary* data,NSArray *askArray,NSArray *replyArray))block {
    [[self class]GET:param url:URL_PFGetOtherUserInfo block:^(id responseObject) {
        if (responseObject) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSArray *askArray = [data objectForKey:@"asks"];
            NSArray *replyArray = [data objectForKey:@"replies"];
            if (block) { block(data,askArray,replyArray); }
        }
    }];
}


+ (void)ddGetFriendReply:(NSDictionary*)param withBlock:(void (^)(NSArray *returnArray))block {
    [[self class]GET:param url:URL_PFGetFriendReply block:^(id responseObject) {
        if (responseObject) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        }
    }];
}
+ (void)ddGetFriendAsk:(NSDictionary*)param withBlock:(void (^)(NSArray *returnArray))block {
    [[self class]GET:param url:URL_PFGetFriendAsk block:^(id responseObject) {
        if (responseObject) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        }
    }];
}

+ (void)ddGetMyCollection:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetMyCollection block:^(id responseObject) {
        if (responseObject) {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        }
    }];
}
+ (void)ddGetFans:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param url:URL_PFGetFans block:^(id responseObject) {
        if (responseObject) {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        }
    }];
}

+ (void)ddGetFollow:(NSDictionary*)param withBlock:(void (^)(NSArray* recommendArray,NSArray* myFollowArray))block {
    [[self class]GET:param url:URL_PFGetFollow block:^(id responseObject) {
        if (responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSArray *recommendArray = [data objectForKey:@"recommends"];
            NSArray *myFollowArray = [data objectForKey:@"fellows"];

            if (block) { block(recommendArray,myFollowArray); }
        }
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
    NSLog(@"toggleLike");
    NSString* url;
    if (type == PIEPageTypeAsk) {
        url = [NSString stringWithFormat:@"ask/upask/%ld",(long)ID];
    } else if (type == PIEPageTypeReply) {
        url = [NSString stringWithFormat:@"reply/upreply/%ld",(long)ID];
    }
    NSInteger status = like?1:0;
    NSDictionary *param = [NSDictionary dictionaryWithObject:@(status) forKey:@"status"];
    NSLog(@"%@ url %@",param,url);
    [DDBaseService GET:param url:url block:^(id responseObject) {
        if (responseObject) {
            block(YES);
        } else {
            block(NO);
        }
    }];
}

+ (void)downloadImage:(NSString*)url withBlock:(void (^)(UIImage* image))block {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:filePath]];
        if (image) {
            block(image);
        } else {
            block(nil);
        }
    }];
    [downloadTask resume];
}



@end
