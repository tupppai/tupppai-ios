//
//  PIEBindCellphoneViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/8/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBindCellphoneViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "PIEFurtherRegistrationView.h"

/* Variables */
@interface PIEBindCellphoneViewController ()

@property (nonatomic, strong) UIView      *furtherRegistrationView;
@property (nonatomic, strong) UITextField *cellphoneNumberTextField;
@property (nonatomic, strong) UITextField *verificationCodeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton    *nextStepButton;
@property (nonatomic, strong) UIButton    *countdownButton;

@property (nonatomic, strong)
RACDisposable *hasRegisteredNetworkRequestDisposable;

@end

@implementation PIEBindCellphoneViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];

    [self setupHasRegisteredNetworkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI setting-up
- (void)setupUI
{
    UIView *furtherRegistrationView = ({
        PIEFurtherRegistrationView *view =
        [[PIEFurtherRegistrationView alloc] init];
        
        view.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.view).with.offset(87);
            make.left.equalTo(self.view).with.offset(22);
            make.right.equalTo(self.view).with.offset(-22);
            make.height.mas_equalTo(247);
        }];
        view;
    });
    
    self.furtherRegistrationView = furtherRegistrationView;
    
    UIButton *dismissViewControllerButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:
         [UIImage imageNamed:@"pie_furtherRegistration_dismissViewController"]
                          forState:UIControlStateNormal];
        [furtherRegistrationView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(19, 19));
            make.centerX.equalTo(furtherRegistrationView.mas_right);
            make.centerY.equalTo(furtherRegistrationView.mas_top);
        }];
        
        [button sizeToFit];
        
        button;
    });

    @weakify(self);
    [[dismissViewControllerButton
     rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }];

    UIImageView *welcomeImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.image = [UIImage imageNamed:@"pie_furtherRegistration_welcome"];
        
        [furtherRegistrationView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 22));
            make.centerX.equalTo(furtherRegistrationView);
            make.top.equalTo(furtherRegistrationView.mas_top).with.offset(25);
        }];
        imageView;
    });
    
    UILabel *promptLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.text = @"请绑定手机号";
        label.font = [UIFont lightTupaiFontOfSize:13];
        label.textColor = [UIColor colorWithHex:0x848484];
        
        [furtherRegistrationView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(furtherRegistrationView);
            make.top.equalTo(welcomeImageView.mas_bottom).with.offset(11);
        }];
        
        label;
    });
    
    UITextField *cellphoneTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        
        textField.font = [UIFont lightTupaiFontOfSize:13];
        textField.textColor = [UIColor blackColor];
        textField.placeholder = @"手机号";
        textField.borderStyle = UITextBorderStyleLine;
        
        [furtherRegistrationView addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(furtherRegistrationView).with.offset(35);
            make.right.equalTo(furtherRegistrationView).with.offset(-35);
            make.top.equalTo(promptLabel.mas_bottom).with.offset(25);
            make.height.mas_equalTo(48);
        }];
        textField;
    });
    self.cellphoneNumberTextField = cellphoneTextField;
    
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
    
    
    UITextField *verificationTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        
        textField.font = [UIFont lightTupaiFontOfSize:13];
        textField.textColor = [UIColor blackColor];
        textField.placeholder = @"验证码";
        textField.borderStyle = UITextBorderStyleLine;
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = countdownButton;
        
        [furtherRegistrationView addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(furtherRegistrationView).with.offset(35);
            make.right.equalTo(furtherRegistrationView).with.offset(-35);
            make.top.equalTo(cellphoneTextField.mas_bottom).with.offset(12);
            make.height.mas_equalTo(48);
        }];
        
        
        textField;
    });
    verificationTextField.hidden   = YES;
    self.verificationCodeTextField = verificationTextField;
    
    
    UITextField *passwordTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        
        
        textField.font = [UIFont lightTupaiFontOfSize:13];
        textField.textColor = [UIColor blackColor];
        textField.placeholder = @"设置密码";
        textField.borderStyle = UITextBorderStyleLine;
        
        [furtherRegistrationView addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(furtherRegistrationView).with.offset(35);
            make.right.equalTo(furtherRegistrationView).with.offset(-35);
            make.top.equalTo(verificationTextField.mas_bottom).with.offset(12);
            make.height.mas_equalTo(48);
        }];
        
        textField;
    });
    passwordTextField.hidden = YES;
    self.passwordTextField   = passwordTextField;
    
    UIButton *nextStepButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setBackgroundImage:[UIImage imageNamed:@"launchViewControllerButtonBackground"]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"launchViewControllerButtonBackground_highlighted"]
                          forState:UIControlStateHighlighted];
        
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:13];
        
        [furtherRegistrationView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellphoneTextField);
            make.right.equalTo(cellphoneTextField);
            make.height.equalTo(cellphoneTextField);
            make.top.equalTo(cellphoneTextField.mas_bottom).with.offset(13);
        }];
        
        button;
    });
    self.nextStepButton = nextStepButton;
 
    
    
    
    
    // setup countdown button RAC-binding, to be refactored
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
         @([self.cellphoneNumberTextField.text integerValue]);
         [DDBaseService GET:params
                        url:@"account/requestAuthCode"
                      block:^(id responseObject) {
                          // do nothing
                      }];
         return countdownSignal;
     }];
}
#pragma mark - UI transforming
/** 第三方登录的用户之前已经注册了手机号，现在重新绑定 */
- (void)updateUIForRebindingCellphoneNumber
{

    
    [self.furtherRegistrationView
     mas_updateConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(321);
    }];
    
    @weakify(self);
    [self.nextStepButton mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.top.equalTo(self.cellphoneNumberTextField.mas_bottom).with.offset(12 + CGRectGetHeight(self.cellphoneNumberTextField.frame) + 27);
    }];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.furtherRegistrationView layoutIfNeeded];
                         self.verificationCodeTextField.hidden = NO;
                         
                     }];
}

