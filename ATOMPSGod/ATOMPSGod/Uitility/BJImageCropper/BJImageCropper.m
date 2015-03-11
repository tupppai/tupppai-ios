//
//  BJImageCropper.m
//  CropTest
//
//  Created by Barrett Jacobsen on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BJImageCropper.h"
#import <QuartzCore/QuartzCore.h>


@interface BJImageCropper ()


@end

@implementation BJImageCropper
@dynamic crop;
@dynamic image;
@dynamic unscaledCrop;
@synthesize imageView;

- (UIImage*)image {
    return imageView.image;
}

- (void)setImage:(UIImage *)image {
    imageView.image = image;
}

//constarin cropView inside Image
- (void)constrainCropToImage {
    CGRect frame = cropView.frame;
    
    if (CGRectEqualToRect(frame, CGRectZero)) return;
    
    BOOL change = NO;
    
    do {
        change = NO;
        
        if (CGOriginX(frame) < 0) {
            frame.origin.x = 0;
            change = YES;
        }
        
        if (CGWidth(frame) > CGWidth(cropView.superview.frame)) {
            frame.size.width = CGWidth(cropView.superview.frame);
            change = YES;
        }
        
        if (CGWidth(frame) < 20) {
            frame.size.width = 20;
            change = YES;
        }
        
        if (CGOriginX(frame) + CGWidth(frame) > CGWidth(cropView.superview.frame)) {
            frame.origin.x = CGWidth(cropView.superview.frame) - CGWidth(frame);
            change = YES;
        }
        
        if (CGOriginY(frame) < 0) {
            frame.origin.y = 0;
            change = YES;
        }
        
        if (CGHeight(frame) > CGHeight(cropView.superview.frame)) {
            frame.size.height = CGHeight(cropView.superview.frame);
            change = YES;
        }
        
        if (CGHeight(frame) < 20) {
            frame.size.height = 20;
            change = YES;
        }
        
        if (CGOriginY(frame) + CGHeight(frame) > CGHeight(cropView.superview.frame)) {
            frame.origin.y = CGHeight(cropView.superview.frame) - CGHeight(frame);
            change = YES;
        }
    } while (change);
        
    cropView.frame = frame;
}

- (void)updateBounds {
    [self constrainCropToImage];
    
    CGRect frame = cropView.frame;
    CGFloat x = CGOriginX(frame);
    CGFloat y = CGOriginY(frame);
    CGFloat width = CGWidth(frame);
    CGFloat height = CGHeight(frame);
    
    CGFloat selfWidth = CGWidth(self.imageView.frame);
    CGFloat selfHeight = CGHeight(self.imageView.frame);
    
    //set 8 direction shadowView
    topView.frame = CGRectMake(x, -1, width + 1, y);
    bottomView.frame = CGRectMake(x, y + height, width, selfHeight - y - height);
    leftView.frame = CGRectMake(-1, y, x + 1, height);
    rightView.frame = CGRectMake(x + width, y, selfWidth - x - width, height);
    
    topLeftView.frame = CGRectMake(-1, -1, x + 1, y + 1);
    topRightView.frame = CGRectMake(x + width, -1, selfWidth - x - width, y + 1);
    bottomLeftView.frame = CGRectMake(-1, y + height, x + 1, selfHeight - y - height);
    bottomRightView.frame = CGRectMake(x + width, y + height, selfWidth - x - width, selfHeight - y - height);
    
    [self didChangeValueForKey:@"crop"];    
}

//return cropRect according to Original image
- (CGRect)crop {
    CGRect frame = cropView.frame;
    
    if (frame.origin.x <= 0)
        frame.origin.x = 0;

    if (frame.origin.y <= 0)
        frame.origin.y = 0;

    
    return CGRectMake(frame.origin.x / imageScale, frame.origin.y / imageScale, frame.size.width / imageScale, frame.size.height / imageScale);;
}

- (void)setCrop:(CGRect)crop {
    cropView.frame = CGRectMake(crop.origin.x * imageScale, crop.origin.y * imageScale, crop.size.width * imageScale, crop.size.height * imageScale);
    [self updateBounds];
}

