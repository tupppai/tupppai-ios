//
//  ATOMShowHomepage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ATOMShowHomepage : NSObject

- (AFHTTPRequestOperation *)ShowHomepage:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *homepageArray, NSError *error))block;
- (void)saveHomeImagesInDB:(NSMutableArray *)homeImages;
- (NSArray *)getHomeImages;
- (void)clearHomeImages;

@end
