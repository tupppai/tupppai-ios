//
//  BJImageCropper.h
//  CropTest
//
//  Created by Barrett Jacobsen on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ATOMCustomCropperView;

//#define IMAGE_CROPPER_OUTSIDE_STILL_TOUCHABLE 40.0f
#define IMAGE_CROPPER_INSIDE_STILL_EDGE 20.0f

#define IMAGE_CROPPER_OUTSIDE_STILL_TOUCHABLE 0
//#define IMAGE_CROPPER_INSIDE_STILL_EDGE 0

#ifndef __has_feature
// not LLVM Compiler
#define __has_feature(x) 0
#endif

#if __has_feature(objc_arc)
#define ARC
#endif


//atom new add
typedef enum {
    ThreeFourType = 0,
    OneOneType,
    FourThreeType,
    CircleType
} ATOMCropperViewTYPE;

@interface BJImageCropper : UIView {
    
    UIImageView *imageView;
    
//    UIView *cropView;
    ATOMCustomCropperView *cropView;
    
    UIView *topView;
    UIView *bottomView;
    UIView *leftView;
    UIView *rightView;

    UIView *topLeftView;
    UIView *topRightView;
    UIView *bottomLeftView;
    UIView *bottomRightView;

    CGFloat imageScale;
    
    BOOL isPanning;
    NSInteger currentTouches;
    CGPoint panTouch;
    CGFloat scaleDistance;
    UIView *currentDragView; // Weak reference
    ATOMCropperViewTYPE _cropperViewType;
}

@property (nonatomic, assign) CGRect crop;
@property (nonatomic, readonly) CGRect unscaledCrop;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain, readonly) UIImageView* imageView;

- (id)initWithImage:(UIImage*)newImage andMaxSize:(CGSize)maxSize andCropperType:(ATOMCropperViewTYPE)cropperViewType;

- (UIImage*) getCroppedImage;

@end
