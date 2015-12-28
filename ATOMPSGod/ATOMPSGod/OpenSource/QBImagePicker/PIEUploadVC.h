//
//  PIEUploadVC.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/10/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDBaseVC.h"
#import "PIEChannelViewModel.h"
#import "PIEUploadManager.h"

//typedef NS_ENUM(NSInteger, PIEUploadType) {
//    PIEUploadTypeAsk = 0,
//    PIEUploadTypeReply
//};

@interface PIEUploadVC : DDBaseVC
@property (nonatomic,copy) NSArray* assetsArray;
@property (nonatomic,assign) BOOL hideSecondView;
@end
