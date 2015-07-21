//
//  ATOMReplierDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/4/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMReplierDAO.h"
#import "ATOMReplier.h"

@implementation ATOMReplierDAO

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)insertReplier:(ATOMReplier *)replier {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:replier];
            NSArray *param = [MTLFMDBAdapter columnValues:replier];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
//                NSLog(@"add replier success");
            } else {
                NSLog(@"add replier fail");
            }
        }];
    });
}

- (void)updateReplier:(ATOMReplier *)replier {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter updateStatementForModel:replier];
            NSMutableArray *param = [[MTLFMDBAdapter columnValues:replier] mutableCopy];
            [param addObject:@(replier.replierID)];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
//                NSLog(@"update replier success");
            } else {
                NSLog(@"update replier fail");
            }
        }];
    });
}

- (ATOMReplier *)selectReplierByreplierID:(NSInteger)replierID {
    __block ATOMReplier *replier;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMReplier where replierID = ?";
        NSArray *param = @[@(replierID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            replier = [MTLFMDBAdapter modelOfClass:[ATOMReplier class] fromFMResultSet:rs error:NULL];
            break;
        }
        [rs close];
    }];
    return replier;
}

- (NSMutableArray *)selectReplierByImageID:(NSInteger)imageID {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMReplier where imageID = ?";
        NSArray *param = @[@(imageID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMReplier *replier = [MTLFMDBAdapter modelOfClass:[ATOMReplier class] fromFMResultSet:rs error:NULL];
            [muArray addObject:replier];
        }
        [rs close];
    }];
    return [muArray mutableCopy];
}

- (BOOL)isExistReplier:(ATOMReplier *)replier {
    __block BOOL flag;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMReplier where imageID = ?";
        NSArray *param = @[@(replier.replierID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMReplier *replier = [MTLFMDBAdapter modelOfClass:[ATOMReplier class] fromFMResultSet:rs error:NULL];
            if (replier) {
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

- (void)clearReplier {
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"delete from ATOMReplier";
        BOOL flag = [db executeUpdate:stmt];
        if (flag) {
            NSLog(@"delete replier success");
        } else {
            NSLog(@"delete replier fail");
        }
    }];
}


@end
