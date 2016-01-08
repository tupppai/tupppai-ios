//
//  LeesinUploadManager.h
//  TUPAI
//
//  Created by chenpeiwei on 1/8/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LeesinUploadModel;

@interface LeesinUploadManager : NSObject
@property (nonatomic, strong)  LeesinUploadModel *model;
- (void)upload:(void (^)(CGFloat percentage,BOOL success))block ;
@end
