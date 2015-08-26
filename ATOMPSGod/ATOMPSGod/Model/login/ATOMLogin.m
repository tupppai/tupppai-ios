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
    [Hud activity:@""];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:[NSString stringWithFormat:@"auth/%@",type] parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [Hud dismiss];
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            NSInteger isRegistered = [[ responseObject objectForKey:@"data"][@"is_register"] integerValue];
            if (isRegistered == 1) {
                ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:[ responseObject objectForKey:@"data"][@"user_obj"] error:NULL];
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
        [Hud dismiss];
        if (block) {
            block(nil,nil,error);
        }
    }];
}

- (NSURLSessionDataTask* )Login:(NSDictionary*)param withBlock:(void (^)(BOOL succeed))block{
    [Hud activity:@""];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:@"account/login" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [Hud dismiss];

        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"]integerValue];
        if (ret == 1) {
            if ([ responseObject objectForKey:@"data"]) {
                //        data: { status: 1,正常  2，密码错误 3，未注册 }
                NSInteger status = [(NSString*)[ responseObject objectForKey:@"data"][@"status"] integerValue];
                if(status == 1) {
                    [Hud success:@"登录成功"];
                    NSError* error;
                    ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:[ responseObject objectForKey:@"data"] error:&error];
                    if (error) {
                        [Util ShowTSMessageError:@"登录失败"];
                    }
                    //保存更新数据库的user,并更新currentUser
                    [[ATOMCurrentUser currentUser]saveAndUpdateUser:user];
                    if (block) {
                        block(YES);
                    }
                } else if (status == 2) {
                    [Util ShowTSMessageError:@"密码错误"];
                    if (block) {
                        block(NO);
                    }
                } else if (status == 3) {
                    [Util ShowTSMessageWarn:@"此手机号无注册"];
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
        [Hud dismiss];
        if (block) {
            block(NO);
        }
    }];
}










@end
