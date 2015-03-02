//
//  ATOMInputVerifyCodeView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMInputVerifyCodeView : ATOMBaseView

@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UIButton *sendVerifyCodeButton;
@property (nonatomic, assign) NSInteger lastSecond;

@end
