//
//  ATOMSubmitUserInfomation.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMyReplyManager.h"
#import "ATOMUser.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@implementation DDMyReplyManager

+ (void)getMyReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDService getMyReply:param withBlock:^(NSArray *data) {
            NSMutableArray *returnArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
                homeImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = [[data objectAtIndex:i]objectForKey:@"labels"];
                if (labelDataArray.count > 0) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:[labelDataArray objectAtIndex:j] error:NULL];
                        tipLabel.imageID = homeImage.imageID;
                        [homeImage.tipLabelArray addObject:tipLabel];
                    }
                }
                [returnArray addObject:homeImage];
            }
            if (block) { block(returnArray); }
    }];
}



@end
