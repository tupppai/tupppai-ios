//
//  ATOMShowAttention.m
//  ATOMPSGod
//
//  Created by atom on 15/5/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowAttention.h"
#import "DDSessionManager.h"
#import "ATOMReplier.h"
#import "ATOMComment.h"
#import "ATOMImageTipLabel.h"
#import "PIEEliteEntity.h"

@implementation ATOMShowAttention

- (NSURLSessionDataTask *)ShowAttention:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    return [[DDSessionManager shareHTTPSessionManager] GET:@"Thread/timeline" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret != 1) {
            block(nil, nil);
        } else {
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *imageDataArray = [ responseObject objectForKey:@"data"];

            for (int i = 0; i < imageDataArray.count; i++) {
                PIEEliteEntity *commonImage = [MTLJSONAdapter modelOfClass:[PIEEliteEntity class] fromJSONDictionary:imageDataArray[i] error:NULL];
                commonImage.hotCommentArray = [NSMutableArray array];
                NSArray *hotCommentDataArray = imageDataArray[i][@"hot_comments"];
                if (hotCommentDataArray.count) {
                    for (int j = 0; j < hotCommentDataArray.count; j++) {
                        ATOMComment *comment = [MTLJSONAdapter modelOfClass:[ATOMComment class] fromJSONDictionary:hotCommentDataArray[j] error:NULL];
                        comment.commentType = 1;
                        comment.detailID = commonImage.ID;
                        [commonImage.hotCommentArray addObject:comment];
                    }
                }
                commonImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = imageDataArray[i][@"labels"];
                if (labelDataArray.count) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                        tipLabel.imageID = commonImage.ID;
                        [commonImage.tipLabelArray addObject:tipLabel];
                    }
                }
                commonImage.replierArray = [NSMutableArray array];
                NSArray *replierArray = imageDataArray[i][@"replyer"];
                if (replierArray.count) {
                    for (int j = 0; j < replierArray.count; j++) {
                        ATOMReplier *replier = [MTLJSONAdapter modelOfClass:[ATOMReplier class] fromJSONDictionary:replierArray[j] error:NULL];
                        replier.imageID = commonImage.ID;
                        [commonImage.replierArray addObject:replier];
                    }
                }
                [resultArray addObject:commonImage];
            }
            if (block) {
                block(resultArray, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

















































@end
