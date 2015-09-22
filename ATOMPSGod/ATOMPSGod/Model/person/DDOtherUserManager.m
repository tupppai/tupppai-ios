//
//  ATOMShowOtherUser.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDOtherUserManager.h"
#import "PIEPageEntity.h"
#import "ATOMImageTipLabel.h"
#import "ATOMUser.h"
@implementation DDOtherUserManager

+ (void)getOtherUserInfo:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *askReturnArray,NSMutableArray *replyReturnArray,ATOMUser *user))block {
    [DDService ddGetOtherUserInfo:param withBlock:^(NSDictionary *data, NSArray *askArray, NSArray *replyArray) {
        {
            NSMutableArray *askReturnArray = [NSMutableArray array];
            NSMutableArray *replyReturnArray = [NSMutableArray array];
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:NULL];
            for (int i = 0; i < askArray.count; i++) {
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:askArray[i] error:NULL];
//                homeImage.tipLabelArray = [NSMutableArray array];
//                NSArray *labelDataArray = askArray[i][@"labels"];
//                if (labelDataArray.count) {
//                    for (int j = 0; j < labelDataArray.count; j++) {
//                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
//                        tipLabel.imageID = homeImage.imageID;
//                        [homeImage.tipLabelArray addObject:tipLabel];
//                    }
//                }
                [askReturnArray addObject:homeImage];
            }
            
            for (int i = 0; i < replyArray.count; i++) {
                PIEPageEntity *homeImage = [MTLJSONAdapter modelOfClass:[PIEPageEntity class] fromJSONDictionary:replyArray[i] error:NULL];
//                homeImage.tipLabelArray = [NSMutableArray array];
//                NSArray *labelDataArray = replyArray[i][@"labels"];
//                if (labelDataArray.count) {
//                    for (int j = 0; j < labelDataArray.count; j++) {
//                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
//                        tipLabel.imageID = homeImage.imageID;
//                        [homeImage.tipLabelArray addObject:tipLabel];
//                    }
//                }
                [replyReturnArray addObject:homeImage];
            }
            
            if (block) {
                block(askReturnArray,replyReturnArray,user);
            }
        }
    }];
}

@end
