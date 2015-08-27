//
//  ATOMGetMoblieCode.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMGetMoblieCode.h"
#import "DDSessionManager.h"

@implementation ATOMGetMoblieCode

- (void)GetMobileCode:(NSDictionary *)param withBlock:(void (^)(NSString *, NSError *))block {
     [[DDSessionManager shareHTTPSessionManager] GET:@"account/requestAuthCode" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [[ responseObject objectForKey:@"ret"] integerValue];
        NSString *verifyCode = [ responseObject objectForKey:@"data"][@"code"];
        if (block) {
            if (ret == 1) {
                block(verifyCode, nil);
            } else {
                block(@"peiweiSoHandsome", nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(@"peiweiSoHandsome", error);
    }];
}

@end
