//
//  ATOMHeaderImageCropperView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/13.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHeaderImageCropperView.h"
#import "BJImageCropper.h"

@interface ATOMHeaderImageCropperView ()

@property (nonatomic, strong) UIView *transparencyView;

@end

@implementation ATOMHeaderImageCropperView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _transparencyView = [[UIView alloc] initWithFrame:self.bounds];
    _transparencyView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.7];
    [self addSubview:_transparencyView];
    
}

- (void)setOriginImage:(UIImage *)originImage {
    _originImage = originImage;
    CGFloat maxWith = SCREEN_WIDTH;
    CGFloat maxHeight = SCREEN_HEIGHT - NAV_HEIGHT;
    _imageCropperView = [[BJImageCropper alloc] initWithImage:_originImage andMaxSize:CGSizeMake(maxWith, maxHeight) andCropperType:CircleType];
    [_transparencyView addSubview:_imageCropperView];
}

































@end
