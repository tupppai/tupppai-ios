//
//  ATOMUploadImage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMImage;

@interface ATOMUploadImage : NSObject

//- (AFHTTPRequestOperation *)UploadImage:(NSData *)data withParam:(NSDictionary *)param andBlock:(void (^)(ATOMImage *imageInformation, NSError *error))block;
- (AFHTTPRequestOperation *)UploadImage:(NSData *)data WithBlock:(void (^)(ATOMImage *imageInformation, NSError *error))block;

@end
