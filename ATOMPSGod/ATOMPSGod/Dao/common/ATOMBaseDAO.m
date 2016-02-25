//
//  ATOMBaseDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
#import "ATOMCreateTable.h"

@interface ATOMBaseDAO ()

@property (nonatomic,copy) NSString *dbPath;

@end

@implementation ATOMBaseDAO

static dispatch_once_t onceToken;
static FMDatabaseQueue *_fmQueue = nil;

- (instancetype)init {
    self=[super init];
    if (self) {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:self.dbPath]==NO) { //数据库不存在
            [self createTable];
        } else {
            NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString* currentVersionHasUpdatedTablesKey = [version stringByAppendingString:@"hasUpdatedTables"];
            BOOL hasUpdateTables = [[[NSUserDefaults standardUserDefaults]valueForKey:currentVersionHasUpdatedTablesKey]boolValue];
            if (!hasUpdateTables) {
                [self updateTable];
            }
        }
    }
    return self;
}

- (NSString *)dbPath {
    if (!_dbPath) {
        _dbPath = [NSString stringWithFormat:@"%@/ATOM.sqlite",PATH_OF_DOCUMENT];
    }
    return _dbPath;
}

+ (FMDatabaseQueue *)sharedFMQueue {
    dispatch_once(&onceToken, ^{
        _fmQueue = [FMDatabaseQueue databaseQueueWithPath:[NSString stringWithFormat:@"%@/ATOM.sqlite",PATH_OF_DOCUMENT]];
    });
    return _fmQueue;
}

- (void)updateTable {
    [[[self class] sharedFMQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString* currentVersionHasUpdatedTablesKey = [version stringByAppendingString:@"hasUpdatedTables"];
        [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:currentVersionHasUpdatedTablesKey];
        [db executeUpdate:[ATOMCreateTable statamentForAddColumnForTable:@"PIEUserTable" column:@"isV" dataType:@"bool"]];
        [db executeUpdate:[ATOMCreateTable statamentForAddColumnForTable:@"PIEUserTable" column:@"balance" dataType:@"real"]];
    }];
}
- (void)createTable {
    [[[self class] sharedFMQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL flag;
    
        flag = [db executeUpdate:[ATOMCreateTable createUser]];
    }];
}






























@end
