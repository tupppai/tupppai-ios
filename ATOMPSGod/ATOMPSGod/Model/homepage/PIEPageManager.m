//
//  ATOMShowHomepage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEPageManager.h"
#import "DDSessionManager.h"

//#import "ATOMReplier.h"

#import "PIEPageDAO.h"
#import "PIENewScrollView.h"
//#import "PIEAskImageDao.h"
#import "PIEModelImage.h"
#import "PIELoveButton.h"

@interface PIEPageManager ()

@property (nonatomic, strong) PIEPageDAO *homeImageDAO;

@end

@implementation PIEPageManager

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
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
                [returnArray addObject:vm];
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
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
                [returnArray addObject:vm];
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

+ (void)getPageSource:(NSDictionary *)param block:(void (^)(PIEPageVM *))block {
    [DDBaseService GET:param url:@"thread/item" block:^(id responseObject) {
        PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:                    [responseObject objectForKey:@"data"] error:NULL];
        if (entity) {
            PIEPageVM* vm = [[PIEPageVM alloc]initWithPageEntity:entity];
            if (block) {
                block(vm);
            }
        } else {
            if (block) {
                block(nil);
            }
        }
    }];
}

/** Cell点击 － 点赞 */
+(void)love:(PIELoveButton*)likeView viewModel:(PIEPageVM*)vm revert:(BOOL)revert {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (revert) {
        [param setObject:@"0" forKey:@"status"];
    } else {
        [param setObject:@(likeView.status) forKey:@"num"];
    }
    
    if (revert) {
        [likeView revert];
    } else {
        [likeView increaseStatus];
    }
    
    [DDService loveReply:param ID:vm.ID withBlock:^(BOOL succeed) {
        if (succeed) {
            vm.lovedCount = likeView.status;
            vm.likeCount = likeView.numberString;
        } else {
            [likeView decreaseStatus];
        }
    }];
    
}

//
//- (void)saveHomeImagesInDB:(NSMutableArray *)homeImages {
//    for (PIEPageEntity *homeImage in homeImages) {
//        if ([self.homeImageDAO isExistHomeImage:homeImage]) {
//            [self.homeImageDAO updateHomeImage:homeImage];
//        } else {
//            [self.homeImageDAO insertHomeImage:homeImage];
//        }
//        NSArray *imageEntities = homeImage.models_image;
//        for ( PIEImageEntity * entity in imageEntities) {
//            if ([PIEAskImageDao isExist:entity]) {
//                [PIEAskImageDao update:entity];
//            } else {
//                [PIEAskImageDao insert:entity];
//            }
//        }
//    }
//}
//
//- (NSArray *)getHomeImages {
//    NSArray *array = [self.homeImageDAO selectHomeImages];
//    for (PIEPageEntity *homeImage in array) {
//        homeImage.models_image = [PIEAskImageDao selectByID:homeImage.ID];
//    }
//    return array;
//}
//
//- (NSArray *)getHomeImagesWithHomeType:(NSInteger)homeType {
//    
////    NSArray *array = [self.homeImageDAO selectHomeImagesWithHomeType:homeType];
////    for (PIEPageEntity *homeImage in array) {
////        homeImage.models_image = [PIEAskImageDao selectByID:homeImage.ID];
////    }
//    NSArray *array;
//    return array;
//}
//
//- (void)clearHomePages {
//    [self.homeImageDAO clearHomeImages];
//}
//- (void)clearHomePagesWithHomeType:(NSString *)homeType {
//    [self.homeImageDAO clearHomeImagesWithHomeType:homeType];
//}
//
//- (PIEPageDAO *)homeImageDAO {
//    if (!_homeImageDAO) {
//        _homeImageDAO = [PIEPageDAO new];
//    }
//    return _homeImageDAO;
//}




@end
