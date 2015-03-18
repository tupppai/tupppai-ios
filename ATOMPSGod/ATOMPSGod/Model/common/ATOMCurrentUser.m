//
//  ATOMCurrentUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCurrentUser.h"
#import "ATOMUser.h"

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
    [dict setObject:[NSString stringWithFormat:@"%lld",_locationID] forKey:@"location"];
    [dict setObject:[NSString stringWithFormat:@"%d",(int)_sex] forKey:@"sex"];
    [dict setObject:[NSString stringWithFormat:@"%lld",_avatarID] forKey:@"avatar"];
    return [dict mutableCopy];
}

- (void)setCurrentUser:(ATOMUser *)user {
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



























@end
