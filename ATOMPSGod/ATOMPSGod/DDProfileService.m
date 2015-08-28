//
//  DDProfileService.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/28/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDProfileService.h"
@implementation DDProfileService

#pragma mark - Profile
+ (void)signProceeding :(NSDictionary*)param withBlock:(void (^)(NSString*imageUrl))block {
    [[self class]GET:param withUrl:URL_PFSignProceeding withBlock:^(id responseObject) {
        if (responseObject) {
            NSString* url = [[responseObject objectForKey:@"data"]objectForKey:@"url"];
            if (block) {
                block(url);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    }];
}

+ (void)getPushSetting:(void (^)(NSDictionary *data))block {
    [[self class]GET:nil withUrl:URL_PFGetPushSetting withBlock:^(id responseObject) {
        if (responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            if (block) {
                block(data);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    }];
}


+ (void)setPushSetting:(NSDictionary *)param withBlock:(void (^) (BOOL success))block {
    
    [[self class]POST:param withUrl:URL_PFsetPushSetting withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
    }];
}
+ (void) follow :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param withUrl:URL_PFFollow withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
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
            if (block) {
                block(NO);
            }
        }
    }];
}
+ (void) updatePassword :(NSDictionary*)param withBlock:(void (^)(BOOL success,NSInteger ret))block {
    [[self class]POST2:param withUrl:URL_PFUpdatePasswordURL withBlock:^(id responseObject) {
        if (responseObject) {
            NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
            if (block) {
                block(YES,ret);
            }
        } else {
            if (block) {
                block(NO,-1);
            }
        }
    }];
}

#pragma mark - Account

+ (void) updateToken :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param withUrl:URL_ACUpdateToken withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
    }];
}

+ (void) resetPassword :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param withUrl:URL_ACResetPassword withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
    }];
}

+ (void)getAuthCode:(NSDictionary*)param withBlock:(void (^)(NSString *authcode))block {
    [[self class]GET:nil withUrl:URL_ACRequestAuthCode withBlock:^(id responseObject) {
        if (responseObject) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSString* authcode = [data objectForKey:@"code"];
            if (block && authcode) {
                block(authcode);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    }];
}

#pragma mark - Unknown

+ (void) postFeedBack :(NSDictionary*)param withBlock:(void (^)(BOOL success))block {
    [[self class]POST:param withUrl:URL_UKSave withBlock:^(id responseObject) {
        if (responseObject) {
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
    }];
}

@end
