//
//  ATOMImageCropper.h
//  ATOMPSGod
//
//  Created by atom on 15/3/27.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

typedef enum {
    ThreeFourImageCropper = 0,
    OneOneImageCropper,
    FourThreeImageCropper
} ATOMImageCropperType;

#import <UIKit/UIKit.h>

@interface ATOMImageCropper : UIView

@property (nonatomic, assign) CGFloat imageScale;
@property (nonatomic, strong) UIView *cropperView;
@property (nonatomic, assign) ATOMImageCropperType imageCropperType;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect cropperRect;
@property (nonatomic, assign) CGRect originalImageRect;

- (instancetype)initWithImage:(UIImage *)image AndFrame:(CGRect)frame AndImageCropperType:(ATOMImageCropperType)cropperType;
- (UIImage *)getCroppedImage;

@end
