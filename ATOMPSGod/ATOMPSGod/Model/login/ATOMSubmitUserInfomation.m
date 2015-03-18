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

- (AFHTTPRequestOperation *)SubmitUserInformation:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:[NSString stringWithFormat:@"user/save?type=%@",type] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ATOMCurrentUser currentUser].uid = responseObject[@"data"][@"uid"];
        ATOMUser *user = [ATOMUser new];
        user.uid = [ATOMCurrentUser currentUser].uid;
        user.nickname = [ATOMCurrentUser currentUser].nickname;
        user.mobile = [ATOMCurrentUser currentUser].mobile;
        user.sex = [ATOMCurrentUser currentUser].sex;
        user.avatar = [ATOMCurrentUser currentUser].avatar;
        user.locationID = [ATOMCurrentUser currentUser].locationID;
        if (block) {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}


























@end
