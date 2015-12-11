//
//  ATOMCurrentUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDUserManager.h"
//#import "PIEEntityUser.h"
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


- (NSMutableDictionary *)dictionaryFromModel {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:_username forKey:@"nickname"];
    [dict setObject:_mobile forKey:@"mobile"];
    [dict setObject:_password forKey:@"password"];
//    [dict setObject:[NSString stringWithFormat:@"%d", (int)_locationID] forKey:@"location"];
    [dict setObject:[NSString stringWithFormat:@"%d", (int)_sex] forKey:@"sex"];
    [dict setObject:[NSString stringWithFormat:@"%@", _avatar] forKey:@"avatar"];

    switch (_signUpType) {
        case ATOMSignUpWechat:
            [dict setObject:_sourceData[@"openid"] forKey:@"openid"];
            [dict setObject:_sourceData[@"headimgurl"] forKey:@"avatar_url"];
            [dict setObject:@"weixin" forKey:@"type"];
            break;
        case ATOMSignUpQQ:
            [dict setObject:_sourceData[@"openid"] forKey:@"openid"];
            [dict setObject:_sourceData[@"headimgurl"] forKey:@"avatar_url"];
            [dict setObject:@"qq" forKey:@"type"];
            break;
        case ATOMSignUpWeibo:
            [dict setObject:_sourceData[@"idstr"] forKey:@"openid"];
            [dict setObject:_sourceData[@"avatar_hd"] forKey:@"avatar_url"];
            [dict setObject:_sourceData[@"province"] forKey:@"province"];
            [dict setObject:_sourceData[@"city"] forKey:@"city"];
            [dict setObject:@"weibo" forKey:@"type"];
            break;
        case ATOMSignUpMobile:
            [dict setObject:[NSString stringWithFormat:@"%@", _region[@"cityID"]] forKey:@"city"];
            [dict setObject:[NSString stringWithFormat:@"%@", _region[@"provinceID"]] forKey:@"province"];
            [dict setObject:@"mobile" forKey:@"type"];
            break;
        default:
            break;
    }
    return [dict mutableCopy];
}


- (void)setCurrentUser:(PIEEntityUser *)user {
//    _uid = user.uid;
//    _mobile = user.mobile;
//    _username = user.nickname;
//    _sex = user.sex;
//    _avatar = user.avatar;
//    _praisedCount = user.likedCount;
//    _attentionNumber = user.attentionNumber;
//    _fansNumber = user.fansNumber;
////    _likeNumber = user.likeNumber;
//    _uploadNumber = user.uploadNumber;
//    _replyNumber = user.replyNumber;
//    _bindWechat = user.bindWechat;
//    _bindWeibo = user.bindWeibo;
//    _bindQQ = user.bindQQ;
//    _token = user.token;
    
    
    _currentUser.uid = user.uid;
    _currentUser.mobile = user.mobile;
    _currentUser.nickname = user.nickname;
    _currentUser.sex = user.sex;
    _currentUser.avatar = user.avatar;
    _currentUser.likedCount = user.likedCount;
    _currentUser.attentionNumber = user.attentionNumber;
    _currentUser.fansNumber = user.fansNumber;
    _currentUser.likedCount = user.likedCount;
    _currentUser.uploadNumber = user.uploadNumber;
    _currentUser.replyNumber = user.replyNumber;
    _currentUser.bindWechat = user.bindWechat;
    _currentUser.bindWeibo = user.bindWeibo;
    _currentUser.bindQQ = user.bindQQ;
    _currentUser.token = user.token;
    
//    _currentUser = user;
}

//embarrassing
+ (void)updateDBUserFromCurrentUser {
//    PIEEntityUser* user = [PIEEntityUser new];
//    DDUserManager* cUser = [DDUserManager currentUser];
//    user.uid = cUser.uid;
//    user.mobile = cUser.mobile;
//    user.nickname = cUser.username;
//    user.sex = cUser.sex;
//    user.avatar = cUser.avatar;
//    user.attentionNumber = cUser.attentionNumber;
//    user.fansNumber = cUser.fansNumber;
////    user.likeNumber = cUser.likeNumber;
//    user.uploadNumber = cUser.uploadNumber;
//    user.replyNumber = cUser.replyNumber;
//    user.bindWechat = cUser.bindWechat;
//    user.bindWeibo = cUser.bindWeibo;
//    user.bindQQ = cUser.bindQQ;
//    user.likedCount = cUser.praisedCount;
//    user.token = cUser.token;
    [ATOMUserDAO updateUser:_currentUser];
}

-(void)tellMeEveryThingAboutYou {
    NSLog(@"%@,%@,%@,_likeNumber%ld id %zd",_username,_mobile,_avatar,(long)_likeNumber,_uid);
}


+ (void)saveAndUpdateUser:(PIEEntityUser *)user {
    if ([ATOMUserDAO isExistUser:user]) {
        [ATOMUserDAO updateUser:user];
//        [self setCurrentUser:[ATOMUserDAO  selectUserByUID:user.uid]];
        _currentUser = [ATOMUserDAO  selectUserByUID:user.uid];
    } else {
        [ATOMUserDAO insertUser:user];
        _currentUser = user;
//        [self setCurrentUser:user];
    }
}

-(void)wipe {
    self.sourceData = nil;
    self.uid = 0;
    self.username = @"游客";
    self.mobile = @"-1";
    self.avatar = @"";
    self.bindWechat = NO;
    self.bindWeibo = NO;
    self.bindQQ = NO;
}

+(void)fetchUserInDBToCurrentUser:(void (^)(BOOL))block {
  [ATOMUserDAO fetchUser:^(PIEEntityUser *user) {
      if (user) {
          _currentUser = user;
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

+ (void)DDGetUserInfoAndUpdateMe {
    [DDService ddGetMyInfo:nil withBlock:^(NSDictionary *data) {
        if (data) {
            PIEEntityUser* user = [MTLJSONAdapter modelOfClass:[PIEEntityUser class] fromJSONDictionary:data error:NULL];
            //保存更新数据库的user,并更新currentUser
//            [[DDUserManager currentUser]saveAndUpdateUser:user];
            [self saveAndUpdateUser:user];
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
            [self saveAndUpdateUser:user];

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
                    NSLog(@"token%@",user.token);
//                    [[DDUserManager currentUser]saveAndUpdateUser:user];
                    [self saveAndUpdateUser:user];

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
//                [[DDUserManager currentUser]saveAndUpdateUser:user];
                [self saveAndUpdateUser:user];

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
