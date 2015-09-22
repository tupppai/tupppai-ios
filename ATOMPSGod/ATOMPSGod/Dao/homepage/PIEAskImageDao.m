//
//  PIEAskImageDao.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/22/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEAskImageDao.h"

@implementation PIEAskImageDao
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)insert:(PIEImageEntity *)entity {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:entity];
            NSArray *param = [MTLFMDBAdapter columnValues:entity];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
            } else {
                NSLog(@"add replier fail");
            }
        }];
    });
}

+ (void)update:(PIEImageEntity *)entity {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter updateStatementForModel:entity];
            NSMutableArray *param = [[MTLFMDBAdapter columnValues:entity] mutableCopy];
            [param addObject:@(entity.ID)];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
                //                NSLog(@"update replier success");
            } else {
                NSLog(@"update replier fail");
            }
        }];
    });
}

+ (NSMutableArray *)selectByID:(NSInteger)ID {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from PIEImageEntity where ID = ?";
        NSArray *param = @[@(ID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            PIEImageEntity *entity = [MTLFMDBAdapter modelOfClass:[PIEImageEntity class] fromFMResultSet:rs error:NULL];
            [muArray addObject:entity];
        }
        [rs close];
    }];
    return [muArray mutableCopy];
}

+ (BOOL)isExist:(PIEImageEntity *)entity {
    __block BOOL flag;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from PIEImageEntity where ID = ?";
        NSArray *param = @[@(entity.ID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            PIEImageEntity *entity = [MTLFMDBAdapter modelOfClass:[PIEImageEntity class] fromFMResultSet:rs error:NULL];
            if (entity) {
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

+ (void)clear {
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"delete from PIEImageEntity";
        BOOL flag = [db executeUpdate:stmt];
        if (flag) {
        } else {
        }
    }];
}
@end
