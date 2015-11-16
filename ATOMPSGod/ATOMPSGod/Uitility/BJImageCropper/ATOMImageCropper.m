//
//  ATOMImageCropper.m
//  ATOMPSGod
//
//  Created by atom on 15/3/27.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMImageCropper.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <QuartzCore/QuartzCore.h>

@interface ATOMImageCropper () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL firstOverLimit;

@end

@implementation ATOMImageCropper

- (instancetype)initWithImage:(UIImage *)image AndFrame:(CGRect)frame AndImageCropperType:(ATOMImageCropperType)cropperType {
    self = [super init];
    if (self) {
        _imageCropperType = cropperType;
        _image = image;
        self.frame = frame;
        
        CGFloat cropperWidth = SCREEN_WIDTH, cropperHeigth;
        if (_imageCropperType == ThreeFourImageCropper) { //3:4
            cropperHeigth = cropperWidth / 3 * 4;
            _cropperRect = CGRectMake(0, (CGHeight(frame) - cropperHeigth) / 2, cropperWidth, cropperHeigth);
        } else if (_imageCropperType == OneOneImageCropper) { //1:1
            cropperHeigth = cropperWidth;
            _cropperRect = CGRectMake(0, (CGHeight(frame) - cropperHeigth) / 2, cropperWidth, cropperHeigth);
        } else { //4:3
            cropperHeigth = cropperWidth / 4 * 3;
            _cropperRect = CGRectMake(0, (CGHeight(frame) - cropperHeigth) / 2, cropperWidth, cropperHeigth);
        }
        _cropperView = [[UIView alloc] initWithFrame:_cropperRect];
        _cropperView.backgroundColor = [UIColor clearColor];
        _cropperView.layer.borderColor = [[UIColor colorWithHex:0x00adef] CGColor];
        _cropperView.layer.borderWidth = 1;
        
        CGSize imageViewSize = [self calclulateFrameWithImage:image InMaxSize:_cropperView.frame.size];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGWidth(frame) - imageViewSize.width) / 2, (CGHeight(frame) - imageViewSize.height) / 2, imageViewSize.width, imageViewSize.height)];
        _originalImageRect = _imageView.frame;
        _imageView.image = image;
        
        [self addSubview:_imageView];
        [self addSubview:_cropperView];
        [self setupGestureRecognizer];
        self.clipsToBounds = YES;
    }
    return self;
}

- (CGSize)calclulateFrameWithImage:(UIImage *)image InMaxSize:(CGSize)maxSize {
    CGSize noScale = CGSizeMake(image.size.width, image.size.height);
    if ((int)noScale.width <= maxSize.width && (int)noScale.height <= maxSize.height) {
        _imageScale = 1.f;
        return noScale;
    }
    
    CGSize scaled;
    _imageScale = maxSize.height / image.size.height;
    scaled = CGSizeMake(image.size.width * _imageScale, image.size.height * _imageScale);
    if ((int)scaled.width <= maxSize.width && (int)scaled.height <= maxSize.height) {
        return scaled;
    }
    
    _imageScale = maxSize.width / image.size.width;
    scaled = CGSizeMake(image.size.width * _imageScale, image.size.height * _imageScale);
    return scaled;
}

