//
//  ATOMUploadWorkView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUploadWorkView.h"
#import "BJImageCropper.h"

@interface ATOMUploadWorkView ()

@end

@implementation ATOMUploadWorkView

static const int BOTTOMHEIGHT = 36;
static const int CENTERHEIGHT = 40;
static const int padding = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    self.backgroundColor = [UIColor whiteColor];
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOMHEIGHT - CENTERHEIGHT - NAV_HEIGHT, SCREEN_WIDTH, CENTERHEIGHT)];
    _centerView.backgroundColor = [UIColor colorWithHex:0xf5f6f8];
    [self createSubViewOfCenterView];
    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_centerView.frame), SCREEN_WIDTH, BOTTOMHEIGHT)];
    _bottomLabel.backgroundColor = [UIColor whiteColor];
    _bottomLabel.text = @"点击以上按钮，调整到合适的尺寸";
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    [self addSubview:_centerView];
    [self addSubview:_bottomLabel];
}

- (void)createSubViewOfCenterView {
    
    CGFloat buttonInteval = (SCREEN_WIDTH - 4 * 60) / 5;
    
    
    _ThreeFourButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonInteval, 7.5, 60, 25)];
    _OneOneButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonInteval + CGRectGetMaxX(_ThreeFourButton.frame), 7.5, 60, 25)];
    _FourThreeButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonInteval + CGRectGetMaxX(_OneOneButton.frame), 7.5, 60, 25)];
    [_ThreeFourButton setTitle:@"3:4" forState:UIControlStateNormal];
    [_OneOneButton setTitle:@"1:1" forState:UIControlStateNormal];
    [_FourThreeButton setTitle:@"4:3" forState:UIControlStateNormal];
    [self setCommonButton:_ThreeFourButton WithNormalImage:[UIImage imageNamed:@"_scale34_choose_normal"] AndClickImage:[UIImage imageNamed:@"_scale34_choosen_pressed"]];
    [self setCommonButton:_OneOneButton WithNormalImage:[UIImage imageNamed:@"btn_11_normal"] AndClickImage:[UIImage imageNamed:@"btn_11_choosen"]];
    [self setCommonButton:_FourThreeButton WithNormalImage:[UIImage imageNamed:@"btn_43_normal"] AndClickImage:[UIImage imageNamed:@"btn_43_choosen"]];
    
    _originButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonInteval + CGRectGetMaxX(_FourThreeButton.frame), 7.5, 60, 25)];
    [_originButton setTitle:@"原图" forState:UIControlStateNormal];
//    [_originButton setTitleColor:[UIColor colorWithHex:0x565656] forState:UIControlStateNormal];
//    [_originButton setTitleColor:[UIColor colorWithHex:0x00aeef] forState:UIControlStateSelected];
    [self setCommonButton:_originButton WithNormalImage:nil AndClickImage:nil];
    [_centerView addSubview:_originButton];
    
}

- (void)setCommonButton:(UIButton *)button WithNormalImage:(UIImage *)image AndClickImage:(UIImage *)clickImage{
//    button.backgroundColor = [UIColor orangeColor];
    if (image != nil) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(3.5, padding / 2.0, 3.5, 0)];
        button.titleLabel.font = [UIFont systemFontOfSize:11.f];
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor colorWithHex:0xcdced0] CGColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:clickImage forState:UIControlStateSelected];
    [button setImageEdgeInsets:UIEdgeInsetsMake(3.5, 0, 3.5, 0)];
    [button setTitleColor:[UIColor colorWithHex:0x565656] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0x00aeef] forState:UIControlStateSelected];
    [_centerView addSubview:button];
}

- (void)changeModeByOrder:(NSString *)order {
    
    CGFloat maxWith = SCREEN_WIDTH;
    CGFloat maxHeight = SCREEN_HEIGHT - BOTTOMHEIGHT - CENTERHEIGHT - NAV_HEIGHT;
    
    if ([order isEqualToString:@"3:4"]) {
        _ThreeFourButton.selected = YES;
        _OneOneButton.selected = NO;
        _FourThreeButton.selected = NO;
        _originButton.selected = NO;
        _ThreeFourButton.userInteractionEnabled = NO;
        _OneOneButton.userInteractionEnabled = YES;
        _FourThreeButton.userInteractionEnabled = YES;
        _originButton.userInteractionEnabled = YES;
        [self clearCropperViewAndOriginView];
        _imageCropperView = [[BJImageCropper alloc] initWithImage:_originImage andMaxSize:CGSizeMake(maxWith, maxHeight) andCropperType:ThreeFourType];
        [self addSubview:_imageCropperView];
        
        
    } else if ([order isEqualToString:@"1:1"]) {
        _ThreeFourButton.selected = NO;
        _OneOneButton.selected = YES;
        _FourThreeButton.selected = NO;
        _originButton.selected = NO;
        _ThreeFourButton.userInteractionEnabled = YES;
        _OneOneButton.userInteractionEnabled = NO;
        _FourThreeButton.userInteractionEnabled = YES;
        _originButton.userInteractionEnabled = YES;
        [self clearCropperViewAndOriginView];
        _imageCropperView = [[BJImageCropper alloc] initWithImage:_originImage andMaxSize:CGSizeMake(maxWith, maxHeight) andCropperType:OneOneType];
        [self addSubview:_imageCropperView];
    } else if ([order isEqualToString:@"4:3"]) {
        _ThreeFourButton.selected = NO;
        _OneOneButton.selected = NO;
        _FourThreeButton.selected = YES;
        _originButton.selected = NO;
        _ThreeFourButton.userInteractionEnabled = YES;
        _OneOneButton.userInteractionEnabled = YES;
        _FourThreeButton.userInteractionEnabled = NO;
        _originButton.userInteractionEnabled = YES;
        [self clearCropperViewAndOriginView];
        _imageCropperView = [[BJImageCropper alloc] initWithImage:_originImage andMaxSize:CGSizeMake(maxWith, maxHeight) andCropperType:FourThreeType];
        [self addSubview:_imageCropperView];
    } else if ([order isEqualToString:@"origin"]) {
        _ThreeFourButton.selected = NO;
        _OneOneButton.selected = NO;
        _FourThreeButton.selected = NO;
        _originButton.selected = YES;
        _ThreeFourButton.userInteractionEnabled = YES;
        _OneOneButton.userInteractionEnabled = YES;
        _FourThreeButton.userInteractionEnabled = YES;
        _originButton.userInteractionEnabled = NO;
        [self clearCropperViewAndOriginView];
        _imageOriginView = [[UIImageView alloc] initWithFrame:[self calculateImageViewFrame]];
        _imageOriginView.image = _originImage;
        [self addSubview:_imageOriginView];
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
    CGFloat maxHeight = SCREEN_HEIGHT - BOTTOMHEIGHT - CENTERHEIGHT - NAV_HEIGHT;
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
