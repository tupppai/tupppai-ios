//
//  ATOMShowOtherUser.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowOtherUser.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMUser.h"
@implementation ATOMShowOtherUser

+ (NSURLSessionDataTask *)ShowOtherUser:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *askReturnArray,NSMutableArray *replyReturnArray,ATOMUser *user, NSError *))block {
    NSLog(@"showOtherUser param %@",param);
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] GET:@"user/others" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"showOtherUser responseObject %@",responseObject);
        
        int ret = [(NSString*)[responseObject objectForKey:@"ret"] intValue];
        if (ret == 1 ) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            if (data) {
                NSMutableArray *askReturnArray = [NSMutableArray array];
                NSMutableArray *replyReturnArray = [NSMutableArray array];
                NSArray *askDataArray = [data objectForKey:@"asks"];
                NSArray *replyDataArray = [data objectForKey:@"replies"];
                
                        ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:[ responseObject objectForKey:@"data"] error:NULL];
                        for (int i = 0; i < askDataArray.count; i++) {
                            ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:askDataArray[i] error:NULL];
                            homeImage.tipLabelArray = [NSMutableArray array];
                            NSArray *labelDataArray = askDataArray[i][@"labels"];
                            if (labelDataArray.count) {
                                for (int j = 0; j < labelDataArray.count; j++) {
                                    ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                                    tipLabel.imageID = homeImage.imageID;
                                    [homeImage.tipLabelArray addObject:tipLabel];
                                }
                            }
                            [askReturnArray addObject:homeImage];
                        }
                        
                        for (int i = 0; i < replyDataArray.count; i++) {
                            ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:replyDataArray[i] error:NULL];
                            homeImage.tipLabelArray = [NSMutableArray array];
                            NSArray *labelDataArray = replyDataArray[i][@"labels"];
                            if (labelDataArray.count) {
                                for (int j = 0; j < labelDataArray.count; j++) {
                                    ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                                    tipLabel.imageID = homeImage.imageID;
                                    [homeImage.tipLabelArray addObject:tipLabel];
                                }
                            }
                            [replyReturnArray addObject:homeImage];
                        }

                        if (block) {
                            block(askReturnArray,replyReturnArray,user, nil);
                        }
            }  else {
                if (block) {
                    block(nil, nil,nil,nil);
                }
            }

        } else {
            if (block) {
                block(nil, nil,nil,nil);
            }
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil,nil,nil,error);
        }
    }];
}

@end
