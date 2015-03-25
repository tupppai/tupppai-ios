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
        } else { //数据库已经存在
            
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

- (void)createTable {
    [[[self class] sharedFMQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL flag;
        
        flag = [db executeUpdate:[ATOMCreateTable createUser]];
        if (flag) {
            NSLog(@"create User success");
        } else {
            NSLog(@"create User fail");
        }
        flag = [db executeUpdate:[ATOMCreateTable createImageTipLabel]];
        if (flag) {
            NSLog(@"create ImageTipLabel success");
        } else {
            NSLog(@"create ImageTipLabel fail");
        }
        flag = [db executeUpdate:[ATOMCreateTable createHomeImage]];
        if (flag) {
            NSLog(@"create HomeImage success");
        } else {
            NSLog(@"create HomeImage fail");
        }
        flag = [db executeUpdate:[ATOMCreateTable createDetailImage]];
        if (flag) {
            NSLog(@"create DetailImage success");
        } else {
            NSLog(@"create DetailImage fail");
        }
        flag = [db executeUpdate:[ATOMCreateTable createComment]];
        if (flag) {
            NSLog(@"create Comment success");
        } else {
            NSLog(@"create Comment fail");
        }
    }];
}






























@end
