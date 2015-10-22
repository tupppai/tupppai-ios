//
//  ATOMCommentDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDAO.h"
#import "PIECommentEntity.h"

@implementation ATOMCommentDAO

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)insertComment:(PIECommentEntity *)comment {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:comment];
            NSArray *param = [MTLFMDBAdapter columnValues:comment];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
//                NSLog(@"add comment success");
            } else {
                NSLog(@"add comment fail");
            }
        }];
    });
}

- (void)updateComment:(PIECommentEntity *)comment {
    dispatch_queue_t q = dispatch_queue_create("update", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter updateStatementForModel:comment];
            NSMutableArray *param = [[MTLFMDBAdapter columnValues:comment] mutableCopy];
            [param addObject:@(comment.cid)];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
//                NSLog(@"update comment success");
            } else {
                NSLog(@"update comment fail");
            }
        }];
    });
}

- (PIECommentEntity *)selectCommentByCommentID:(NSInteger)commentID {
    __block PIECommentEntity *comment;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMComment where cid = ?";
        NSArray *param = @[@(commentID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            comment = [MTLFMDBAdapter modelOfClass:[PIECommentEntity class] fromFMResultSet:rs error:NULL];
            break;
        }
        [rs close];
    }];
    return comment;
}

- (NSMutableArray *)selectCommentsByDetailImageID:(NSInteger)detailImageID {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMComment where detailID = ?";
        NSArray *param = @[@(detailImageID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            PIECommentEntity * comment = [MTLFMDBAdapter modelOfClass:[PIECommentEntity class] fromFMResultSet:rs error:NULL];
            [muArray addObject:comment];
        }
        [rs close];
    }];
    return [muArray mutableCopy];
}

- (NSMutableArray *)selectCommentsByHomeImageID:(NSInteger)homeImageID {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMComment where imageID = ?";
        NSArray *param = @[@(homeImageID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            PIECommentEntity * comment = [MTLFMDBAdapter modelOfClass:[PIECommentEntity class] fromFMResultSet:rs error:NULL];
            [muArray addObject:comment];
        }
        [rs close];
    }];
    return [muArray mutableCopy];
}

- (BOOL)isExistComment:(PIECommentEntity *)comment {
    __block BOOL flag;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMComment where cid = ?";
        NSArray *param = @[@(comment.cid)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            PIECommentEntity *comment = [MTLFMDBAdapter modelOfClass:[PIECommentEntity class] fromFMResultSet:rs error:NULL];
            if (comment) {
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

- (void)clearCommentsByDetailImageID:(NSInteger)detailImageID {
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"delete from ATOMComment where detailID = ?";
        NSArray *param = @[@(detailImageID)];
        BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
        if (flag) {
            NSLog(@"delete comment success");
        } else {
            NSLog(@"delete comment fail");
        }
    }];
}

































@end
