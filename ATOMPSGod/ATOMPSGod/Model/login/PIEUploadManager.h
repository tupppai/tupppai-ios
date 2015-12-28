//
//  ATOMUploadImage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIEUploadModel.h"
@class PIEModelImageInfo;
@interface PIEUploadManager : NSObject
//@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy)  NSArray* toUploadInfoArray;
//@property (nonatomic, copy)  NSDictionary* uploadInfo;

@property (nonatomic, strong)  PIEUploadModel *model;

+ (PIEUploadManager *)shareManager;

- (NSURLSessionDataTask *)UploadImage:(NSData *)data WithBlock:(void (^)(PIEModelImageInfo *imageInformation, NSError *error))block;
- (void)upload:(void (^)(CGFloat percentage,BOOL success))block ;

@end
