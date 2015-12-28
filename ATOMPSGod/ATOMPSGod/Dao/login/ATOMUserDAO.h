//
//  ATOMUserDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class PIEUserModel;

@interface ATOMUserDAO : ATOMBaseDAO

+ (void)insertUser:(PIEUserModel *)user;
+ (PIEUserModel *)selectUserByUID:(NSInteger)uid;
+ (BOOL)isExistUser:(PIEUserModel *)user;
+ (void)updateUser:(PIEUserModel *)user;
+ (void)fetchUser:(void (^)(PIEUserModel*))block;
+(void)clearUsers;
@end
