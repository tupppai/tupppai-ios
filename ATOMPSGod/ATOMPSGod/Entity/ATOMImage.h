//
//  ATOMImage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMImage : ATOMBaseModel

@property (nonatomic, assign) NSInteger imageID;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *imageName;

@end
