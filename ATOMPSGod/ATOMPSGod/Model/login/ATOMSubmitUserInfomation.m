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

- (AFHTTPRequestOperation *)SubmitUserInformation:(NSDictionary *)param withBlock:(void (^)(NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"user/save" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"SubmitUserInformation param%@",param);
        NSLog(@"SubmitUserInformation responseObject %@ ,\n info %@",responseObject,responseObject[@"info"]);
        if (responseObject[@"data"]) {
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:responseObject[@"data"] error:NULL];
            [[ATOMCurrentUser currentUser]saveAndUpdateUser:user];
        } else {
            NSLog(@"返回的数据为空");
        }
        if (block) {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        if (block) {
            block(error);
        }
    }];
}


























@end
