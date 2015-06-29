//
//  ATOMGetMoblieCode.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMGetMoblieCode.h"
#import "ATOMHTTPRequestOperationManager.h"

@implementation ATOMGetMoblieCode

- (NSURLSessionDataTask *)GetMobileCode:(NSDictionary *)param withBlock:(void (^)(NSString *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/get_mobile_code" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [responseObject[@"ret"] integerValue];
        NSString *verifyCode = responseObject[@"data"][@"code"];
        NSLog(@"GetMobileCode param %@,response data %@",param,responseObject);
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
