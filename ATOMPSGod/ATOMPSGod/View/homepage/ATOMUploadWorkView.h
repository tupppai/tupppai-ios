//
//  ATOMUploadWorkView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"
@class ATOMImageCropper;

@interface ATOMUploadWorkView : ATOMBaseView

@property (nonatomic, strong) ATOMImageCropper *imageCropperView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIButton *ThreeFourButton;
@property (nonatomic, strong) UIButton *OneOneButton;
@property (nonatomic, strong) UIButton *FourThreeButton;
@property (nonatomic, strong) UIButton *originButton;

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *cropperImage;

@property (nonatomic, strong) UIImageView *imageOriginView;

- (void)changeModeByOrder:(NSString *)order;

@end
