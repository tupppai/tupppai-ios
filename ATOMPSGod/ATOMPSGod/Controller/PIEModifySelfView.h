//
//  PIEModifySelf.h
//  TUPAI
//
//  Created by chenpeiwei on 10/10/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface PIEModifySelfView : UIView
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) HMSegmentedControl *sexSegment;
@property (nonatomic, strong) UIPickerView *regionPickerView;

@property (nonatomic, strong) UIView *areaView;

@property (nonatomic, strong) UIView *regionPickerBackgroundView;

@property (nonatomic, strong) UIButton *cancelRegionPickerButton;
@property (nonatomic, strong) UIButton *confirmRegionPickerButton;
@property (nonatomic, strong) UILabel *showAreaLabel;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, assign) BOOL genderIsMan;

- (void)showRegionPickerView;
- (void)hideRegionPickerView;
@end
