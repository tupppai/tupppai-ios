//
//  ATOMShowProceeding.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDMyProceedingManager.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"

@implementation DDMyProceedingManager

+ (void)getMyProceeding:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *))block {
    [DDService getMyProceeding:param withBlock:^(NSArray *data) {
            NSMutableArray *resultArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:data[i] error:NULL];
                homeImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = data[i][@"labels"];
                if (labelDataArray.count) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                        tipLabel.imageID = homeImage.imageID;
                        [homeImage.tipLabelArray addObject:tipLabel];
                    }
                }
                [resultArray addObject:homeImage];
            }
            if (block) { block(resultArray); }
    }];
}

@end
