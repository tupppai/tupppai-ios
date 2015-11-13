//
//  ATOMCreateProfileView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMBaseView.h"
#import "HMSegmentedControl.h"

@interface PIECreateProfileView : ATOMBaseView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UIButton *protocolButton;

@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) HMSegmentedControl *sexSegment;
@property (nonatomic, strong) UIPickerView *regionPickerView;

@property (nonatomic, strong) UIView *areaView;

@property (nonatomic, strong) UIView *regionPickerBackgroundView;


@property (nonatomic, strong) UIButton *cancelPickerButton;
@property (nonatomic, strong) UIButton *confirmPickerButton;
@property (nonatomic, strong) UIButton *cancelRegionPickerButton;
@property (nonatomic, strong) UIButton *confirmRegionPickerButton;
@property (nonatomic, strong) UILabel *showAreaLabel;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, assign) BOOL genderIsMan;

- (void)showRegionPickerView;
- (void)hideRegionPickerView;

@end
