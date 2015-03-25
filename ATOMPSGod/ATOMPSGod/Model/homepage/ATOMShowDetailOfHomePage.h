//
//  ATOMShowDetailOfHomePage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMShowDetailOfHomePage : NSObject

- (AFHTTPRequestOperation *)ShowDetailOfHomePage:(NSDictionary *)param withImageID:(NSInteger)imageID withBlock:(void (^)(NSMutableArray *detailOfHomePageArray, NSError *error))block;
- (void)saveDetailImagesInDB:(NSMutableArray *)detailImages;
- (NSArray *)getDetalImagesByImageID:(NSInteger)imageID;

@end
