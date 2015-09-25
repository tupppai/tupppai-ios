//
//  ATOMCurrentUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDUserManager.h"
#import "ATOMUser.h"
#import "ATOMUserDao.h"
@implementation DDUserManager

static dispatch_once_t onceToken;
static DDUserManager *_currentUser;

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

+ (DDUserManager *)currentUser {
    dispatch_once(&onceToken, ^{
        _currentUser = [DDUserManager new];
    });
    return _currentUser;
}


- (NSMutableDictionary *)dictionaryFromModel {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:_username forKey:@"nickname"];
    [dict setObject:_mobile forKey:@"mobile"];
    [dict setObject:_password forKey:@"password"];
    [dict setObject:[NSString stringWithFormat:@"%d", (int)_locationID] forKey:@"location"];
    [dict setObject:[NSString stringWithFormat:@"%d", (int)_sex] forKey:@"sex"];
    [dict setObject:[NSString stringWithFormat:@"%@", _avatar] forKey:@"avatar"];

    switch (_signUpType) {
        case ATOMSignUpWechat:
            [dict setObject:_sourceData[@"openid"] forKey:@"openid"];
            [dict setObject:_sourceData[@"headimgurl"] forKey:@"avatar_url"];
            [dict setObject:@"weixin" forKey:@"type"];
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

- (void)setCurrentUser:(ATOMUser *)user {
    _uid = user.uid;
    _mobile = user.mobile;
    _password = @"";
    _username = user.nickname;
    _sex = user.sex;
    _avatar = user.avatar;
    _locationID = user.locationID;
    _backgroundImage = user.backgroundImage;
    _attentionNumber = user.attentionNumber;
    _fansNumber = user.fansNumber;
    _likeNumber = user.likeNumber;
    _uploadNumber = user.uploadNumber;
    _replyNumber = user.replyNumber;
    _proceedingNumber = user.proceedingNumber;
    _attentionUploadNumber = user.attentionUploadNumber;
    _attentionWorkNumber = user.attentionWorkNumber;
    _bindWechat = user.boundWechat;
    _bindWeibo = user.boundWeibo;
}

-(void)tellMeEveryThingAboutYou {
    NSLog(@"%@,%@,%@,_likeNumber%ld id %zd",_username,_mobile,_avatar,(long)_likeNumber,_uid);
}
- (void)saveAndUpdateUser:(ATOMUser *)user {
    if ([ATOMUserDAO isExistUser:user]) {
        [ATOMUserDAO updateUser:user];
        [self setCurrentUser:[ATOMUserDAO  selectUserByUID:user.uid]];
    } else {
        [ATOMUserDAO insertUser:user];
        [self setCurrentUser:user];
    }
}
-(void)wipe {
    self.sourceData = nil;
    self.uid = 0;
    self.username = @"游客";
    self.mobile = @"-1";
    self.locationID = 0;
    self.avatar = @"";
    self.avatarID = 0;
    self.backgroundImage = @"";
    self.bindWechat = NO;
    self.bindWeibo = NO;
}

-(void)fetchCurrentUserInDB:(void (^)(BOOL))block {
  [ATOMUserDAO fetchUser:^(ATOMUser *user) {
      if (user) {
          [user NSLogSelf];
          [self setCurrentUser:user];
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
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:NULL];
            //保存更新数据库的user,并更新currentUser
            [[DDUserManager currentUser]saveAndUpdateUser:user];
        }
    }];
}

+ (void )DDRegister:(NSDictionary *)param withBlock:(void (^)(BOOL success))block {
    [DDService ddRegister:param withBlock:^(NSDictionary *data) {
        if (data) {
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:NULL];
            [[DDUserManager currentUser]saveAndUpdateUser:user];
            if (block) { block(YES); }
        } else {
            if (block) { block(NO); }
        }
    }];
}

+ (void )DDLogin:(NSDictionary*)param withBlock:(void (^)(BOOL succeed))block{
    [Hud activity:@""];
    [DDService ddLogin:param withBlock:^(NSDictionary *data,NSInteger status) {
        [Hud dismiss];
        if (data) {
            {    //        data: { status: 1,正常  2，密码错误 3，未注册 }
                if(status == 1) {
                    [Util ShowTSMessageSuccess:@"登录成功"];
                    ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:nil];
                    //保存更新数据库的user,并更新currentUser
                    [[DDUserManager currentUser]saveAndUpdateUser:user];
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
    }];
}


+ (void)DD3PartyAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegistered,NSString* info))block {
    [DDService dd3PartyAuth:param with3PaType:type withBlock:^(BOOL isRegistered,NSDictionary* userObejct) {
        if (isRegistered) {
            //已经注册，抓取服务器存储的user对象，更新本地user.
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:userObejct error:NULL];
            [[DDUserManager currentUser]saveAndUpdateUser:user];
            block(YES,@"登录成功");
        } else {
            if (block) {
                block(NO,@"未注册，跳到注册页面");
            }
        }
    }];
}
@end
