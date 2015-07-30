//
//  ATOMSubmitUserInfomation.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMSubmitUserInfomation.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMUser.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@implementation ATOMSubmitUserInformation

- (NSURLSessionDataTask *)SubmitUserInformation:(NSDictionary *)param withBlock:(void (^)(NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:@"user/save" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"SubmitUserInformation param%@",param);
        NSLog(@"SubmitUserInformation responseObject %@ ,\n info %@",responseObject,[ responseObject objectForKey:@"info"]);
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            if ([ responseObject objectForKey:@"data"]) {
                ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:[ responseObject objectForKey:@"data"] error:NULL];
                [[ATOMCurrentUser currentUser]saveAndUpdateUser:user];
                if (block) {
                    block(nil);
                }
            } else {
                NSError* error = [NSError new];
                if (block) {
                    block(error);
                }
                NSLog(@"返回的数据为空");
            }
            if (block) {
                block(nil);
            }
        } else if (ret == 0) {
            NSError* error = [NSError new];
            if (block) {
                block(error);
            }
            
        } else {
            NSError* error = [NSError new];
            if (block) {
                block(error);
            }
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        if (block) {
            block(error);
        }
    }];
}


























@end
