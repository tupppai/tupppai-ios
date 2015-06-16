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

@property (nonatomic, strong) ATOMUserDAO *userDAO;

@end

@implementation ATOMLogin

- (ATOMUserDAO *)userDAO {
    if (!_userDAO) {
        _userDAO = [ATOMUserDAO new];
    }
    return _userDAO;
}

- (AFHTTPRequestOperation *)openIDAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegister,NSDictionary* userObejctFromServer, NSError *))block {
    NSLog(@"判断第三平台获取的openid是否已经注册");
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:[NSString stringWithFormat:@"auth/%@",type] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"thirdPartyLogin param %@",param);
        NSLog(@"responseObject %@",responseObject);
        NSInteger isRegistered = [responseObject[@"data"][@"is_register"] integerValue];
        NSLog(@"isRegistered %ld",isRegistered);

        if (isRegistered == 1) {
            NSLog(@"已经注册，用户信息user_obj%@",responseObject[@"user_obj"]);
            block(YES,responseObject[@"user_obj"],nil);
        } else {
            NSLog(@"未注册，调到注册页面。");

            if (block) {
                block(NO,nil,nil);
            }
        }
        //        [[ATOMCurrentUser currentUser] setCurrentUser:user];
//        if (block) {
//            block(user, nil);
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"openIDAuth 服务器出错");
        [SVProgressHUD showWithStatus:@"出现未知错误" maskType:SVProgressHUDMaskTypeNone];
        if (block) {
            block(nil,nil,error);
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)saveUserInDB:(ATOMUser *)user {
    [self.userDAO insertUser:user];
}

- (ATOMUser *)getUserBy:(NSString *)uid {
    return [self.userDAO selectUserByUID:uid];
}

- (BOOL)isExistUser:(ATOMUser *)user {
    return [self.userDAO isExistUser:user];
}




- (void)thirdPartyAuth:(ShareType)type withBlock:(void (^)(NSDictionary* sourceData))block{
    NSLog(@"thirdPartyAuth");
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"result %d, userInfo %@,error %@",result,userInfo,error);
        NSLog(@"user info%@ userUid %@ ,name %@,image %@",[userInfo description],[userInfo uid],[userInfo nickname],[userInfo profileImage]);
        if (result) {
            //            NSString* uid = [userInfo uid];
            NSDictionary* sourceData = [userInfo sourceData];
            NSLog(@"sourceData %@",sourceData);
            block(sourceData);
        } else {
            block(nil);
        }
    }];
}
















@end
