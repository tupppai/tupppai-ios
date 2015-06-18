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

//- (ATOMUserDAO *)userDAO {
//    if (!_userDAO) {
//        _userDAO = [ATOMUserDAO new];
//    }
//    return _userDAO;
//}

- (AFHTTPRequestOperation *)openIDAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegister,NSString* info, NSError *error))block {
    NSLog(@"判断第三平台获取的openid是否已经注册");
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:[NSString stringWithFormat:@"auth/%@",type] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"thirdPartyLogin param %@",param);
//        NSLog(@"responseObject %@",responseObject);
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"openIDAuth 服务器出错");
        if (block) {
            block(nil,nil,error);
        }
    }];
}


//shareSDK 获取 用户手机的第三方平台的信息
- (void)thirdPartyAuth:(ShareType)type withBlock:(void (^)(NSDictionary* sourceData))block{
    NSLog(@"thirdPartyAuth");
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"result %d, userInfo %@,error %@",result,userInfo,error);
        NSLog(@"user info%@ userUid %@ ,name %@,image %@",[userInfo description],[userInfo uid],[userInfo nickname],[userInfo profileImage]);
        if (result) {
            NSDictionary* sourceData = [userInfo sourceData];
            block(sourceData);
        } else {
            block(nil);
        }
    }];
}


- (AFHTTPRequestOperation* )Login:(NSDictionary*)param withBlock:(void (^)(NSDictionary* sourceData))block{
    NSLog(@"Login param %@",param);
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:@"user/login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"Login responseObject %@",responseObject);
        NSInteger ret = [(NSString*)responseObject[@"ret"]integerValue];
        NSString* info = responseObject[@"info"];
        NSLog(@"%@",info);
        if (responseObject[@"data"]) {
            //        data: { status: 1,正常  2，密码错误 3，未注册 }
            NSInteger status = (NSInteger)responseObject[@"data"][@"status"];
            if(status == 1) {
                NSLog(@"登录成功");
            } else if (status == 2) {
                NSLog(@"密码错误");
            } else if (status == 3) {
                NSLog(@"未注册 ");
            }
        }
        if (ret == 1) {
            NSLog(@"登录成功");
        } else {
            NSLog(@"出现未知错误");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"出现未知错误");
    }];
}










@end
