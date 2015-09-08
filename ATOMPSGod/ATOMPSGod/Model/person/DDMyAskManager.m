//
//  ATOMShowMyAsk.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/9/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDMyAskManager.h"
#import "ATOMAskPage.h"
#import "ATOMImageTipLabel.h"

@implementation DDMyAskManager
+ (void)getMyAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *dataArray))block {
    [DDService getMyAsk:param withBlock:^(NSArray *data) {
            NSMutableArray *resultArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                ATOMAskPage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMAskPage class] fromJSONDictionary:data[i] error:NULL];
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
            if (block) {  block(resultArray);}
    }];
}
@end
