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
#import "PIELaunchNextStepButton.h"
#import "PIELaunchTextField.h"
#import "PIEVerificationCodeCountdownButton.h"
#import "AppDelegate.h"


/* Variables */
@interface PIEBindCellphoneViewController ()

@property (nonatomic, strong) UIView             *furtherRegistrationView;
@property (nonatomic, strong) PIELaunchTextField *cellphoneNumberTextField;
@property (nonatomic, strong) PIELaunchTextField *verificationCodeTextField;
@property (nonatomic, strong) PIELaunchTextField *passwordTextField;
@property (nonatomic, strong) PIELaunchNextStepButton
                                          *nextStepButton;
@property (nonatomic, strong) PIEVerificationCodeCountdownButton
                                           *countdownButton;

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
    
    [self setupNetworkRequestNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NetworkErrorCall"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NetworkShowInfoCall"
                                                  object:nil];
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
    welcomeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnWelcomeImageView =
    [[UITapGestureRecognizer alloc] init];
    [welcomeImageView addGestureRecognizer:tapOnWelcomeImageView];
    
    [[tapOnWelcomeImageView rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self sendUnbindCellphoneRequest];
    }];
    
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
    
    PIELaunchTextField *cellphoneTextField = ({
        PIELaunchTextField *textField = [[PIELaunchTextField alloc] init];
        
        textField.placeholder  = @"手机号";
        textField.keyboardType = UIKeyboardTypePhonePad;
        
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
    
    PIEVerificationCodeCountdownButton
        *countdownButton = ({
        PIEVerificationCodeCountdownButton *button =
            [[PIEVerificationCodeCountdownButton alloc] init];
            
        button;
    });
    countdownButton.fetchVerificationCodeBlock =
    ^void(void){
        @strongify(self);
        NSMutableDictionary *params =
        [NSMutableDictionary dictionary];
        
        params[@"phone"] =
        @([self.cellphoneNumberTextField.text integerValue]);
        [DDBaseService GET:params
                       url:@"account/requestAuthCode"
                     block:^(id responseObject) {

                         // do nothing, 或者以后还要判断短信是否发送成功?
                     }];
    };
    
    self.countdownButton = countdownButton;
    
    
    PIELaunchTextField *verificationTextField = ({
        PIELaunchTextField *textField = [[PIELaunchTextField alloc] init];
     
        textField.placeholder = @"验证码";
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
    
    
    PIELaunchTextField *passwordTextField = ({
        PIELaunchTextField *textField = [[PIELaunchTextField alloc] init];
        
        
        textField.placeholder = @"设置密码";
        
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
    
    PIELaunchNextStepButton *nextStepButton = ({
        PIELaunchNextStepButton *button = [[PIELaunchNextStepButton alloc] init];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        
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
                                  BOOL hasRegistered     = [dataDict[@"has_registered"] boolValue];

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
    }else if (self.verificationCodeTextField.text.length == 0){
        [Hud error:@"验证码不能为空"];
    }
    else {
        
        /*
         account/register, POST, (mobile, code, openid, type)
         
         */
        NSMutableDictionary<NSString *, NSString *>
        *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = self.cellphoneNumberTextField.text;
        params[@"code"]   = self.verificationCodeTextField.text;
        NSString *openid  =
        [[NSUserDefaults standardUserDefaults] objectForKey:PIETouristOpenIdKey];
        params[@"openid"] = openid;
        NSString *type    =
        [[NSUserDefaults standardUserDefaults] objectForKey:PIETouristLoginTypeStringKey];
        params[@"type"]   = type;
        
        [Hud activity:@"绑定中..."];
        
        @weakify(self);
        [DDBaseService POST:params url:URL_ACRegister
                      block:^(id responseObject) {
                          @strongify(self);
                          
                          [Hud dismiss];
                          
                          if (responseObject == nil) {
                              
//                              [Hud error:@"绑定失败: 网络异常或者是验证码错误"];
                              
                          }else{
                              
                              NSDictionary *dataDict = responseObject[@"data"];
                              
                              PIEUserModel *user =
                              [MTLJSONAdapter modelOfClass:[PIEUserModel class]
                                        fromJSONDictionary:dataDict error:nil];
                              // 用返回的数据为user模型设置token
                              user.token = responseObject[@"token"];
                              
                              // 将用户信息存入沙盒
                              [DDUserManager updateCurrentUserFromUser:user];
                              
                              // 完成临时用户转换成正式用户的转正过程，将删除掉本地的“临时身份证”，即openid
                              [[NSUserDefaults standardUserDefaults]
                               removeObjectForKey:PIETouristOpenIdKey];
                              
                              //完成临时用户转换成正式用户的转正过程，将删除本地记录的第三方登录的类型
                              [[NSUserDefaults standardUserDefaults]
                               removeObjectForKey:PIETouristLoginTypeStringKey];
                              
                              // update sandbox
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              
                              // dismiss current model view controller
                              [self dismissViewControllerAnimated:YES
                                                       completion:nil];
                              
                              // 跳转到主控制器
                              [[AppDelegate APP] switchToMainTabbarController];
                          }
                      }];
    }
}

- (void)sendRegisterNewUserRequest
{
    [Hud text:@"该手机号码未注册，准备开始注册流程..."];
    /*
        account/register, POST, (mobile, code, openid, password, type)
    
     */
    if ([self.cellphoneNumberTextField.text isMobileNumber] == NO) {
        [Hud error:@"手机号码格式不对"];
    }else if ([self.passwordTextField.text isPassword] == NO){
        [Hud error:@"密码格式不对，可能是太短了"];
    }else if (self.verificationCodeTextField.text.length == 0){
        [Hud error:@"验证码不能为空"];
    }
    else {
        /*
         account/register, POST, (mobile, code, password, openid, type)
         
         */
        NSMutableDictionary<NSString *, NSString *>
        *params             = [NSMutableDictionary dictionary];
        params[@"mobile"]   = self.cellphoneNumberTextField.text;
        params[@"code"]     = self.verificationCodeTextField.text;
        params[@"password"] = self.passwordTextField.text;
        NSString *openid    =
        [[NSUserDefaults standardUserDefaults] objectForKey:PIETouristOpenIdKey];
        params[@"openid"]   = openid;
        NSString *type      =
        [[NSUserDefaults standardUserDefaults] objectForKey:PIETouristLoginTypeStringKey];
        params[@"type"]     = type;
        
        [Hud activity:@"第三方用户转正注册新用户中..."];
        [DDBaseService POST:params url:URL_ACRegister
                      block:^(id responseObject) {
                          [Hud dismiss];
                          
                          if (responseObject == nil) {
//                              [Hud error:@"第三方用户转正失败: 网络异常或者是验证码错误"];
                          }else{
                              NSDictionary *dataDict = responseObject[@"data"];
                              
                              PIEUserModel *user =
                              [MTLJSONAdapter modelOfClass:[PIEUserModel class]
                                        fromJSONDictionary:dataDict error:nil];
                              // 用返回的数据为user模型设置token
                              user.token = responseObject[@"token"];
                              
                              // 将用户信息存入沙盒
                              [DDUserManager updateCurrentUserFromUser:user];
                              
                              // 完成临时用户转换成正式用户的转正过程，将删除掉本地的“临时身份证”，即openid
                              [[NSUserDefaults standardUserDefaults]
                               removeObjectForKey:PIETouristOpenIdKey];
                              
                              //完成临时用户转换成正式用户的转正过程，将删除本地记录的第三方登录的类型
                              [[NSUserDefaults standardUserDefaults]
                               removeObjectForKey:PIETouristLoginTypeStringKey];
                            
                              // update sandbox
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              
                              // dismiss current model view controller
                              [self dismissViewControllerAnimated:YES
                                                       completion:nil];
                              
                              // 跳转到主控制器
                              [[AppDelegate APP] switchToMainTabbarController];
                          }
                      }];

    }
    
}

- (void)sendUnbindCellphoneRequest
{
    
    /*
        auth/unbind, POST, (type = weixin, weibo or qq)
     */
    [Hud activity:@"测试版本的隐藏功能：解绑当下第三方用户的openid和之前绑定的手机号码..."];
    [DDBaseService POST:nil url:@"auth/unbind"
                  block:^(id responseObject) {
                      [Hud dismiss];
                      
                      NSString *openid =
                      [[NSUserDefaults standardUserDefaults] objectForKey:PIETouristOpenIdKey];
                      NSString *prompt =
                      [NSString
                       stringWithFormat:@"openId = %@ 已经解绑手机号",openid];
                      
                      [Hud text:prompt];
                  }];
}

/*
 
    P.S: 以下实践就是因为Objc不支持多继承的缘故，以前放在DDLoginBaseViewController中的监听方法得特地再复制粘贴一次在这里，因为本VC是继承与喵神的VVBlurViewController的（或者，需要面向接口编程？has-a）
 */
#pragma mark - Notification related
- (void)setupNetworkRequestNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(errorOccuredRET) name:@"NetworkErrorCall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showInfoRET:) name:@"NetworkShowInfoCall" object:nil];
}

- (void)errorOccuredRET
{
    [Hud text:@"网路好像有点问题～" inView:self.view];
}

- (void)showInfoRET:(NSNotification *)notification
{
    NSString* info = [[notification userInfo] valueForKey:@"info"];
    NSString *prompt = [NSString stringWithFormat:@"ret != 1, %@", info];
    [Hud text:prompt inView:self.view];
}


@end
