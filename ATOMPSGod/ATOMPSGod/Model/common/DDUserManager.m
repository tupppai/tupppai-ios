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


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//    }
//    return self;
//}
static  PIEUserModel* shareUser = nil;

+ (PIEUserModel *)currentUser {
    
/*   
 First of all when static is declared within function, it is declared only once. So, the line
Will be executed only once when the function gets called for first time.
 
 In the next line when you use dispath_once, it will be executed for only once. So the creation of shareUser will be done once only. So, thats a perfect way to create a singleton class.
 
 
 static  PIEUserModel* shareUser = nil;
 
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 shareUser = [PIEUserModel new];
 });
 return shareUser;
 
*/
    

    if (shareUser == nil) {
        shareUser = [PIEUserModel new];
    }
    return shareUser;
}


+ (void)setCurrentUser:(PIEUserModel *)user {
    self.currentUser.uid             = user.uid;
    self.currentUser.mobile          = user.mobile;
    self.currentUser.nickname        = user.nickname;
    self.currentUser.sex             = user.sex;
    self.currentUser.avatar          = user.avatar;
    self.currentUser.likedCount      = user.likedCount;
    self.currentUser.attentionNumber = user.attentionNumber;
    self.currentUser.fansNumber      = user.fansNumber;
    self.currentUser.likedCount      = user.likedCount;
    self.currentUser.uploadNumber    = user.uploadNumber;
    self.currentUser.replyNumber     = user.replyNumber;
    self.currentUser.bindWechat      = user.bindWechat;
    self.currentUser.bindWeibo       = user.bindWeibo;
    self.currentUser.bindQQ          = user.bindQQ;
    self.currentUser.token           = user.token;
    self.currentUser.isV             = user.isV;
}

//embarrassing
+ (void)updateCurrentUserInDatabase {

    [ATOMUserDAO updateUser:self.currentUser];
}


+ (void)updateCurrentUserFromUser:(PIEUserModel *)user {
    if ([ATOMUserDAO isExistUser:user]) {
        [ATOMUserDAO updateUser:user];
        self.currentUser = user;
    } else {
        [ATOMUserDAO insertUser:user];
        self.currentUser = user;
    }
}

+(void)clearCurrentUser {
    self.currentUser = nil;
}


+(void)fetchUserInDBToCurrentUser:(void (^)(BOOL))block {
  [ATOMUserDAO fetchUser:^(PIEUserModel *user) {
      if (user) {
          self.currentUser = user;
          if (block) {
              block(YES);
          }
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
        PIEUserModel* user = [MTLJSONAdapter modelOfClass:[PIEUserModel class] fromJSONDictionary:data error:NULL];
        user.token = [responseObject objectForKey:@"token"];
        if (user) {
            [self updateCurrentUserFromUser:user];
            if (block) {
                block (YES);
            }
        }
    }];

}

+ (void )DDRegister:(NSDictionary *)param withBlock:(void (^)(BOOL success))block {
    
    [DDBaseService POST:param url:URL_ACRegister block:^(id responseObject) {
        NSDictionary *data = [ responseObject objectForKey:@"data"];
        if (data) {
            PIEUserModel* user = [MTLJSONAdapter modelOfClass:[PIEUserModel class] fromJSONDictionary:data error:NULL];
            user.token = [responseObject objectForKey:@"token"];
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
                    PIEUserModel* user = [MTLJSONAdapter modelOfClass:[PIEUserModel class] fromJSONDictionary:data error:nil];
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
                PIEUserModel* user = [MTLJSONAdapter modelOfClass:[PIEUserModel class] fromJSONDictionary:userObject error:NULL];
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


+ (void)getMyFans:(NSDictionary *)param withBlock:(void (^)(NSArray *))block {
    [DDService ddGetFans:param withBlock:^(NSArray *data) {
        NSArray *resultArray = [MTLJSONAdapter modelsOfClass:[PIEUserModel class] fromJSONArray:data error:NULL];
        if (block) {
            block(resultArray);
        }
    }];
}

+ (void)getMyFollows:(NSDictionary *)param withBlock:(void (^)(NSArray *recommendArray, NSArray *myFollowArray))block {
    [DDService ddGetFollow:param withBlock:^(NSArray *recommendArray, NSArray *myFollowArray) {
        
        NSArray* recommends = [MTLJSONAdapter modelsOfClass:[PIEUserModel class] fromJSONArray:recommendArray error:NULL];
        NSArray* followers = [MTLJSONAdapter modelsOfClass:[PIEUserModel class] fromJSONArray:myFollowArray error:NULL];
        
        if (block) {
            block(recommends, followers);
        }
    }];
}

@end
