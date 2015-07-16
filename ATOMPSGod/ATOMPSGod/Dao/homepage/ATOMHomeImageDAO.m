//
//  ATOMHomeImageDAO.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomeImageDAO.h"
#import "ATOMHomeImage.h"

@implementation ATOMHomeImageDAO

- (instancetype)init {
    self=[super init];
    if (self) {
    }
    return self;
}

- (void)insertHomeImage:(ATOMHomeImage *)homeImage {
    dispatch_queue_t q = dispatch_queue_create("insert", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter insertStatementForModel:homeImage];
            NSArray *param = [MTLFMDBAdapter columnValues:homeImage];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
                NSLog(@"save homeImage ok");
            } else {
                NSLog(@"save homeImage fail");
            }
        }];
    });
}

- (void)updateHomeImage:(ATOMHomeImage *)homeImage {
    dispatch_queue_t q = dispatch_queue_create("update", NULL);
    dispatch_async(q, ^{
        [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
            NSString *stmt = [MTLFMDBAdapter updateStatementForModel:homeImage];
            NSMutableArray *param = [[MTLFMDBAdapter columnValues:homeImage] mutableCopy];
            [param addObject:@(homeImage.imageID)];
            BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
            if (flag) {
                NSLog(@"update homeImage ok");
            } else {
                NSLog(@"update homeImage fail");
            }
        }];
    });
}

- (ATOMHomeImage *)selectHomeImageByImageID:(NSInteger)imageID {
    __block ATOMHomeImage *homeImage;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMHomeImage where imageID = ?";
        NSArray *param = @[@(imageID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            homeImage = [MTLFMDBAdapter modelOfClass:[ATOMHomeImage class] fromFMResultSet:rs error:NULL];
            break;
        }
        [rs close];
    }];
    return homeImage;
}

- (NSArray *)selectHomeImagesWithHomeType:(ATOMHomepageViewType)homeType {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString* homeTypeStr = homeType == ATOMHomepageViewTypeHot?@"hot":@"recent";
        NSString *stmt = @"select * from ATOMHomeImage where homePageType = ?";
        NSArray *param =  @[homeTypeStr];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMHomeImage *homeImage = [MTLFMDBAdapter modelOfClass:[ATOMHomeImage class] fromFMResultSet:rs error:NULL];
            [muArray addObject:homeImage];
        }
        [rs close];
    }];
    return [muArray copy];
}
- (NSArray *)selectHomeImages {
    __block NSMutableArray *muArray = [NSMutableArray array];
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *stmt = @"select * from ATOMHomeImage";
        FMResultSet *rs = [db executeQuery:stmt];
        while ([rs next]) {
            ATOMHomeImage *homeImage = [MTLFMDBAdapter modelOfClass:[ATOMHomeImage class] fromFMResultSet:rs error:NULL];
            [muArray addObject:homeImage];
        }
        [rs close];
    }];
    return [muArray copy];
}

- (BOOL)isExistHomeImage:(ATOMHomeImage *)homeImage {
    __block BOOL flag;
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"select * from ATOMHomeImage where imageID = ?";
        NSArray *param = @[@(homeImage.imageID)];
        FMResultSet *rs = [db executeQuery:stmt withArgumentsInArray:param];
        while ([rs next]) {
            ATOMHomeImage *homeImage = [MTLFMDBAdapter modelOfClass:[ATOMHomeImage class] fromFMResultSet:rs error:NULL];
            if (homeImage) {
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
- (void)clearHomeImages {
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *stmt = @"delete from ATOMHomeImage";
        BOOL flag = [db executeUpdate:stmt];
        if (flag) {
            NSLog(@"delete homeImage success");
        } else {
            NSLog(@"delete homeImage fail");
        }
    }];
}
- (void)clearHomeImagesWithHomeType:(NSString *)homeType {
    [[[self class] sharedFMQueue] inDatabase:^(FMDatabase *db) {
        NSString *stmt = @"delete from ATOMHomeImage where homePageType = ?";
        NSArray *param = @[homeType];
        BOOL flag = [db executeUpdate:stmt withArgumentsInArray:param];
        if (flag) {
            NSLog(@"delete homeImage ok");
        } else {
            NSLog(@"delete homeImage fail");
        }
    }];
}



















@end
