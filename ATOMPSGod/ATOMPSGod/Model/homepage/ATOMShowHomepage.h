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
- (AFHTTPRequestOperation *)toggleLike:(NSDictionary *)param withID:(NSInteger)imageID  withBlock:(void (^)(NSString *, NSError *))block;

- (void)saveHomeImagesInDB:(NSMutableArray *)homeImages;
- (NSArray *)getHomeImages;
- (NSArray *)getHomeImagesWithHomeType:(NSString *)homeType;

- (void)clearHomePages;
- (void)clearHomePagesWithHomeType:(NSString *)homeType;
@end
