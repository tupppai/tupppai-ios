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

- (void)insertUser:(ATOMUser *)user {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
            NSArray *param = [MTLFMDBAdapter columnValues:user];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (!flag) {
                NSLog(@"add user success");
            } else {
                NSLog(@"add user fail");
            }
        }];
    });
}

- (ATOMUser *)selectUserByUID:(NSString *)uid {
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

- (BOOL)isExistUser:(ATOMUser *)user {
    __block BOOL flag;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMUser where uid = ?";
        NSArray *param = @[@(user.uid)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMUser *user = [MTLFMDBAdapter modelOfClass:[ATOMUser class] fromFMResultSet:rs error:NULL];
            if (user) {
                flag = YES;
            } else {
                flag = NO;
            }
            break;
        }
        [rs close];
    }];
    return flag;
}




















@end
