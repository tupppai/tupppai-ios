//
//  ATOMShowHomepage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDHomePageManager.h"
#import "DDSessionManager.h"
#import "PIEPageEntity.h"
#import "ATOMReplier.h"
#import "DDPageVM.h"
#import "PIEPageDAO.h"
#import "kfcHomeScrollView.h"
#import "PIEAskImageDao.h"
#import "PIEImageEntity.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface DDHomePageManager ()

@property (nonatomic, strong) PIEPageDAO *homeImageDAO;

@end

@implementation DDHomePageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)pullAskSource:(NSDictionary *)param block:(void (^)(NSMutableArray *))block {
    [DDService ddGetNewestAsk:param withBlock:^(NSArray *data) {
        if (data) {
            NSMutableArray *returnArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
                NSMutableArray* thumbArray = [NSMutableArray new];
                for (int i = 0; i<entity.askImageModelArray.count; i++) {
                    PIEImageEntity *entity2 = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:                    entity.askImageModelArray[i] error:NULL];
                    [thumbArray addObject:entity2];
                }
                entity.askImageModelArray = thumbArray;
                [returnArray addObject:entity];
            }
            if (block) {
                block(returnArray);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    }];
}
- (void)pullReplySource:(NSDictionary *)param block:(void (^)(NSMutableArray *))block {
    [DDService ddGetNewestReply:param withBlock:^(NSArray *data) {
        if (data) {
            NSMutableArray *returnArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
                NSMutableArray* thumbArray = [NSMutableArray new];
                for (int i = 0; i<entity.askImageModelArray.count; i++) {
                    PIEImageEntity *entity2 = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:                    entity.askImageModelArray[i] error:NULL];
                    [thumbArray addObject:entity2];
                }
                entity.askImageModelArray = thumbArray;
                [returnArray addObject:entity];
            }
            if (block) {
                block(returnArray);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    }];
}

- (void)saveHomeImagesInDB:(NSMutableArray *)homeImages {
    for (PIEPageEntity *homeImage in homeImages) {
        if ([self.homeImageDAO isExistHomeImage:homeImage]) {
            [self.homeImageDAO updateHomeImage:homeImage];
        } else {
            [self.homeImageDAO insertHomeImage:homeImage];
        }
        NSArray *imageEntities = homeImage.askImageModelArray;
        for ( PIEImageEntity * entity in imageEntities) {
            if ([PIEAskImageDao isExist:entity]) {
                [PIEAskImageDao update:entity];
            } else {
                [PIEAskImageDao insert:entity];
            }
        }
    }
}

- (NSArray *)getHomeImages {
    NSArray *array = [self.homeImageDAO selectHomeImages];
    for (PIEPageEntity *homeImage in array) {
        homeImage.askImageModelArray = [PIEAskImageDao selectByID:homeImage.ID];
    }
    return array;
}

- (NSArray *)getHomeImagesWithHomeType:(NSInteger)homeType {
    
//    NSArray *array = [self.homeImageDAO selectHomeImagesWithHomeType:homeType];
//    for (PIEPageEntity *homeImage in array) {
//        homeImage.askImageModelArray = [PIEAskImageDao selectByID:homeImage.ID];
//    }
    NSArray *array;
    return array;
}

- (void)clearHomePages {
    [self.homeImageDAO clearHomeImages];
}
- (void)clearHomePagesWithHomeType:(NSString *)homeType {
    [self.homeImageDAO clearHomeImagesWithHomeType:homeType];
}

- (PIEPageDAO *)homeImageDAO {
    if (!_homeImageDAO) {
        _homeImageDAO = [PIEPageDAO new];
    }
    return _homeImageDAO;
}




@end
