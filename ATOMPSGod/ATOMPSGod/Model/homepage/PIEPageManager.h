//
//  ATOMShowHomepage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIELoveButton;
@interface PIEPageManager : NSObject

- (void)pullAskSource:(NSDictionary *)param block:(void (^)(NSMutableArray *))block;
- (void)pullReplySource:(NSDictionary *)param block:(void (^)(NSMutableArray *))block;
+ (void)getPageSource:(NSDictionary *)param block:(void (^)(PIEPageVM *))block;
//+(void)love:(PIELoveButton*)likeView viewModel:(PIEPageVM*)vm revert:(BOOL)revert ;
@end
