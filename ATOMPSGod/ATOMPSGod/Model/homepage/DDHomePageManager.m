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


- (NSURLSessionDataTask *)getHomepage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"ask/index" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret != 1) {
            block(nil, nil);
        } else {
            NSMutableArray *homepageArray = [NSMutableArray array];
            NSArray *imageDataArray = [ responseObject objectForKey:@"data"];
            for (int i = 0; i < imageDataArray.count; i++) {
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:imageDataArray[i] error:NULL];
                homeImage.homePageType = (NSString*)[param[@"type"] copy];
                
                NSMutableArray* array = [NSMutableArray new];
                for (int i = 0; i<homeImage.askImageModelArray.count; i++) {
                    PIEImageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:homeImage.askImageModelArray[i] error:NULL];
                    [array addObject:entity];
                }
                homeImage.askImageModelArray = array;
                [homepageArray addObject:homeImage];
            }
            if (block) {
                block(homepageArray, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
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
        homeImage.askImageModelArray = [PIEAskImageDao selectByID:homeImage.imageID];
    }
    return array;
}

- (NSArray *)getHomeImagesWithHomeType:(PIEHomeType)homeType {
    
    NSArray *array = [self.homeImageDAO selectHomeImagesWithHomeType:homeType];
    for (PIEPageEntity *homeImage in array) {
        homeImage.askImageModelArray = [PIEAskImageDao selectByID:homeImage.imageID];
    }
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
