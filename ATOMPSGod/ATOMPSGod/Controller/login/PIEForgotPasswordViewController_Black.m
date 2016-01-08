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

/* Variables */
@interface PIEForgotPasswordViewController_Black ()

@property (nonatomic, strong) UITextField *cellPhoneTextField;

@property (nonatomic, strong) UIButton    *countdownButton;

@property (nonatomic, strong) UITextField *verificationCodeTextField;

@property (nonatomic, strong) UITextField *resetPasswordTextField;

@property (nonatomic, strong) UIButton    *resetPasswordAndLoginButton;

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
    UITextField *cellPhoneTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        
        textField.font = [UIFont lightTupaiFontOfSize:13];
        textField.textColor = [UIColor blackColor];
        textField.placeholder = @"手机号";
        textField.borderStyle = UITextBorderStyleLine;
        
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
    UIButton *countdownButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [button setTitle:@" 获取验证码" forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        
        // 自动设置size，并且textField的rightView会自动设置好frame，超方便！
        [button sizeToFit];
        
        button;
    });
    self.countdownButton = countdownButton;
    
    // -- 验证码
    UITextField *verificationCodeTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        
        textField.font          = [UIFont lightTupaiFontOfSize:13];
        textField.textColor     = [UIColor blackColor];
        textField.placeholder   = @"验证码";
        textField.borderStyle   = UITextBorderStyleLine;

        textField.rightViewMode = UITextFieldViewModeAlways;
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
    UITextField *resetPasswordTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        
        textField.font = [UIFont lightTupaiFontOfSize:13];
        textField.textColor = [UIColor blackColor];
        textField.placeholder = @"设置新密码";
        textField.borderStyle = UITextBorderStyleLine;
        
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
    UIButton *resetPasswordAndLoginButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setBackgroundImage:[UIImage imageNamed:@"launchViewControllerButtonBackground"]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"launchViewControllerButtonBackground_highlighted"]
                          forState:UIControlStateHighlighted];
        
        [button setTitle:@"确认并登陆" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:13];
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
    
    @weakify(self);
    [[resetPasswordAndLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [self sendResetPasswordRequest];
        
    }];
    
    
    // ## Step 1: 获取验证码->倒计时 + 发网络请求，一系列的信号处理
    
    // RAC-signal binding
    const NSInteger numberLimit   = 10;
    __block NSInteger numberCount = numberLimit;
    
    /*
     weak-strong dance!
     */
    RACSignal *countdownSignal =
    [[[[RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]]
       startWith:@"Let's GO!"]
      take:numberLimit + 1]
     doNext:^(id x) {
         @strongify(self);
         
         /*
          WARNING: 第一个信号是@“Let's GO!”，接下来的信号才是NSDate
          */
         
         /*
          Side-effects warning!
          每次send 'Next'， 就果断地就地修改状态，即使不惜在信号中`掺杂`了副作用！
          */
         if (numberCount == 0) {
             [self.countdownButton setTitle:@"重新发送" forState:UIControlStateNormal];
             self.countdownButton.enabled = YES;
             [self.countdownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             
             // set to default value
             numberCount = numberLimit;
         }else{
             
             NSString *countdownString = [NSString stringWithFormat:@"%ld秒后重发", numberCount];
             
             [self.countdownButton setTitle:countdownString
                                   forState:UIControlStateNormal];
             [self.countdownButton setTitleColor:[UIColor lightGrayColor]
                                        forState:UIControlStateNormal];
             numberCount --;
             
             self.countdownButton.enabled = NO;
         }}];
    self.countdownButton.rac_command =
    [[RACCommand alloc]
     initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self);
         
         // send network request here.
         
         NSMutableDictionary *params =
         [NSMutableDictionary dictionary];
         params[@"phone"] =
         @([self.cellPhoneTextField.text integerValue]);
         [DDBaseService GET:params
                        url:@"account/requestAuthCode"
                      block:^(id responseObject) {
                          // do nothing
                      }];
         return countdownSignal;
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
