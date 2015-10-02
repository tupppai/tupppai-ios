//
//  ATOMShowDetailOfHomePage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDHotDetailManager : NSObject

- (NSURLSessionDataTask *)fetchAllReply:(NSDictionary *)param ID:(NSInteger)replyID withBlock:(void (^)(NSMutableArray *askArray, NSMutableArray *replyArray))block;
//- (void)saveDetailImagesInDB:(NSMutableArray *)detailImages;
//- (NSArray *)getDetalImagesByImageID:(NSInteger)imageID;

@end
