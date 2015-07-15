//
//  ATOMLogin.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLogin.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMUser.h"
#import "ATOMUserDAO.h"
#import "ATOMUserProfileViewModel.h"

@interface ATOMLogin ()

//@property (nonatomic, strong) ATOMUserDAO *userDAO;

@end

@implementation ATOMLogin

- (NSURLSessionDataTask *)openIDAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegister,NSString* info, NSError *error))block {
    NSLog(@"判断第三平台获取的openid是否已经注册");
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:[NSString stringWithFormat:@"auth/%@",type] parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"openIDAuth param %@",param);
        NSLog(@"openIDAuth responseObject%@",responseObject);
        NSString* info = (NSString*)responseObject[@"info"];
        NSLog(@"openIDAuth info %@",info);
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret == 1) {
            NSInteger isRegistered = [responseObject[@"data"][@"is_register"] integerValue];
            if (isRegistered == 1) {
                ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:responseObject[@"data"][@"user_obj"] error:NULL];
                //保存更新数据库的user,并更新currentUser
                [[ATOMCurrentUser currentUser]saveAndUpdateUser:user];
                block(YES,@"登录成功",nil);
            } else {
                if (block) {
                    block(NO,@"未注册，跳到注册页面",nil);
                }
            }
        } else {
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        
        if (block) {
            block(nil,nil,error);
        }
    }];
}

- (NSURLSessionDataTask* )Login:(NSDictionary*)param withBlock:(void (^)(BOOL succeed))block{
    [[KShareManager mascotAnimator] show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:@"user/login" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator] dismiss];
        NSInteger ret = [(NSString*)responseObject[@"ret"]integerValue];
        NSString* info = responseObject[@"info"];
        NSLog(@"Login param %@",param);
        NSLog(@"Login responseObject %@ \n info %@",responseObject,info);
        if (ret == 1) {
            if (responseObject[@"data"]) {
                //        data: { status: 1,正常  2，密码错误 3，未注册 }
                NSInteger status = [(NSString*)responseObject[@"data"][@"status"] integerValue];
                if(status == 1) {
                    [Util TextHud:@"登录成功"];
                    NSError* error;
                    ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:responseObject[@"data"] error:&error];
                    if (error) {
                        NSLog(@"Login error %@",error);
                    }
                    NSLog(@"user %@ %d",user.nickname,user.uid);
                    //保存更新数据库的user,并更新currentUser
                    [[ATOMCurrentUser currentUser]saveAndUpdateUser:user];
                    if (block) {
                        block(YES);
                    }
                } else if (status == 2) {
                    [Util TextHud:@"密码错误"];
                    if (block) {
                        block(NO);
                    }
                } else if (status == 3) {
                    [Util TextHud:@"此手机号未注册"];
                    if (block) {
                        block(NO);
                    }
                }
            }
        } else {
            
            if (block) {
                block(NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[KShareManager mascotAnimator] dismiss];
        
        if (block) {
            block(NO);
        }
    }];
}










@end
