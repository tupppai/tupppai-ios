//
//  ATOMSubmitImageWithLabel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMImageTipLabel;

@interface DDTipLabelManager : NSObject

- (NSURLSessionDataTask *)uploadTipLabelForAsk:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *labelArray, NSInteger newImageID, NSError *error))block;
- (NSURLSessionDataTask *)uploadTipLabelForReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *labelArray, NSError *error))block;

@end