//return cropRect according to Screen
- (CGRect)unscaledCrop {
    CGRect crop = self.crop;
    return CGRectMake(crop.origin.x * imageScale, crop.origin.y * imageScale, crop.size.width * imageScale, crop.size.height * imageScale);
}

//top bottom left right with alpha 0.5
- (UIView*)newEdgeView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    
    [self.imageView addSubview:view];
    
    return view;
}

//topleft topright bottomleft bottomright with alpha 0.75
- (UIView*)newCornerView {
    UIView *view = [self newEdgeView];
    view.alpha = 0.75;
    
    return view;
}


//initialize cropView with 3/4 size of imageView
+ (UIView *)initialCropViewForImageView:(UIImageView*)imageView WithCropperViewType:(ATOMCropperViewTYPE)cropperViewType{
    // 3/4 the size, centered
    
    CGRect max = imageView.bounds;
    CGFloat width;
    CGFloat height;

    // atom new add
    if (cropperViewType == OneOneType) {
        width = fminf(CGWidth(max), CGHeight(max));
        height = width;
    } else if (cropperViewType == ThreeFourType){
        height = CGHeight(max);
        width =  height / 4 * 3;
        if (width <= CGWidth(max) && height <= CGHeight(max)) {
            
        } else {
            width = CGWidth(max);
            height = width / 3 * 4;
        }
    } else {
        height = CGHeight(max);
        width =  height / 3 * 4;
        if (width <= CGWidth(max) && height <= CGHeight(max)) {
            
        } else {
            width = CGWidth(max);
            height = width / 4 * 3;
        }
    }
    
    CGFloat x      = (CGWidth(max) - width) / 2;
    CGFloat y      = (CGHeight(max) - height) / 2;
    
    UIView* cropView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    cropView.layer.borderColor = [[UIColor colorWithHex:0x00aeef] CGColor];
    cropView.layer.borderWidth = 2.0;
    cropView.backgroundColor = [UIColor clearColor];
    cropView.alpha = 0.4;   
    
#ifdef ARC
    return cropView;
#else
    return [cropView autorelease];
#endif
}

//add cropView and 8 direction view
- (void)setup {
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.backgroundColor = [UIColor clearColor];

    cropView = [BJImageCropper initialCropViewForImageView:imageView WithCropperViewType:_cropperViewType];
    [self.imageView addSubview:cropView];
    
    topView = [self newEdgeView];
    bottomView = [self newEdgeView];
    leftView = [self newEdgeView];
    rightView = [self newEdgeView];
    topLeftView = [self newCornerView];
    topRightView = [self newCornerView];
    bottomLeftView = [self newCornerView];
    bottomRightView = [self newCornerView];
   
#ifndef ARC
    [cropView retain];
#endif
    
    [self updateBounds];
}

//calculate imageScale
- (CGRect)calcFrameWithImage:(UIImage*)image andMaxSize:(CGSize)maxSize {

    CGPoint location;
    // if it already fits, return that
    CGRect noScale = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    if ((int)CGWidth(noScale) <= maxSize.width && (int)CGHeight(noScale) <= maxSize.height) {
        imageScale = 1.0;
        location.x = (maxSize.width - image.size.width) / 2;
        location.y = (maxSize.height - image.size.height) / 2;
        noScale.origin = location;
        return noScale;
    }
    
    CGRect scaled;
    
    // first, try scaling the height to fit
    imageScale = maxSize.height / image.size.height;
    scaled = CGRectMake(0.0, 0.0, image.size.width * imageScale, image.size.height * imageScale);
    if ((int)CGWidth(scaled) <= maxSize.width && (int)CGHeight(scaled) <= maxSize.height) {
        location.x = (maxSize.width - scaled.size.width) / 2;
        location.y = (maxSize.height - scaled.size.height) / 2;
        scaled.origin = location;
        return scaled;
    }
    
    // scale with width if that failed
    imageScale = maxSize.width / image.size.width;
    scaled = CGRectMake(0.0, 0.0, image.size.width * imageScale, image.size.height * imageScale);
    location.x = (maxSize.width - scaled.size.width) / 2;
    location.y = (maxSize.height - scaled.size.height) / 2;
    scaled.origin = location;
    return scaled;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        imageScale = 1.0;
        imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, IMAGE_CROPPER_OUTSIDE_STILL_TOUCHABLE, IMAGE_CROPPER_OUTSIDE_STILL_TOUCHABLE)];
        [self addSubview:imageView];
        [self setup];
    }
    
    return self;   
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imageScale = 1.0;
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        [self setup];
    }
    
    return self;   
}

