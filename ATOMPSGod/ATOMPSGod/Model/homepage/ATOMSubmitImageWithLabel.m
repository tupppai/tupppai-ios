//
//  ATOMSubmitImageWithLabel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMSubmitImageWithLabel.h"
#import "ATOMImageTipLabel.h"
#import "ATOMHTTPRequestOperationManager.h"
#import "ATOMImageTipLabelDAO.h"

@interface ATOMSubmitImageWithLabel ()



@end

@implementation ATOMSubmitImageWithLabel

- (NSURLSessionDataTask *)SubmitImageWithLabel:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSInteger, NSError *))block {
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:@"ask/save" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSLog(@"SubmitImageWithLabel responseObject %@",responseObject);
//        NSMutableArray *labelArray = [NSMutableArray array];
//        NSArray *dictArray = [ responseObject objectForKey:@"data"][@"labels"];
//        for (int i = 0; i < dictArray.count; i++) {
//            ATOMImageTipLabel *imageTipLabel = [ATOMImageTipLabel new];
//            imageTipLabel.labelID = [dictArray[i][@"id"] integerValue];
//            imageTipLabel.imageID = [[ responseObject objectForKey:@"data"][@"ask_id"] integerValue];
//            [labelArray addObject:imageTipLabel];
//        }
        NSInteger newImageID = [[ responseObject objectForKey:@"data"][@"ask_id"] integerValue];
        if (block) {
            block(nil, newImageID, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        if (block) {
            block(nil, 0, error);
        }
    }];
}

- (NSURLSessionDataTask *)SubmitWorkWithLabel:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *, NSError *))block {
    NSLog(@"保存作品SubmitWorkWithLabel");
    [[KShareManager mascotAnimator]show];
    return [[ATOMHTTPRequestOperationManager shareHTTPSessionManager] POST:@"reply/save" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [[KShareManager mascotAnimator]dismiss];
        NSInteger ret = [(NSString*)[ responseObject objectForKey:@"ret"] integerValue];
        if (ret == 1) {
            NSMutableArray *labelArray = [NSMutableArray array];
            NSArray* data = [ responseObject objectForKey:@"data"];
            if (data.count > 0) {
                NSArray *dictArray = [ responseObject objectForKey:@"data"][@"labels"];
                for (int i = 0; i < dictArray.count; i++) {
                    ATOMImageTipLabel *imageTipLabel = [ATOMImageTipLabel new];
                    imageTipLabel.labelID = [dictArray[i][@"id"] integerValue];
                    imageTipLabel.imageID = [[ responseObject objectForKey:@"data"][@"ask_id"] integerValue];
                    [labelArray addObject:imageTipLabel];
                }
                if (block) {
                    block(labelArray, nil);
                }
            }
        } else {
            if (block) {
                block(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[KShareManager mascotAnimator]dismiss];
        if (block) {
            block(nil, error);
        }
    }];
}





















@end
