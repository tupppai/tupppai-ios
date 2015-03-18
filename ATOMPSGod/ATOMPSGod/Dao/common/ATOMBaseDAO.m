//
//  ATOMBaseDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
#import "ATOMCreateTable.h"

@implementation ATOMBaseDAO

- (instancetype)init {
    self=[super init];
    if (self) {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:self.dbPath]==NO) { //数据库不存在
            [self createTable];
        } else { //数据库已经存在
            
        }
    }
    return self;
}

- (NSString *)dbPath {
    if (!_dbPath) {
        _dbPath=[NSString stringWithFormat:@"%@/ATOM.sqlite",PATH_OF_DOCUMENT];
    }
    return _dbPath;
}

- (FMDatabaseQueue *)fmQueue {
    if (!_fmQueue) {
        _fmQueue=[FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    }
    return _fmQueue;
}

- (void)createTable {
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:[ATOMCreateTable createUser]];
    }];
}

@end
