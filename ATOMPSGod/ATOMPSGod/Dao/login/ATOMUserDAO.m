//
//  ATOMUserDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUserDAO.h"
#import "ATOMUser.h"

@implementation ATOMUserDAO

- (instancetype)init {
    self=[super init];
    if (self) {
    }
    return self;
}

+ (void)insertUser:(ATOMUser *)user {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
            NSArray *param = [MTLFMDBAdapter columnValues:user];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (!flag) {
                NSLog(@"insert user into DB succeed");
            } else {
                NSLog(@"insert user into DB fail");
            }
        }];
    });
}

+ (ATOMUser *)selectUserByUID:(NSString *)uid {
    NSLog(@"selectUserByUID");
    __block ATOMUser *user;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMUser where uid = ?";
        NSArray *param = @[uid];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            user = [MTLFMDBAdapter modelOfClass:[ATOMUser class] fromFMResultSet:rs error:NULL];
            break;
        }
        [rs close];
    }];
    return user;
}

+ (void)fetchUser:(void (^)(ATOMUser*))block {
    NSLog(@"fetchFirstUser");
    __block ATOMUser *user;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMUser";
        FMResultSet *rs = [db executeQuery:stmt];
        int n = 0;
        while ([rs next]) {
            user = [MTLFMDBAdapter modelOfClass:[ATOMUser class] fromFMResultSet:rs error:NULL];
//            break;
            n++;
        }
        NSLog(@"仍然有%d个用户存在数据库",n);
        [rs close];
    }];
    if (user && block) {
        block(user);
    } else if (block) {
        block(nil);
    }
}

+ (BOOL)isExistUser:(ATOMUser *)user {
    __block BOOL flag;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMUser where uid = ?";
        NSArray *param = @[@(user.uid)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMUser *user = [MTLFMDBAdapter modelOfClass:[ATOMUser class] fromFMResultSet:rs error:NULL];
            [user NSLogSelf];
            NSLog(@"正在检索用户是否已经存在数据库...");
            if (user) {
                NSLog(@"用户已经存在数据库");
                flag = YES;
                break;
            } else {
                flag = NO;
            }
        }
        [rs close];
    }];
    return flag;
}

+ (void)updateUser:(ATOMUser *)user {
    dispatch_queue_t q = dispatch_queue_create("update", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter updateStatementForModel:user];
            NSMutableArray *param = [[MTLFMDBAdapter columnValues:user] mutableCopy];
            [param addObject:@(user.uid)];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
                NSLog(@"update user in DB succeed");
            } else {
                NSLog(@"update user in DB fail");
            }
        }];
    });
}

+(void)clearUsers {
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"delete from ATOMUser";
        [db executeUpdate:stmt];
    }];
}

@end
