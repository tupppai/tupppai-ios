//
//  ATOMImageTipLabelDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMImageTipLabelDAO.h"
#import "ATOMImageTipLabel.h"

@implementation ATOMImageTipLabelDAO

- (instancetype)init {
    self=[super init];
    if (self) {
    }
    return self;
}

- (void)insertTipLabel:(ATOMImageTipLabel *)tipLabel {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:tipLabel];
            NSArray *param = [MTLFMDBAdapter columnValues:tipLabel];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
                NSLog(@"add imageTipLabel success");
            } else {
                NSLog(@"add imageTipLabel fail");
            }
        }];
    });
}

- (void)updateTipLabel:(ATOMImageTipLabel *)tipLabel {
    dispatch_queue_t q = dispatch_queue_create("update", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter updateStatementForModel:tipLabel];
            NSMutableArray *param = [[MTLFMDBAdapter columnValues:tipLabel] mutableCopy];
            [param addObject:@(tipLabel.labelID)];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
                NSLog(@"update imageTipLabel success");
            } else {
                NSLog(@"update imageTipLabel fail");
            }
        }];
    });
}

- (ATOMImageTipLabel *)selectTipLabelByLabelID:(NSInteger)labelID {
    __block ATOMImageTipLabel *tipLabel;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMImageTipLabel where labelID = ?";
        NSArray *param = @[@(labelID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            tipLabel = [MTLFMDBAdapter modelOfClass:[ATOMImageTipLabel class] fromFMResultSet:rs error:NULL];
            break;
        }
        [rs close];
    }];
    return tipLabel;
}

- (NSMutableArray *)selectTipLabelsByImageID:(NSInteger)imageID {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMImageTipLabel where imageID = ?";
        NSArray *param = @[@(imageID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMImageTipLabel * tipLabel = [MTLFMDBAdapter modelOfClass:[ATOMImageTipLabel class] fromFMResultSet:rs error:NULL];
            [muArray addObject:tipLabel];
        }
        [rs close];
    }];
    return [muArray mutableCopy];
}

- (BOOL)isExistTipLabel:(ATOMImageTipLabel *)tipLabel {
    __block BOOL flag;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMImageTipLabel where labelID = ?";
        NSArray *param = @[@(tipLabel.labelID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMImageTipLabel *tipLabel = [MTLFMDBAdapter modelOfClass:[ATOMImageTipLabel class] fromFMResultSet:rs error:NULL];
            if (tipLabel) {
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

- (void)clearTipLabels {
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"delete from ATOMImageTipLabel";
        BOOL flag = [db executeUpdate:stmt];
        if (flag) {
            NSLog(@"delete imageTipLabel success");
        } else {
            NSLog(@"delete imageTipLabel fail");
        }
    }];
}












@end
