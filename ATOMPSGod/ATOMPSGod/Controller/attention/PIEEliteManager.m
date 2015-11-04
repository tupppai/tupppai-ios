//
//  PIEEliteManager.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteManager.h"
#import "PIECommentEntity.h"
#import "PIEImageEntity.h"
@implementation PIEEliteManager
+ (void)getMyFollow:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService getFollowPages:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:data[i] error:NULL];
            NSMutableArray* thumbArray = [NSMutableArray new];
            for (int i = 0; i<entity.thumbEntityArray.count; i++) {
                PIEImageEntity *entity2 = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:                    entity.thumbEntityArray[i] error:NULL];
                [thumbArray addObject:entity2];
            }
            entity.thumbEntityArray = thumbArray;
            [returnArray addObject:entity];
        }
        if (block) {
            block(returnArray);
        }
    }];
}


+ (void)getBannerSource:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDBaseService GET:param url:URL_UKGetBanner block:^(id responseObject) {
        NSMutableArray* retArray = [NSMutableArray array];
        for (NSDictionary* dic in [responseObject objectForKey:@"data"]) {
            PIEBannerViewModel* vm = [PIEBannerViewModel new];
            vm.ID = (NSInteger)[dic objectForKey:@"id"];
            vm.desc = [dic objectForKey:@"desc"];
            vm.url = [dic objectForKey:@"url"];
            vm.imageUrl = [dic objectForKey:@"large_pic"];
            vm.imageUrl_thumb = [dic objectForKey:@"small_pic"];
            [retArray addObject:vm];
        }
        if (block) {
            block(retArray);
        }
    }];
}
+ (void)getHotPages:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService getHotPages:param withBlock:^(NSArray *data) {
        NSMutableArray *returnArray = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            PIEPageEntity *entity = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
            if (entity) {
                NSMutableArray* thumbArray = [NSMutableArray new];
                for (int i = 0; i<entity.thumbEntityArray.count; i++) {
                    PIEImageEntity *entity2 = [MTLJSONAdapter modelOfClass:[PIEImageEntity class] fromJSONDictionary:                    entity.thumbEntityArray[i] error:NULL];
                    [thumbArray addObject:entity2];
                }
                entity.thumbEntityArray = thumbArray;
                
                NSMutableArray* commentEntityArray = [NSMutableArray new];

                for (int i = 0; i<entity.hotCommentEntityArray.count; i++) {
                    PIECommentEntity *commentEntity = [MTLJSONAdapter modelOfClass:[PIECommentEntity class] fromJSONDictionary:                    entity.hotCommentEntityArray[i] error:NULL];
                    [commentEntityArray addObject:commentEntity];
                }
                entity.hotCommentEntityArray = commentEntityArray;
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [returnArray addObject:vm];
            }
        }
        if (block) {
            if (returnArray.count > 0) {
                block(returnArray);
            } else {
                block(nil);
            }
        }
    }];
}


@end
