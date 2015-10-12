//
//  ATOMSubmitUserInfomation.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDPageManager.h"
#import "ATOMUser.h"
#import "PIEImageEntity.h"
#import "ATOMImageTipLabel.h"



@implementation DDPageManager

+ (void)getPhotos:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService getPhotos:param withBlock:^(NSArray *data) {
            NSMutableArray *returnArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
                [returnArray addObject:homeImage];
            }
            if (block) { block(returnArray); }
    }];
}

+ (void)getAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService getAsk:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
            [returnArray addObject:homeImage];
        }
        if (block) { block(returnArray); }
    }];
}

+ (void)getReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService getReply:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
            [returnArray addObject:homeImage];
        }
        if (block) { block(returnArray); }
    }];
}

+ (void)getCollection:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService ddGetCollection:param withBlock:^(NSArray* data) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
            [resultArray addObject:homeImage];
        }
        if (block) {
            block(resultArray);
        }
    }];
}

+ (void)getAskWithReplies:(NSDictionary *)param withBlock:(void (^)(NSArray *returnArray))block {
    [DDService ddGetAskWithReplies:param withBlock:^(NSArray *returnArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < returnArray.count; i++) {
            
            NSMutableArray * source = [NSMutableArray new];
            NSArray* askImageDic = [[returnArray objectAtIndex:i]objectForKey:@"ask_uploads"];
            NSMutableArray* askImageEntities = [NSMutableArray array];
            for (NSDictionary* dic in askImageDic) {
                PIEImageEntity* ie = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:dic error:NULL];
                [askImageEntities addObject:ie];
            }
            for (PIEImageEntity* ie in askImageEntities) {
                PIEPageEntity *askEntity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[returnArray objectAtIndex:i] error:NULL];
                askEntity.imageWidth = ie.width;
                askEntity.imageHeight = ie.height;
                askEntity.imageURL = ie.url;
                [source addObject:askEntity];
            }
            
            NSArray* repliesDic = [[returnArray objectAtIndex:i]objectForKey:@"replies"];
            for (NSDictionary* dic in repliesDic) {
                PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:dic error:NULL];
                [source addObject:entity];
            }
            [array addObject:source];
        }
        if (block) {
            if (array.count > 0) {
                block(array);
            } else {
                block (nil);
            }
        }
    }];
}

@end
