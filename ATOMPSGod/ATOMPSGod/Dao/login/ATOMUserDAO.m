//
//  ATOMUserDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUserDAO.h"
#import "PIEEntityUser.h"

@implementation ATOMUserDAO

- (instancetype)init {
    self=[super init];
    if (self) {
    }
    return self;
}

+ (void)insertUser:(PIEEntityUser *)user {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
            NSArray *param = [MTLFMDBAdapter columnValues:user];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
                NSLog(@"insert user into DB succeed");
            } else {
                NSLog(@"insert user into DB fail");
            }
        }];
    });
}

+ (PIEEntityUser *)selectUserByUID:(NSInteger)uid {
    __block PIEEntityUser *user;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from PIEUserTable where uid = ?";
        NSNumber* uid_ns = [NSNumber numberWithInteger:uid];
        NSArray *param = @[uid_ns];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            user = [MTLFMDBAdapter modelOfClass:[PIEEntityUser class] fromFMResultSet:rs error:NULL];
            break;
        }
        [rs close];
    }];
    return user;
}

+ (void)fetchUser:(void (^)(PIEEntityUser*))block {
    NSLog(@"fetchFirstUser");
    __block PIEEntityUser *user;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from PIEUserTable";
        FMResultSet *rs = [db executeQuery:stmt];
        int n = 0;
        while ([rs next]) {
            user = [MTLFMDBAdapter modelOfClass:[PIEEntityUser class] fromFMResultSet:rs error:NULL];
//            break;
            n++;
        }
        [rs close];
    }];
    if (user && block) {
        block(user);
    } else if (block) {
        block(nil);
    }
}

+ (BOOL)isExistUser:(PIEEntityUser *)user {
    __block BOOL flag = false;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from PIEUserTable where uid = ?";
        NSNumber* uid = [NSNumber numberWithInteger:user.uid];
//        NSArray *param = @[uid];
//        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        FMResultSet *rs = [db executeQuery:stmt,uid];
        while ([rs next]) {
            PIEEntityUser *user = [MTLFMDBAdapter modelOfClass:[PIEEntityUser class] fromFMResultSet:rs error:NULL];
            if (user) {
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

+ (void)updateUser:(PIEEntityUser *)user {
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
        NSString *stmt = @"delete from PIEUserTable";
        [db executeUpdate:stmt];
    }];
}

@end
