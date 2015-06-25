//
//  ATOMShowAttention.m
//  ATOMPSGod
//
//  Created by atom on 15/5/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMShowAttention.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMReplier.h"
#import "ATOMComment.h"
#import "ATOMImageTipLabel.h"
#import "ATOMCommonImage.h"

@implementation ATOMShowAttention

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (AFHTTPRequestOperation *)ShowAttention:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager sharedRequestOperationManager] GET:@"user/fellowsDynamic" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"ShowAttention responseObject %@",responseObject);
        NSInteger ret = [(NSString*)responseObject[@"ret"] integerValue];
        if (ret != 1) {
            block(nil, nil);
        } else {
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *imageDataArray = responseObject[@"data"];

            for (int i = 0; i < imageDataArray.count; i++) {
                ATOMCommonImage *commonImage = [MTLJSONAdapter modelOfClass:[ATOMCommonImage class] fromJSONDictionary:imageDataArray[i] error:NULL];
                commonImage.hotCommentArray = [NSMutableArray array];
                NSArray *hotCommentDataArray = imageDataArray[i][@"hot_comments"];
                if (hotCommentDataArray.count) {
                    for (int j = 0; j < hotCommentDataArray.count; j++) {
                        ATOMComment *comment = [MTLJSONAdapter modelOfClass:[ATOMComment class] fromJSONDictionary:hotCommentDataArray[j] error:NULL];
                        comment.commentType = 1;
                        comment.detailID = commonImage.imageID;
                        [commonImage.hotCommentArray addObject:comment];
                    }
                }
                commonImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = imageDataArray[i][@"labels"];
                if (labelDataArray.count) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:labelDataArray[j] error:NULL];
                        tipLabel.imageID = commonImage.imageID;
                        [commonImage.tipLabelArray addObject:tipLabel];
                    }
                }
                commonImage.replierArray = [NSMutableArray array];
                NSArray *replierArray = imageDataArray[i][@"replyer"];
                if (replierArray.count) {
                    for (int j = 0; j < replierArray.count; j++) {
                        ATOMReplier *replier = [MTLJSONAdapter modelOfClass:[ATOMReplier class] fromJSONDictionary:replierArray[j] error:NULL];
                        replier.imageID = commonImage.imageID;
                        [commonImage.replierArray addObject:replier];
                    }
                }
                [resultArray addObject:commonImage];
            }
            if (block) {
                block(resultArray, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

















































@end
