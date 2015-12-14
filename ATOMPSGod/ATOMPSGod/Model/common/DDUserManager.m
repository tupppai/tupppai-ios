//
//  ATOMCurrentUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDUserManager.h"
#import "ATOMUserDao.h"
@implementation DDUserManager

static dispatch_once_t onceToken;
static  PIEEntityUser* _currentUser;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _region = [NSMutableDictionary new];
        _bindWechat = NO;
        _bindWeibo = NO;
        _mobile = @"-1";
        _username = @"我";
    }
    return self;
}

+ (PIEEntityUser *)currentUser {
    dispatch_once(&onceToken, ^{
        _currentUser = [PIEEntityUser new];
    });
    return _currentUser;
}


+ (void)setCurrentUser:(PIEEntityUser *)user {
    self.currentUser.uid = user.uid;
    self.currentUser.mobile = user.mobile;
    self.currentUser.nickname = user.nickname;
    self.currentUser.sex = user.sex;
    self.currentUser.avatar = user.avatar;
    self.currentUser.likedCount = user.likedCount;
    self.currentUser.attentionNumber = user.attentionNumber;
    self.currentUser.fansNumber = user.fansNumber;
    self.currentUser.likedCount = user.likedCount;
    self.currentUser.uploadNumber = user.uploadNumber;
    self.currentUser.replyNumber = user.replyNumber;
    self.currentUser.bindWechat = user.bindWechat;
    self.currentUser.bindWeibo = user.bindWeibo;
    self.currentUser.bindQQ = user.bindQQ;
    self.currentUser.token = user.token;
}

//embarrassing
+ (void)updateCurrentUserInDatabase {

    [ATOMUserDAO updateUser:self.currentUser];
}


+ (void)updateCurrentUserFromUser:(PIEEntityUser *)user {
    if ([ATOMUserDAO isExistUser:user]) {
        [ATOMUserDAO updateUser:user];
        self.currentUser = user;
    } else {
        [ATOMUserDAO insertUser:user];
        self.currentUser = user;
    }
}

+(void)clearCurrentUser {
    _currentUser = nil;
//    _currentUser.uid = 0;
//    _currentUser.nickname = @"游客";
//    _currentUser.mobile = @"-1";
//    _currentUser.avatar = @"";
//    _currentUser.bindWechat = NO;
//    _currentUser.bindWeibo = NO;
//    _currentUser.bindQQ = NO;
}


+(void)fetchUserInDBToCurrentUser:(void (^)(BOOL))block {
  [ATOMUserDAO fetchUser:^(PIEEntityUser *user) {
      if (user) {
          self.currentUser = user;
          NSLog(@"setCurrentUser %@,%@",self.currentUser,user);
          if (block) {
              block(YES);
          }
          NSLog(@"setCurrentUser %@,%@",self.currentUser,user);

      } else {
          if (block) {
              block(NO);
          }
      }
   }];
}

+ (void)DDGetUserInfoAndUpdateMe:(void (^)(BOOL success))block {
    
    [DDBaseService GET:nil url:@"view/info" block:^(id responseObject) {
        NSDictionary* data = [responseObject objectForKey:@"data"];
        PIEEntityUser* user = [MTLJSONAdapter modelOfClass:[PIEEntityUser class] fromJSONDictionary:data error:NULL];
        user.token = [responseObject objectForKey:@"token"];
        [self updateCurrentUserFromUser:user];
        if (block) {
            block (YES);
        }
    }];

}

+ (void )DDRegister:(NSDictionary *)param withBlock:(void (^)(BOOL success))block {
    
    [DDBaseService POST:param url:URL_ACRegister block:^(id responseObject) {
        NSDictionary *data = [ responseObject objectForKey:@"data"];
        if (data) {
            PIEEntityUser* user = [MTLJSONAdapter modelOfClass:[PIEEntityUser class] fromJSONDictionary:data error:NULL];
            user.token = [responseObject objectForKey:@"token"];
//            [[DDUserManager currentUser]saveAndUpdateUser:user];
            [self updateCurrentUserFromUser:user];

            if (block) { block(YES); }
        } else {
            if (block) { block(NO); }
        }
    }];
}

+ (void )DDLogin:(NSDictionary*)param withBlock:(void (^)(BOOL succeed))block{
    [Hud activity:@""];
    
    [DDBaseService POST:param url:URL_ACLogin block:^(id responseObject) {
        NSDictionary* data = [responseObject objectForKey:@"data"];
        NSInteger status = [(NSString*)[data objectForKey:@"status"]integerValue];
        if (data) {
            {    //        data: { status: 1,正常  2，密码错误 3，未注册 }
                if(status == 1) {
                    PIEEntityUser* user = [MTLJSONAdapter modelOfClass:[PIEEntityUser class] fromJSONDictionary:data error:nil];
                    //保存更新数据库的user,并更新currentUser
                    user.token = [responseObject objectForKey:@"token"];
                    [self updateCurrentUserFromUser:user];

                    if (block) {block(YES);}
                } else if (status == 2) {
                    [Util ShowTSMessageError:@"密码错误"];
                    if (block) { block(NO); }
                } else if (status == 3) {
                    [Util ShowTSMessageWarn:@"此手机号无注册"];
                    if (block) {block(NO);}
                }
            }
        } else { if (block) {  block(NO);  } }
        
        [Hud dismiss];
    }];

}


+ (void)DD3PartyAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegistered,NSString* info))block {
    NSString* url = [NSString stringWithFormat:@"%@%@",URL_AC3PaAuth,type];
    [DDBaseService POST:param url:url block:^(id responseObject) {
        if (responseObject) {
            NSDictionary *data = [ responseObject objectForKey:@"data"];
            NSInteger isRegistered = [[data objectForKey:@"is_register"] integerValue];
            NSDictionary* userObject = [data objectForKey:@"user_obj"];
            if (isRegistered) {
                //已经注册，抓取服务器存储的user对象，更新本地user.
                PIEEntityUser* user = [MTLJSONAdapter modelOfClass:[PIEEntityUser class] fromJSONDictionary:userObject error:NULL];
                user.token = [responseObject objectForKey:@"token"];
                [self updateCurrentUserFromUser:user];

                block(YES,@"登录成功");
            } else if (isRegistered == NO){
                if (block) {
                    block(NO,@"未注册，跳到注册页面");
                }
            }
        } 
    }];

}
@end
