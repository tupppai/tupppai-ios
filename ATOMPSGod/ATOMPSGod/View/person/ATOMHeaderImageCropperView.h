//
//  ATOMHeaderImageCropperView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/13.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
@class BJImageCropper;

@interface ATOMHeaderImageCropperView : ATOMBaseView

@property (nonatomic, strong) BJImageCropper *imageCropperView;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *cropperImage;

@end
