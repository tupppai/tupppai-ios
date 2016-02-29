//
//  LeesinUploadManager.h
//  TUPAI
//
//  Created by chenpeiwei on 1/8/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LeesinUploadModel;
@class PIEPageModel;

@interface LeesinUploadManager : NSObject
@property (nonatomic, strong)  LeesinUploadModel *model;
- (void)upload:(void (^)(CGFloat percentage,BOOL success))block ;


/** 专为教程频道设计，比upload:方法多回调了一个PIEPageModel,供后续shareView分享用 */
- (void)uploadHomework:(void(^)(CGFloat percentage, BOOL success,PIEPageModel *pageModel))block;

- (void)uploadMoment:(void (^)(CGFloat percentage, BOOL success))block;
@end
