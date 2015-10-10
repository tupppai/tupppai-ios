//
//  ATOMInputVerifyCodeAndPasswordView.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/5/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMInputVerifyCodeAndPasswordView : ATOMBaseView
@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *sendVerifyCodeButton;
@property (nonatomic, assign) NSInteger lastSecond;
@end
