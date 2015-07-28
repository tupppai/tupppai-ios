//
//  ATOMUploadWorkView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUploadWorkView.h"
#import "ATOMImageCropper.h"
#import "BJImageCropper.h"

@interface ATOMUploadWorkView ()

@end

@implementation ATOMUploadWorkView

static CGFloat BottomHeight = 110;
static CGFloat buttonWidth = 30;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    self.backgroundColor = [UIColor whiteColor];
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _topView.backgroundColor = [UIColor colorWithHex:0xc6c6c6 andAlpha:0.8];
    [self addSubview:_topView];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(36, kPadding20, 40, 22)];
    [_cancelButton setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    [_topView addSubview:_cancelButton];
    
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 36 - 40, kPadding20, 40, 22)];
    [_confirmButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [_topView addSubview:_confirmButton];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - BottomHeight)];
//    _centerView.backgroundColor = [UIColor colorWithHex:0x333333];
    [self addSubview:_centerView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BottomHeight, SCREEN_WIDTH, BottomHeight)];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xc6c6c6 andAlpha:0.8];
//    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    [self createSubViewOfBottomView];
}

- (void)createSubViewOfBottomView {
    CGFloat interval = (SCREEN_WIDTH - 2 * buttonWidth - 2 * buttonWidth / 3 * 4 - 2 * kPadding30) / 3;
    _ThreeFourButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding30, kPadding30, buttonWidth, buttonWidth / 3 * 4)];
    [self setCommonButton:_ThreeFourButton WithTitle:@"3:4"];
    _OneOneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_ThreeFourButton.frame) + interval, kPadding30, buttonWidth, buttonWidth)];
    _OneOneButton.center = CGPointMake(_OneOneButton.center.x, _ThreeFourButton.center.y);
    [self setCommonButton:_OneOneButton WithTitle:@"1:1"];
    _FourThreeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_OneOneButton.frame) + interval, kPadding30, buttonWidth / 3 * 4, buttonWidth)];
    _FourThreeButton.center = CGPointMake(_FourThreeButton.center.x, _ThreeFourButton.center.y);
    [self setCommonButton:_FourThreeButton WithTitle:@"4:3"];
    _originButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_FourThreeButton.frame) + interval, kPadding30, buttonWidth / 3 * 4, buttonWidth)];
    _originButton.center = CGPointMake(_originButton.center.x, _ThreeFourButton.center.y);
    [self setCommonButton:_originButton WithTitle:@"原图"];
}

- (void)setCommonButton:(UIButton *)button WithTitle:(NSString *)title {
    button.layer.borderWidth = 3;
    button.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kFont14];
    [button setTitleColor:[UIColor colorWithHex:0xa1adb6] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0x74c3ff] forState:UIControlStateSelected];
    [_bottomView addSubview:button];
}

