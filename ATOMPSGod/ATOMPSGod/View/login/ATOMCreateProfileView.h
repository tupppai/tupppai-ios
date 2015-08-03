//
//  ATOMCreateProfileView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMBaseView.h"

@interface ATOMCreateProfileView : ATOMBaseView

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UIView *sexView;
@property (nonatomic, strong) UIPickerView *sexPickerView;
@property (nonatomic, strong) UIPickerView *regionPickerView;

@property (nonatomic, strong) UIView *areaView;

@property (nonatomic, strong) UIView *sexPickerBackgroundView;
@property (nonatomic, strong) UIView *regionPickerBackgroundView;

@property (nonatomic, strong) UILabel *changeHeaderLabel;

@property (nonatomic, strong) UIButton *cancelPickerButton;
@property (nonatomic, strong) UIButton *confirmPickerButton;
@property (nonatomic, strong) UIButton *cancelRegionPickerButton;
@property (nonatomic, strong) UIButton *confirmRegionPickerButton;
@property (nonatomic, strong) UILabel *showSexLabel;
@property (nonatomic, strong) UILabel *showAreaLabel;
@property (nonatomic, strong) UILabel *protocolLabel;

- (void)showSexPickerView;
- (void)hideSexPickerView;

- (void)showRegionPickerView;
- (void)hideRegionPickerView;

- (NSInteger)tagOfCurrentSex;

@end
