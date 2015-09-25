//
//  ATOMShowHomepage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDHomePageManager : NSObject

- (void)pullSource:(NSDictionary *)param block:(void (^)(NSMutableArray *))block;
- (void)saveHomeImagesInDB:(NSMutableArray *)homeImages;
- (NSArray *)getHomeImages;
- (NSArray *)getHomeImagesWithHomeType:(PIEHomeType)homeType;
- (void)clearHomePages;
- (void)clearHomePagesWithHomeType:(NSString *)homeType;

@end
