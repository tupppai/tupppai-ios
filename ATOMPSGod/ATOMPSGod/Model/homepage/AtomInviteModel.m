//
//  AtomInviteModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/24/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "AtomInviteModel.h"
#import "ATOMHTTPRequestOperationManager.h"

@implementation AtomInviteModel
- (AFHTTPRequestOperation *)showMasters:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"user/get_recommend_users" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"showMasters responseObject%@",responseObject);
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret != 1) {
            block(nil, nil);
        } else {
//            NSMutableArray *homepageArray = [NSMutableArray array];
//            NSArray *imageDataArray = responseObject[@"data"];
//            for (int i = 0; i < imageDataArray.count; i++) {
//                ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:imageDataArray[i] error:NULL];
//                homeImage.homePageType = (NSString*)[param[@"type"] copy];
//                homeImage.tipLabelArray = [NSMutableArray array];
//                NSArray *labelDataArray = imageDataArray[i][@"labels"];
//                if (labelDataArray.count) {
//                    for (int j = 0; j < labelDataArray.count; j++) {
//                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
//                        tipLabel.imageID = homeImage.imageID;
//                        [homeImage.tipLabelArray addObject:tipLabel];
//                    }
//                }
//                homeImage.replierArray = [NSMutableArray array];
//                NSArray *replierArray = imageDataArray[i][@"replyer"];
//                if (replierArray.count) {
//                    for (int j = 0; j < replierArray.count; j++) {
//                        ATOMReplier *replier = [MTLJSONAdapter modelOfClass:[ATOMReplier class] fromJSONDictionary:replierArray[j] error:NULL];
//                        replier.imageID = homeImage.imageID;
//                        [homeImage.replierArray addObject:replier];
//                    }
//                }
//                NSLog(@"homeImage %@ ",homeImage);
//                [homepageArray addObject:homeImage];
//            }
//            if (block) {
//                block(homepageArray, nil);
//            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Util TextHud:@"出现未知错误"];
        if (block) {
            block(nil, error);
        }
    }];
    
}
@end
