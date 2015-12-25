//
//  PIENotificationManager.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationManager.h"
#import "PIEModelNotification.h"
#import "PIENotificationVM.h"
@implementation PIENotificationManager
+ (void)getNotifications:(NSDictionary *)param block:(void (^)(NSArray *))block {
    [DDService ddGetNotifications:param withBlock:^(id data) {
        if (data) {
            NSArray* dataArray = data;
            NSMutableArray* returnArray = [NSMutableArray new];
            for (NSDictionary* dic in dataArray) {
                PIEModelNotification* entity = [MTLJSONAdapter modelOfClass:[PIEModelNotification class] fromJSONDictionary:dic error:NULL];
                PIENotificationVM* vm = [[PIENotificationVM alloc]initWithEntity:entity];
//                if (vm.type != PIENotificationTypeLike && vm.type != PIENotificationTypeSystem) {
                    [returnArray addObject:vm];
//                }
            }
            if (dataArray.count > 0) {
                if (block) {block(returnArray);}
            }
            else {
                if (block) {block(nil);}
            }
        } else {
            if (block) {block(nil);}
        }
    }];
}


@end
