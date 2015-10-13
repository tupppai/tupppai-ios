//
//  ATOMUserDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class ATOMUser;

@interface ATOMUserDAO : ATOMBaseDAO

+ (void)insertUser:(ATOMUser *)user;
+ (ATOMUser *)selectUserByUID:(NSInteger)uid;
+ (BOOL)isExistUser:(ATOMUser *)user;
+ (void)updateUser:(ATOMUser *)user;
+ (void)fetchUser:(void (^)(ATOMUser*))block;
+(void)clearUsers;
@end
