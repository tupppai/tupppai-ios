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
+ (void)signProceeding :(NSDictionary*)param withBlock:(void (^)(NSString*imageUrl))block {
    [[self class]GET:param withUrl:URL_PFSignProceeding withBlock:^(id responseObject) {
            NSString* url = [[responseObject objectForKey:@"data"]objectForKey:@"url"];
            if (block) { block(url); }
    }];
}

+ (void)getPushSetting:(void (^)(NSDictionary *data))block {
    [[self class]GET:nil withUrl:URL_PFGetPushSetting withBlock:^(id responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            if (block) {block(data);}
    }];
}

+ (void)getMyReply:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param withUrl:URL_PFGetMyReply withBlock:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)getMyAsk:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param withUrl:URL_PFGetMyAsk withBlock:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)getMyProceeding:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param withUrl:URL_PFGetMyProceeding withBlock:^(id responseObject) {
            NSArray* dataArray = [responseObject objectForKey:@"data"];
            if (block) { block(dataArray); }
    }];
}
+ (void)setPushSetting:(NSDictionary *)param withBlock:(void (^) (BOOL success))block {
    
    [[self class]POST:param withUrl:URL_PFsetPushSetting withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }
    }];
}
+ (void) follow :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param withUrl:URL_PFFollow withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) { block(YES); }
        } else {
            if (block) { block(NO); }
        }
    }];
}
+ (void) deleteProceeding :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param withUrl:URL_PFDeleteProceeding withBlock:^(id responseObject) {
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
    [[self class]POST2:param withUrl:URL_PFUpdatePasswordURL withBlock:^(id responseObject) {
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
    [[self class]POST:param withUrl:URL_ACUpdateToken withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }
    }];
}

+ (void) resetPassword :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param withUrl:URL_ACResetPassword withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } else {
            if (block) {block(NO);}
        }
    }];
}

+ (void)getAuthCode:(NSDictionary*)param withBlock:(void (^)(NSString *authcode))block {
    [[self class]GET:param withUrl:URL_ACRequestAuthCode withBlock:^(id responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* authcode = [data objectForKey:@"code"];
            if (block && authcode) { block(authcode); }
    }];
}

+ (void) ddLogin :(NSDictionary*)param withBlock:(void (^)(NSDictionary* data , NSInteger status))block {
    [[self class]POST:param withUrl:URL_ACLogin withBlock:^(id responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSInteger status = [(NSString*)[data objectForKey:@"status"]integerValue];
            if (block) { block(data,status); }
    }];
}

+ (void) ddRegister :(NSDictionary*)param withBlock:(void (^)(NSDictionary* data))block {
    [[self class]POST:param withUrl:URL_ACRegister withBlock:^(id responseObject) {
        if (responseObject) {
            NSDictionary *data = [ responseObject objectForKey:@"data"];
                if (block) { block(data); }
        }
    }];
}
+ (void) dd3PartyAuth :(NSDictionary*)param with3PaType:(NSString *)type withBlock:(void (^)(BOOL isRegistered,NSDictionary*userObject))block {
    NSString* url = [NSString stringWithFormat:@"%@%@",URL_AC3PaAuth,type];
    [[self class]POST:param withUrl:url withBlock:^(id responseObject) {
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
    [[self class]POST:param withUrl:URL_UKSave withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {block(YES);}
        } 
    }];
}

+ (void)ddGetMyInfo:(NSDictionary*)param withBlock:(void (^)(NSDictionary* data))block {
    [[self class]GET:param withUrl:URL_UKGetMyInfo withBlock:^(id responseObject) {
        if (responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        } 
    }];
}
+ (void)ddGetMsg:(NSDictionary*)param withBlock:(void (^)(id data))block {
    [[self class]GET:param withUrl:URL_UKGetMsg withBlock:^(id responseObject) {
        if (responseObject) {
            id data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        }
    }];
}

+ (void)ddGetOtherUserInfo:(NSDictionary*)param withBlock:(void (^)(NSDictionary* data,NSArray *askArray,NSArray *replyArray))block {
    [[self class]GET:param withUrl:URL_PFGetOtherUserInfo withBlock:^(id responseObject) {
        if (responseObject) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSArray *askArray = [data objectForKey:@"asks"];
            NSArray *replyArray = [data objectForKey:@"replies"];
            if (block) { block(data,askArray,replyArray); }
        }
    }];
}

+ (void)ddGetMyCollection:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param withUrl:URL_PFGetMyCollection withBlock:^(id responseObject) {
        if (responseObject) {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        }
    }];
}
+ (void)ddGetMyFans:(NSDictionary*)param withBlock:(void (^)(NSArray* data))block {
    [[self class]GET:param withUrl:URL_PFGetMyFans withBlock:^(id responseObject) {
        if (responseObject) {
            NSArray* data = [responseObject objectForKey:@"data"];
            if (block) { block(data); }
        }
    }];
}
+ (void)ddGetMyFollow:(NSDictionary*)param withBlock:(void (^)(NSArray* recommendArray,NSArray* myFollowArray))block {
    [[self class]GET:param withUrl:URL_PFGetMyFollow withBlock:^(id responseObject) {
        if (responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSArray *recommendArray = [data objectForKey:@"recommends"];
            NSArray *myFollowArray = [data objectForKey:@"fellows"];

            if (block) { block(recommendArray,myFollowArray); }
        }
    }];
}
@end
