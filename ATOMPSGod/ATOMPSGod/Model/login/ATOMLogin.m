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

- (AFHTTPRequestOperation *)Login:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(ATOMUser *user, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] POST:[NSString stringWithFormat:@"user/login?type=%@",type] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ATOMUser *user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:responseObject error:NULL];
        user.mobile = param[@"phone"];
        [[ATOMCurrentUser currentUser] setCurrentUser:user];
        if (block) {
            block(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
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





















@end
