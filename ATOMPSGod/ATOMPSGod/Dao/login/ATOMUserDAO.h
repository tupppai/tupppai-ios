//
//  ATOMUserDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class PIEEntityUser;

@interface ATOMUserDAO : ATOMBaseDAO

+ (void)insertUser:(PIEEntityUser *)user;
+ (PIEEntityUser *)selectUserByUID:(NSInteger)uid;
+ (BOOL)isExistUser:(PIEEntityUser *)user;
+ (void)updateUser:(PIEEntityUser *)user;
+ (void)fetchUser:(void (^)(PIEEntityUser*))block;
+(void)clearUsers;
@end
