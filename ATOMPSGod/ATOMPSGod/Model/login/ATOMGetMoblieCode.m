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

- (AFHTTPRequestOperation *)GetMobileCode:(NSDictionary *)param withBlock:(void (^)(NSString *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"user/get_mobile_code" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString *verifyCode = responseObject[@"data"];
        if (block) {
            if (status == 0) {
                block(verifyCode, nil);
            } else {
                block(@"AlreadyRegister", nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
