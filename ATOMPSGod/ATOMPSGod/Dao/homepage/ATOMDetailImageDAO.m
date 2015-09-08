//
//  ATOMDetailImageDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMDetailImageDAO.h"
#import "ATOMDetailPage.h"

@implementation ATOMDetailImageDAO

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)insertDetailImage:(ATOMDetailPage *)detailImage {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:detailImage];
            NSArray *param = [MTLFMDBAdapter columnValues:detailImage];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
//                NSLog(@"add detailImage success detailID%ld imageID%ld url %@",(long)detailImage.detailID,(long)detailImage.imageID,detailImage.imageURL);
            } else {
                NSLog(@"add detailImage fail");
            }
        }];
    });
}

- (void)updateDetailImage:(ATOMDetailPage *)detailImage {
    dispatch_queue_t q = dispatch_queue_create("update", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter updateStatementForModel:detailImage];
            NSMutableArray *param = [[MTLFMDBAdapter columnValues:detailImage] mutableCopy];
            [param addObject:@(detailImage.detailID)];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
//                NSLog(@"update detailImage success");
            } else {
                NSLog(@"update detailImage fail");
            }
        }];
    });
}

- (NSArray *)selectDetailImagesByImageID:(NSInteger)imageID {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMDetailImage where imageID = ?";
        NSArray *param = @[@(imageID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMDetailPage *detailImage = [MTLFMDBAdapter modelOfClass:[ATOMDetailPage class] fromFMResultSet:rs error:NULL];
            [muArray addObject:detailImage];
        }
        [rs close];
    }];
    return [muArray copy];
}

- (NSArray *)selectDetailImages {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMDetailImage";
        FMResultSet *rs = [db executeQuery:stmt];
        while ([rs next]) {
            ATOMDetailPage *detailImage = [MTLFMDBAdapter modelOfClass:[ATOMDetailPage class] fromFMResultSet:rs error:NULL];
            [muArray addObject:detailImage];
        }
        [rs close];
    }];
    return [muArray copy];
}

- (NSArray *)selectHomeImageIDOrderByClickTime {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select imageID from ATOMDetailImage order by clickTime desc, imageID asc limit 0, 15";
        FMResultSet *rs = [db executeQuery:stmt];
        while ([rs next]) {
            NSInteger imageID = [rs intForColumn:@"imageID"];
            [muArray addObject:@(imageID)];
        }
    }];
    return [muArray copy];
}

- (BOOL)isExistDetailImage:(ATOMDetailPage *)detailImage {
    __block BOOL flag;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMDetailImage where detailID = ?";
        NSArray *param = @[@(detailImage.detailID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMDetailPage *detailImage = [MTLFMDBAdapter modelOfClass:[ATOMDetailPage class] fromFMResultSet:rs error:NULL];
            if (detailImage) {
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

- (void)clearDetailImagsByImageID:(NSInteger)imageID {
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"delete from ATOMDetailImage where imageID = ?";
        NSArray *param = @[@(imageID)];
        BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
        if (flag) {
//            NSLog(@"delete detailImage%d success", (int)imageID);
        } else {
            NSLog(@"delete detailImage%d fail", (int)imageID);
        }
    }];
}

@end