- (void)changeModeByOrder:(NSString *)order {
    
    CGFloat maxWidth = SCREEN_WIDTH;
    CGFloat maxHeight = SCREEN_HEIGHT - BottomHeight - NAV_HEIGHT;
    
    if ([order isEqualToString:@"3:4"]) {
        _ThreeFourButton.selected = YES;
        _OneOneButton.selected = NO;
        _FourThreeButton.selected = NO;
        _originButton.selected = NO;
        _ThreeFourButton.userInteractionEnabled = NO;
        _OneOneButton.userInteractionEnabled = YES;
        _FourThreeButton.userInteractionEnabled = YES;
        _originButton.userInteractionEnabled = YES;
        _ThreeFourButton.layer.borderColor = [UIColor colorWithHex:0x74c3ff].CGColor;
        _OneOneButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _FourThreeButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _originButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        [self clearCropperViewAndOriginView];
        _imageCropperView = [[BJImageCropper alloc] initWithImage:_originImage andMaxSize:CGSizeMake(maxWidth, maxHeight) andCropperType:ThreeFourType];
        [_centerView addSubview:_imageCropperView];
        
        
    } else if ([order isEqualToString:@"1:1"]) {
        _ThreeFourButton.selected = NO;
        _OneOneButton.selected = YES;
        _FourThreeButton.selected = NO;
        _originButton.selected = NO;
        _ThreeFourButton.userInteractionEnabled = YES;
        _OneOneButton.userInteractionEnabled = NO;
        _FourThreeButton.userInteractionEnabled = YES;
        _originButton.userInteractionEnabled = YES;
        _ThreeFourButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _OneOneButton.layer.borderColor = [UIColor colorWithHex:0x74c3ff].CGColor;
        _FourThreeButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _originButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        [self clearCropperViewAndOriginView];
        _imageCropperView = [[BJImageCropper alloc] initWithImage:_originImage andMaxSize:CGSizeMake(maxWidth, maxHeight) andCropperType:OneOneType];
        [_centerView addSubview:_imageCropperView];
    } else if ([order isEqualToString:@"4:3"]) {
        _ThreeFourButton.selected = NO;
        _OneOneButton.selected = NO;
        _FourThreeButton.selected = YES;
        _originButton.selected = NO;
        _ThreeFourButton.userInteractionEnabled = YES;
        _OneOneButton.userInteractionEnabled = YES;
        _FourThreeButton.userInteractionEnabled = NO;
        _originButton.userInteractionEnabled = YES;
        _ThreeFourButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _OneOneButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _FourThreeButton.layer.borderColor = [UIColor colorWithHex:0x74c3ff].CGColor;
        _originButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        [self clearCropperViewAndOriginView];
        _imageCropperView = [[BJImageCropper alloc] initWithImage:_originImage andMaxSize:CGSizeMake(maxWidth, maxHeight) andCropperType:FourThreeType];
        [_centerView addSubview:_imageCropperView];
    } else if ([order isEqualToString:@"origin"]) {
        _ThreeFourButton.selected = NO;
        _OneOneButton.selected = NO;
        _FourThreeButton.selected = NO;
        _originButton.selected = YES;
        _ThreeFourButton.userInteractionEnabled = YES;
        _OneOneButton.userInteractionEnabled = YES;
        _FourThreeButton.userInteractionEnabled = YES;
        _originButton.userInteractionEnabled = NO;
        _ThreeFourButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _OneOneButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _FourThreeButton.layer.borderColor = [UIColor colorWithHex:0xa1adb6].CGColor;
        _originButton.layer.borderColor = [UIColor colorWithHex:0x74c3ff].CGColor;
        [self clearCropperViewAndOriginView];
        _imageOriginView = [[UIImageView alloc] initWithFrame:[self calculateImageViewFrame]];
        _imageOriginView.image = _originImage;
        [_centerView addSubview:_imageOriginView];
    }
}

- (void)clearCropperViewAndOriginView {
    if (_imageOriginView) {
        [_imageOriginView removeFromSuperview];
        _imageOriginView = nil;
    }
    if (_imageCropperView) {
        [_imageCropperView removeFromSuperview];
        _imageCropperView = nil;
    }
}

- (CGRect)calculateImageViewFrame {
    
    CGFloat maxWith = SCREEN_WIDTH;
    CGFloat maxHeight = SCREEN_HEIGHT - BottomHeight - NAV_HEIGHT;
    CGFloat imageScale;
    CGPoint location;
    
    CGRect rect = CGRectMake(0, 0, _originImage.size.width, _originImage.size.height);
    if ((int)CGWidth(rect) <= maxWith && (int)CGHeight(rect) <= maxHeight) {
        location.x = (maxWith - _originImage.size.width) / 2;
        location.y = (maxHeight - _originImage.size.height) / 2;
        rect.origin = location;
        return rect;
    }
    
    imageScale = maxHeight / _originImage.size.height;
    rect = CGRectMake(0, 0, _originImage.size.width * imageScale, _originImage.size.height * imageScale);
    NSLog(@"%f %f",rect.size.width,rect.size.height);
    if ((int)CGWidth(rect) <= maxWith && (int)CGHeight(rect) <= maxHeight) {
        location.x = (maxWith - rect.size.width) / 2;
        location.y = (maxHeight - rect.size.height) / 2;
        rect.origin = location;
        return rect;
    }
    
    imageScale = maxWith / _originImage.size.width;
    rect = CGRectMake(0, 0, _originImage.size.width * imageScale, _originImage.size.height * imageScale);
    NSLog(@"%f %f",rect.size.width,rect.size.height);
    location.x = (maxWith - rect.size.width) / 2;
    location.y = (maxHeight - rect.size.height) / 2;
    rect.origin = location;
    return rect;

}










@end
