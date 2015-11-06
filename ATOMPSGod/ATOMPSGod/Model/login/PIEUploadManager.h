//
//  ATOMUploadImage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIEEntityImage;

@interface PIEUploadManager : NSObject
@property (nonatomic, copy) NSString *type;

- (NSURLSessionDataTask *)UploadImage:(NSData *)data WithBlock:(void (^)(PIEEntityImage *imageInformation, NSError *error))block;
- (void)upload:(void (^)(CGFloat percentage,BOOL success))block ;

@end
