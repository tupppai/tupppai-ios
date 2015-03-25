//
//  ATOMCreateProfileView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMCreateProfileView : UIScrollView

@property (nonatomic, strong) UIImageView *topBackGroundImageView;
@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UIView *sexView;
@property (nonatomic, strong) UIPickerView *sexPickerView;
@property (nonatomic, strong) UIButton *cancelPickerButton;
@property (nonatomic, strong) UIButton *confirmPickerButton;
@property (nonatomic, strong) UILabel *showSexLabel;

- (void)showSexPickerView;
- (void)hideSexPickerView;
- (NSInteger)tagOfCurrentSex;

@end
