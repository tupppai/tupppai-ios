//
//  ATOMLoginView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMLoginView : ATOMBaseView

@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;

@property (nonatomic, strong) UIButton *weiboLoginButton;
@property (nonatomic, strong) UIButton *wechatLoginButton;

@end