/** 为第三方用户注册一个全新的账号 */
- (void)updateUIForRegisteringNewUser
{
    [self.furtherRegistrationView
     mas_updateConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(381);
     }];
    
    @weakify(self);
    [self.nextStepButton mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.top.equalTo(self.cellphoneNumberTextField.mas_bottom).with.offset(2 * (12 + CGRectGetHeight(self.cellphoneNumberTextField.frame)) + 27);
    }];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.furtherRegistrationView layoutIfNeeded];
                         self.verificationCodeTextField.hidden = NO;
                         self.passwordTextField.hidden = NO;
                     }];
}

#pragma mark - Network request setup
- (void)setupHasRegisteredNetworkRequest
{
    @weakify(self);
    self.hasRegisteredNetworkRequestDisposable =
    [[self.nextStepButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if ([self.cellphoneNumberTextField.text isMobileNumber] == NO) {
             [Hud error:@"手机格式不正确"];
         }
         else{
             // send network request: account/hasRegistered

             NSMutableDictionary *params = [NSMutableDictionary dictionary];
             
             params[@"phone"] = self.cellphoneNumberTextField.text;
             [Hud activity:@"验证手机中..."];
             
             [DDBaseService GET:params
                            url:URL_ACHasRegistered
                          block:^(id responseObject) {
                              [Hud dismiss];
                              
                              if (responseObject != nil) {
                                  // we have the correct response
                                  
                                  NSDictionary *dataDict = responseObject[@"data"];
                                  BOOL hasRegistered = [dataDict[@"has_registered"] boolValue];
                                  
                                  if (hasRegistered) {
                                      [self.hasRegisteredNetworkRequestDisposable
                                       dispose];
                                      [self updateUIForRebindingCellphoneNumber];
                                      
                                      [[self.nextStepButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                                          
                                          [self sendRebindingCellphoneRequest];
                                          
                                      }];
                                      
                                  }else{
                                      [self.hasRegisteredNetworkRequestDisposable
                                       dispose];
                                      [self updateUIForRegisteringNewUser];
                                      
                                      [[self.nextStepButton
                                       rac_signalForControlEvents:
                                       UIControlEventTouchUpInside]
                                       subscribeNext:^(id x) {
                                           [self sendRegisterNewUserRequest];
                                           
                                      }];
                                      
                                  }
                              }
                              
                          }];
         }
     }];
}


- (void)sendRebindingCellphoneRequest
{
    [Hud text:@"该手机号码已注册，准备重新绑定手机号"];
    
    
    if ([self.cellphoneNumberTextField.text isMobileNumber] == NO) {
        [Hud error:@"手机号码格式不对"];
    }else {
        /*
         account/register, POST, (mobile, code, openid)
         
         */
        
        NSMutableDictionary<NSString *, NSString *>
        *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = self.cellphoneNumberTextField.text;
        params[@"code"]   = self.verificationCodeTextField.text;
        NSString *openid  =
        [[NSUserDefaults standardUserDefaults] objectForKey:PIETouristOpenIdKey];
        params[@"openid"] = openid;
        [DDBaseService POST:params url:URL_ACRegister
                      block:^(id responseObject) {
                          responseObject;
                          
                          // if succeed in registering: switch to mainVC and store user info into sandbox
                          
                          //    // Finally：完成临时用户转换成正式用户的转正过程，将删除掉本地的“临时身份证”，即openid
                          //    [[NSUserDefaults standardUserDefaults]
                          //     removeObjectForKey:PIETouristOpenIdKey];
                          
                          // if params error: prompt user with specific warning.
                      }];
    }
}

- (void)sendRegisterNewUserRequest
{
    [Hud text:@"该手机号码未注册，准备开始注册流程..."];
    
    /*
        account/register, POST, (mobile, code, openid, password)
    
     */
    
    if ([self.cellphoneNumberTextField.text isMobileNumber] == NO) {
        [Hud error:@"手机号码格式不对"];
    }else if ([self.passwordTextField.text isPassword] == NO){
        [Hud error:@"密码格式不对，可能是太短了"];
    }else {
        
        /*
         account/register, POST, (mobile, code, openid)
         
         */
        NSMutableDictionary<NSString *, NSString *>
        *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = self.cellphoneNumberTextField.text;
        params[@"code"]   = self.verificationCodeTextField.text;
        params[@"password"] = self.passwordTextField.text;
        NSString *openid  =
        [[NSUserDefaults standardUserDefaults] objectForKey:PIETouristOpenIdKey];
        params[@"openid"] = openid;
        [DDBaseService POST:params url:URL_ACRegister
                      block:^(id responseObject) {
                          responseObject;
                          
                          
                          // if succeed in registering: switch to mainVC and store user info into sandbox
                          
                          //    // Finally：完成临时用户转换成正式用户的转正过程，将删除掉本地的“临时身份证”，即openid
                          //    [[NSUserDefaults standardUserDefaults]
                          //     removeObjectForKey:PIETouristOpenIdKey];
                          
                          // if params error: prompt user with specific warning.
                      }];

    }
    
}
- (void)sendUnbindCellphoneRequest
{
    [DDBaseService POST:nil url:@"auth/unbind"
                  block:^(id responseObject) {
                      
                      NSString *openid =
                      [[NSUserDefaults standardUserDefaults] objectForKey:PIETouristOpenIdKey];
                      
                      NSString *prompt = [NSString stringWithFormat:@"目前的第三方登录用户的openId = %@ 已经解绑手机号",openid];
                      
                      [Hud text:prompt];
                  }];
}


@end