//set imageViewFrame according to MaxSizex
- (id)initWithImage:(UIImage*)newImage andMaxSize:(CGSize)maxSize andCropperType:(ATOMCropperViewTYPE)cropperViewType{
    self = [super init];
    if (self) {
        self.frame = [self calcFrameWithImage:newImage andMaxSize:maxSize];
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = newImage;
        _cropperViewType = cropperViewType;
        [self addSubview:imageView];
        [self setup];
    }
    
    return self;   
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    
    return sqrt(x * x + y * y);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self willChangeValueForKey:@"crop"];
    NSSet *allTouches = [event allTouches];
    
    switch ([allTouches count]) {
        case 1: {            
            currentTouches = 1;
            isPanning = NO;
            CGFloat insetAmount = IMAGE_CROPPER_INSIDE_STILL_EDGE;
            
            CGPoint touch = [[allTouches anyObject] locationInView:self.imageView];
            //pan
            if (CGRectContainsPoint(CGRectInset(cropView.frame, insetAmount, insetAmount), touch)) {
                NSLog(@"isPanning1");
                isPanning = YES;
                panTouch = touch;
                return;
            }
            break;
        }
        case 2: {
            CGPoint touch1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self.imageView];
            CGPoint touch2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self.imageView];

            if ((currentTouches == 0 || currentTouches == 2) && CGRectContainsPoint(cropView.frame, touch1) && CGRectContainsPoint(cropView.frame, touch2)) {
                isPanning = YES;
                NSLog(@"isPanning2");
            }
            
            currentTouches = [allTouches count];
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self willChangeValueForKey:@"crop"];
    NSSet *allTouches = [event allTouches];
    
    switch ([allTouches count])
    {
        case 1: {
            if (isPanning) {
                CGPoint touchCurrent = [[allTouches anyObject] locationInView:self.imageView];
                CGFloat x = touchCurrent.x - panTouch.x;
                CGFloat y = touchCurrent.y - panTouch.y;
                
                cropView.center = CGPointMake(cropView.center.x + x, cropView.center.y + y);
                                
                panTouch = touchCurrent;
            }
            break;
        }
        case 2: {
            CGPoint touch1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self.imageView];
            CGPoint touch2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self.imageView];
            
            if (isPanning) {
                CGFloat distance = [self distanceBetweenTwoPoints:touch1 toPoint:touch2];
                
                if (scaleDistance != 0) {
                    CGFloat scale = 1.0f + ((distance-scaleDistance)/scaleDistance);
                    
                    CGPoint originalCenter = cropView.center;
                    CGSize originalSize = cropView.frame.size;
                    
                    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);

                    if (newSize.width >= 70 && newSize.height >= 70 && newSize.width <= CGWidth(cropView.superview.frame) && newSize.height <= CGHeight(cropView.superview.frame)) {
                        cropView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
                        cropView.center = originalCenter;
                    }
                }
                
                scaleDistance = distance;
            }
            break;
        }
    }
    
    [self updateBounds];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    scaleDistance = 0;
    currentTouches = [[event allTouches] count];
}

- (UIImage*) getCroppedImage {
    CGRect rect = self.crop;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image 
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.image.size.width, self.image.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [self.image drawInRect:drawRect];
    
    // grab image
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

#ifndef ARC

- (void)dealloc {
    [imageView release];
    
    [cropView release];
    
    [topView release];
    [bottomView release];
    [leftView release];
    [rightView release];
    
    [topLeftView release];
    [topRightView release];
    [bottomLeftView release];
    [bottomRightView release];
    
    [super dealloc];
}
#endif
@end
