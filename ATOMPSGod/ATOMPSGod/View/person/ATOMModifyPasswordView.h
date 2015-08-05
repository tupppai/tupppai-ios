//
//  ATOMModifyPasswordView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMModifyPasswordView : ATOMBaseView

@property (nonatomic, strong) UITextField *oldPasswordTextField;
@property (nonatomic, strong) UITextField *modifyPasswordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *forgetPasswordButton;


@end
