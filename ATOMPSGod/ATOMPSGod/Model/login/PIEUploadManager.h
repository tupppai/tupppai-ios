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
@property (nonatomic, strong)  PIEUploadModel *model;

- (void)resetModel;
- (instancetype)initWithShareModel;
+ (PIEUploadManager *)shareManager;
+ (PIEUploadModel *)shareModel;
- (void)upload:(void (^)(CGFloat percentage,BOOL success))block ;
- (NSURLSessionDataTask *)UploadImage:(NSData *)data WithBlock:(void (^)(PIEModelImageInfo *imageInformation, NSError *error))block;

@end