- (void)setupGestureRecognizer {
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomGesture:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)zoomGesture:(UIGestureRecognizer *)gesture {
    CGFloat factor = [(UIPinchGestureRecognizer *)gesture scale];
    static CGFloat lastScale = 1;
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        lastScale = 1;
    }
    if ([gesture state] == UIGestureRecognizerStateChanged || [gesture state] == UIGestureRecognizerStateEnded) {
        CGRect imageViewFame = _imageView.frame;
        CGFloat currentScale = [[self.imageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        CGFloat maxScale = 3.0;
        CGFloat newScale = 1 - (lastScale - factor);
        newScale = MIN(newScale, maxScale / currentScale);
        
        imageViewFame.size.width *= newScale;
        imageViewFame.size.height *= newScale;
        imageViewFame.origin.x = self.imageView.center.x - imageViewFame.size.width / 2;
        imageViewFame.origin.y = self.imageView.center.y - imageViewFame.size.height / 2;
        
        //zoom后距离中心偏移
        NSInteger offsetState = 0; //无偏移
        if (CGOriginX(imageViewFame) + CGWidth(imageViewFame) / 2 != _cropperView.center.x) { //x偏移
            offsetState = 1;
        }
        if (CGOriginY(imageViewFame) + CGHeight(imageViewFame) / 2 != _cropperView.center.y) { //y偏移
            offsetState = 2;
        }
        
        if (offsetState > 0) { //图片未居中
            if (lastScale - factor <= 0) { //图片正在扩大
                CGAffineTransform transform = CGAffineTransformScale(self.imageView.transform, newScale, newScale);
                self.imageView.transform = transform;
            } else { //图片正在缩小，矫正图片位置，使图片居中
                CGPoint newCenter = self.imageView.center;
                if (offsetState == 1) {
                    newCenter.x = _cropperView.center.x;
                } else if (offsetState == 2) {
                    newCenter.y = _cropperView.center.y;
                }
                [UIView animateWithDuration:0.5f animations:^{
                    self.imageView.center = newCenter;
                    [gesture reset];
                }];
            }
        } else { //图片已居中
            if (lastScale - factor < 0) {
                CGAffineTransform transform = CGAffineTransformScale(self.imageView.transform, newScale, newScale);
                self.imageView.transform = transform;
            } else {
                if (![self isImageViewInCropperView:imageViewFame]) {
                    CGAffineTransform transform = CGAffineTransformScale(self.imageView.transform, newScale, newScale);
                    self.imageView.transform = transform;
                } else {
                    if ([gesture state] == UIGestureRecognizerStateChanged) {
                        CGAffineTransform transform = CGAffineTransformScale(self.imageView.transform, newScale, newScale);
                        self.imageView.transform = transform;
                    } else if ([gesture state] == UIGestureRecognizerStateEnded){
                        [UIView animateWithDuration:0.5f animations:^{
                            self.imageView.frame = _originalImageRect;
                        }];
                    }
                }
            }
        }
        lastScale = factor;
    }
}

- (void)panGesture:(UIGestureRecognizer *)gesture {
    static CGPoint preLocation;
    CGPoint location = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        preLocation = location;
    }
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        CGFloat translateX = location.x - preLocation.x;
        CGFloat translateY = location.y - preLocation.y;
//        NSLog(@"translate (x = %f , y = %f)", translateX, translateY);
        CGPoint center = self.imageView.center;
        center.x += translateX;
        center.y += translateY;
        CGFloat imageViewMinX = center.x - CGWidth(_imageView.frame) / 2;
        CGFloat imageViewMaxX = center.x + CGWidth(_imageView.frame) / 2;
        CGFloat imageViewMinY = center.y - CGHeight(_imageView.frame) / 2;
        CGFloat imageViewMaxY = center.y + CGHeight(_imageView.frame) / 2;
        CGRect imageViewFrame = CGRectMake(imageViewMinX, imageViewMinY, CGWidth(_imageView.frame), CGHeight(_imageView.frame));
        BOOL flagWidth = NO;
        BOOL flagHeight = NO;
        //如果图片视图的宽度小于裁剪区域的宽度，不能左右移动
        if (CGWidth(_imageView.frame) <= CGWidth(_cropperRect)) {
            flagWidth = YES;
            if (!_firstOverLimit && gesture.state == UIGestureRecognizerStateChanged) {
                _firstOverLimit = YES;
            }
            if (gesture.state == UIGestureRecognizerStateEnded) {
                _firstOverLimit = NO;
                center.x = _cropperView.center.x;
            }
        }
        //如果图片视图的高度小于裁剪区域的高度，不能上下移动
        if (CGHeight(_imageView.frame) <= CGHeight(_cropperRect)) {
            flagHeight = YES;
            if (!_firstOverLimit && gesture.state == UIGestureRecognizerStateChanged) {
                _firstOverLimit = YES;
            }
            if (gesture.state == UIGestureRecognizerStateEnded) {
                center.y = _cropperView.center.y;
            }
        }
        //如果图片视图的宽度大于裁剪区域的宽度，且图片视图向右移动，则图片视图的左边界不能超过裁剪区域的左边界
        if (imageViewMinX > CGOriginX(_cropperRect) && !flagWidth) {
            if (!_firstOverLimit && gesture.state == UIGestureRecognizerStateChanged) {
                _firstOverLimit = YES;
            }
            if (gesture.state == UIGestureRecognizerStateEnded) {
                imageViewFrame.origin.x = CGOriginX(_cropperRect);
            }
        }
        //如果图片视图的高度大于裁剪区域的高度，且图片视图向下移动，则图片视图的上边界不能超过裁剪区域的上边界
        if (imageViewMinY > CGOriginY(_cropperRect) && !flagHeight) {
            if (!_firstOverLimit && gesture.state == UIGestureRecognizerStateChanged) {
                _firstOverLimit = YES;
            }
            if (gesture.state == UIGestureRecognizerStateEnded) {
                imageViewFrame.origin.y = CGOriginY(_cropperRect);
            }
        }
        //如果图片视图的宽度大于裁剪区域的宽度，且图片视图向左移动，则图片视图的右边界不能超过裁剪区域的右边界
        if (imageViewMaxX < CGRectGetMaxX(_cropperRect) && !flagWidth) {
            if (!_firstOverLimit && gesture.state == UIGestureRecognizerStateChanged) {
                _firstOverLimit = YES;
            }
            if (gesture.state == UIGestureRecognizerStateEnded) {
                imageViewFrame.origin.x = CGRectGetMaxX(_cropperRect) - CGWidth(_imageView.frame);
            }
        }
        //如果图片视图的高度大于裁剪区域的高度，且图片视图向上移动，则图片视图的下边界不能超过裁剪区域的下边界
        if (imageViewMaxY < CGRectGetMaxY(_cropperRect) && !flagHeight) {
            if (!_firstOverLimit && gesture.state == UIGestureRecognizerStateChanged) {
                _firstOverLimit = YES;
            }
            if (gesture.state == UIGestureRecognizerStateEnded) {
                imageViewFrame.origin.y = CGRectGetMaxY(_cropperRect) - CGHeight(_imageView.frame);
            }
        }
        //如果图片视图的宽高都大于裁剪区域的宽高，更新center
        if (!flagWidth && !flagHeight) {
            self.imageView.frame = imageViewFrame;
            center = self.imageView.center;
        }
        //如果图片视图只能上下移动，更新图片视图center的y值
        if (flagWidth && !flagHeight) {
            center.y = CGOriginY(imageViewFrame) + CGHeight(imageViewFrame) / 2;
        }
        //如果图片视图只能左右移动，更新图片视图center的x值
        if (flagHeight && !flagWidth) {
            center.x = CGOriginX(imageViewFrame) + CGWidth(imageViewFrame) / 2;
        }
        //更新图片视图的位置
        if (_firstOverLimit && [gesture state] == UIGestureRecognizerStateEnded) {
            _firstOverLimit = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.imageView.center = center;
            }];
            
        } else {
            self.imageView.center = center;
        }
        preLocation = location;
    }
}

