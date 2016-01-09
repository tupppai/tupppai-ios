//
//  PIEForgotPasswordViewController_Black.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/7/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEForgotPasswordViewController_Black.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "AppDelegate.h"
#import "DDUserManager.h"
#import "DDBaseService.h"
#import "PIEUserModel.h"
#import "MTLJSONAdapter.h"
#import "PIELaunchTextField.h"
#import "PIELaunchNextStepButton.h"
#import "PIEVerificationCodeCountdownButton.h"

/* Variables */
@interface PIEForgotPasswordViewController_Black ()

@property (nonatomic, strong) PIELaunchTextField *cellPhoneTextField;

@property (nonatomic, strong) PIELaunchTextField *verificationCodeTextField;

@property (nonatomic, strong) PIELaunchTextField *resetPasswordTextField;

@property (nonatomic, strong) PIEVerificationCodeCountdownButton
                              *countdownButton;

@property (nonatomic, strong) PIELaunchNextStepButton
                                          *resetPasswordAndLoginButton;
@end

@implementation PIEForgotPasswordViewController_Black

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI setting-up
- (void)setupUI
{
    // basic UI setup
    
    // -- 手机号
    PIELaunchTextField *cellPhoneTextField = ({
        PIELaunchTextField *textField = [[PIELaunchTextField alloc] init];
        
        textField.placeholder = @"手机号";
        
        [self.view addSubview:textField];
        
        @weakify(self);
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.view.mas_top).with.offset(52);
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.height.mas_equalTo(48);
        }];
        
        textField;
    });
    self.cellPhoneTextField = cellPhoneTextField;
    
    
    // --- 倒计时的button
    PIEVerificationCodeCountdownButton *countdownButton = ({
        PIEVerificationCodeCountdownButton *button = [[PIEVerificationCodeCountdownButton alloc] init];
        button;
    });
    self.countdownButton = countdownButton;
    @weakify(self);
    countdownButton.fetchVerificationCodeBlock =
    ^void(void){
        @strongify(self);
        NSMutableDictionary *params =
        [NSMutableDictionary dictionary];
        
        params[@"phone"] =
        @([self.cellPhoneTextField.text integerValue]);
        [DDBaseService GET:params
                       url:@"account/requestAuthCode"
                     block:^(id responseObject) {
                         
                         // do nothing, 或者以后还要判断短信是否发送成功?
                     }];
    };
    
    // -- 验证码
    PIELaunchTextField *verificationCodeTextField = ({
        PIELaunchTextField *textField = [[PIELaunchTextField alloc] init];
        
        textField.placeholder   = @"验证码";

        textField.rightView     = countdownButton;
        
        [self.view addSubview:textField];
        
        CGFloat padding = 8;
        @weakify(self);
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(cellPhoneTextField.mas_bottom).with.offset(padding);
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.height.mas_equalTo(48);
        }];
        
        textField;
    });
    self.verificationCodeTextField = verificationCodeTextField;
    
    // -- 设置新密码
    PIELaunchTextField *resetPasswordTextField = ({
        PIELaunchTextField *textField = [[PIELaunchTextField alloc] init];
        
        textField.placeholder = @"设置新密码";
        
        [self.view addSubview:textField];
        
        CGFloat padding = 8;
        @weakify(self);
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(verificationCodeTextField.mas_bottom).with.offset(padding);
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.height.mas_equalTo(48);
        }];
        
        textField;
    });
    self.resetPasswordTextField = resetPasswordTextField;
    
    // -- 确认并登陆
    PIELaunchNextStepButton *resetPasswordAndLoginButton = ({
        PIELaunchNextStepButton *button =
        [[PIELaunchNextStepButton alloc] init];
        [button setTitle:@"确认并登陆" forState:UIControlStateNormal];
        [self.view addSubview:button];

        @weakify(self);
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(resetPasswordTextField.mas_bottom).with.offset(37);
            make.height.mas_equalTo(48);
        }];
        
        button;
    });
    self.resetPasswordAndLoginButton = resetPasswordAndLoginButton;
    
    [[resetPasswordAndLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self sendResetPasswordRequest];
    }];
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


#pragma mark - Network request
- (void)sendResetPasswordRequest
{
    // reset password and jump to the main controller
    
    [Hud text:@"Gonna send request to reset password"];
    
    if ([self.cellPhoneTextField.text isMobileNumber] == NO) {
        [Hud error:@"手机号码格式不对"];
    }else if ([self.resetPasswordTextField.text isPassword] == NO){
        [Hud error:@"密码格式不对"];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"]            = self.cellPhoneTextField.text;
        params[@"code"]             = self.verificationCodeTextField.text;
        params[@"new_pwd"]          = self.resetPasswordTextField.text;
        
        [Hud activity:@"修改秘密并登陆中..."];
        [DDBaseService POST:params
                        url:URL_ACResetPassword
                      block:^(id responseObject) {
                          
                          [Hud dismiss];
                          
                          if (responseObject == nil) {
                              [Hud error:@"修改秘密失败：网络问题或者是数据出错"];
                          }else{
                              // save user to sandbox
                              
                              PIEUserModel *user = [MTLJSONAdapter
                                                    modelOfClass:[PIEUserModel class]
                                                    fromJSONDictionary:responseObject[@"data"]
                                                    error:nil];
                              
                              user.token = responseObject[@"token"];
                              
                              [DDUserManager updateCurrentUserFromUser:user];
                              
                              
                              // switch to mainVC
                              [[AppDelegate APP] switchToMainTabbarController];
                              
                          }
                          
                      }];
    }
    
}

@end
