//
//  ATOMSubmitUserInfomation.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMyReplyManager.h"
#import "ATOMUser.h"
#import "PIEPageEntity.h"
#import "ATOMImageTipLabel.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@implementation DDMyReplyManager

+ (void)getMyPhotos:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService getMyPhotos:param withBlock:^(NSArray *data) {
            NSMutableArray *returnArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
                [returnArray addObject:homeImage];
            }
            if (block) { block(returnArray); }
    }];
}



@end