- (BOOL)isImageViewInCropperView:(CGRect)imageRect {
    BOOL flag = YES;
    if (CGOriginX(imageRect) < CGOriginX(_cropperRect)) {
        flag = NO;
    }
    if (CGOriginY(imageRect) < CGOriginY(_cropperRect)) {
        flag = NO;
    }
    if (CGRectGetMaxX(imageRect) > CGRectGetMaxX(_cropperRect)) {
        flag = NO;
    }
    if (CGRectGetMaxY(imageRect) > CGRectGetMaxY(_cropperRect)) {
        flag = NO;
    }
    return flag;
}

- (UIImage *)getCroppedImage {
    CGFloat zoomScale = [[self.imageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    CGFloat originX = CGOriginX(_cropperRect) - CGOriginX(_imageView.frame);
    CGFloat originY = CGOriginY(_cropperRect) - CGOriginY(_imageView.frame);
    CGFloat width = CGWidth(_cropperRect);
    CGFloat height = CGHeight(_cropperRect);
    
    if (CGWidth(_imageView.frame) <= CGWidth(_cropperRect)) {
        originX = 0;
        width = CGWidth(_imageView.frame);
    }
    if (CGHeight(_imageView.frame) <= CGHeight(_cropperRect)) {
        originY = 0;
        height = CGHeight(_imageView.frame);
    }
    if (CGWidth(_imageView.frame) <= CGWidth(_cropperRect) && CGHeight(_imageView.frame) <= CGHeight(_cropperRect)) {
        zoomScale = 1;
    }
    
    CGRect rect = CGRectMake(originX / zoomScale / _imageScale, originY / zoomScale / _imageScale, width / zoomScale / _imageScale, height / zoomScale / _imageScale);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.image.size.width, self.image.size.height);
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [self.image drawInRect:drawRect];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}








































































@end
