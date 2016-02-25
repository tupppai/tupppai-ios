//
//  PIEChannelTutorialImageModel.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBaseModel.h"

@interface PIEChannelTutorialImageModel : PIEBaseModel

@property (nonatomic, copy)  NSString  *imageURL;

@property (nonatomic, assign) NSInteger imageHeight;

@property (nonatomic, assign) NSInteger imageWidth;

@property (nonatomic, assign) CGFloat   imageRatio;


@end
