//
//  ATOMShowHomepage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDHomePageManager : NSObject

- (NSURLSessionDataTask *)getHomepage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *homepageArray, NSError *error))block;
- (void)saveHomeImagesInDB:(NSMutableArray *)homeImages;
- (NSArray *)getHomeImages;
- (NSArray *)getHomeImagesWithHomeType:(PIEHomeType)homeType;
- (void)clearHomePages;
- (void)clearHomePagesWithHomeType:(NSString *)homeType;

@end
