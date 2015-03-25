//
//  ATOMSubmitImageWithLabel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMImageTipLabel;

@interface ATOMSubmitImageWithLabel : NSObject

- (AFHTTPRequestOperation *)SubmitImageWithLabel:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *labelArray, NSError *error))block;
- (void)saveTipLabelInDB:(ATOMImageTipLabel *)tipLabel;


@end
