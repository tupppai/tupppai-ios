//
//  ATOMCurrentUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCurrentUser.h"
#import "ATOMUser.h"
#import "ATOMUserDao.h"
@implementation ATOMCurrentUser

static dispatch_once_t onceToken;
static ATOMCurrentUser *_currentUser;

+ (ATOMCurrentUser *)currentUser {
    dispatch_once(&onceToken, ^{
        _currentUser = [ATOMCurrentUser new];
    });
    return _currentUser;
}

- (NSMutableDictionary *)dictionaryFromModel {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:_nickname forKey:@"nickname"];
    [dict setObject:_mobile forKey:@"mobile"];
    [dict setObject:_password forKey:@"password"];
    [dict setObject:[NSString stringWithFormat:@"%d", (int)_locationID] forKey:@"location"];
    [dict setObject:[NSString stringWithFormat:@"%d", (int)_sex] forKey:@"sex"];
    [dict setObject:[NSString stringWithFormat:@"%@", _avatar] forKey:@"avatar"];
    return [dict mutableCopy];
}

- (void)setCurrentUser:(ATOMUser *)user {
    NSLog(@"setCurrentUser");
    _uid = user.uid;
    _mobile = user.mobile;
    _password = @"";
    _nickname = user.nickname;
    _sex = user.sex;
    _avatar = user.avatar;
    _locationID = user.locationID;
    _backgroundImage = user.backgroundImage;
    _attentionNumber = user.attentionNumber;
    _fansNumber = user.fansNumber;
    _praiseNumber = user.praiseNumber;
    _uploadNumber = user.uploadNumber;
    _replyNumber = user.replyNumber;
    _proceedingNumber = user.proceedingNumber;
    _attentionUploadNumber = user.attentionUploadNumber;
    _attentionWorkNumber = user.attentionWorkNumber;
}

-(void)tellMeEveryThingAboutYou {
    NSLog(@"%@,%@,%@,_praiseNumber%ld",_nickname,_mobile,_avatar,(long)_praiseNumber);
}
- (void)saveAndUpdateUser:(ATOMUser *)user {
    if ([ATOMUserDAO isExistUser:user]) {
        [ATOMUserDAO updateUser:user];
        [self setCurrentUser:[ATOMUserDAO  selectUserByUID:[NSString stringWithFormat:@"%ld",user.uid]]];
    } else {
        [ATOMUserDAO insertUser:user];
        [self setCurrentUser:user];
    }
    [self tellMeEveryThingAboutYou];
}
-(void)wipe {
    self.sourceData = nil;
    self.uid = 0;
    self.nickname = @"游客";
    self.mobile = @"-1";
    self.locationID = 0;
    self.avatar = @"";
    self.avatarID = 0;
    self.backgroundImage = @"";
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
@end
