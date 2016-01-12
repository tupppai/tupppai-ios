//
//  PIELaunchViewController_Black.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/4/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELaunchViewController_Black.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "DDBaseService.h"
#import "DDUserManager.h"
#import "AppDelegate.h"
#import "PIEUserModel.h"
#import "MTLJSONAdapter.h"
#import "PIEForgotPasswordViewController_Black.h"
#import "DDShareManager.h"
#import "PIELaunchTextField.h"
#import "PIELaunchNextStepButton.h"
#import "PIEVerificationCodeCountdownButton.h"
#import "UINavigationBar+Awesome.h"


/* Variables */
@interface PIELaunchViewController_Black ()

@property (nonatomic, weak  ) UIImageView   *logoImageView;
@property (nonatomic, strong)
PIEVerificationCodeCountdownButton *countdownButton;

@property (nonatomic, weak  ) PIELaunchTextField   *cellPhoneNumberTextField;
@property (nonatomic, weak  ) PIELaunchTextField   *verificationCodeTextField;
@property (nonatomic, weak  ) PIELaunchTextField   *passwordTextField;

@property (nonatomic, weak  ) PIELaunchNextStepButton
                                                   *nextStepButton;
@property (nonatomic, weak)   UIButton      *resetUiButton;
@property (nonatomic, weak  ) UIImageView   *launchSeparator;

@property (nonatomic, strong) MASConstraint *logoImageViewTopConstraint;
@property (nonatomic, strong) MASConstraint *nextStepButtonTopConstraint;

@property (nonatomic, strong) RACDisposable *hasRegisteredRequestDisposable;

@property (nonatomic, strong) RACDisposable *loginOrSignupRequestDisposable;


@end

@implementation PIELaunchViewController_Black
#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];

    [self setupHasRegisteredRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar
     lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar
//     lt_reset];

}

#pragma mark - UI setting-up
- (void)setupUI
{
    // Logo
    UIImageView *logoImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image        = [UIImage imageNamed:@"pie_logo"];
        imageView.contentMode  = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];

        @weakify(self);

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(CGSizeMake(43, 30));
            self.logoImageViewTopConstraint =
            make.top.equalTo(self.view).with.offset(33);
            make.centerX.equalTo(self.view);
        }];

        imageView;
    });
    self.logoImageView = logoImageView;

    // cellPhone number
    PIELaunchTextField *cellPhoneNumberTextField = ({
        PIELaunchTextField *textField = [[PIELaunchTextField alloc] init];


        textField.placeholder = @"手机号";


        [self.view addSubview:textField];

        @weakify(self);
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.height.mas_equalTo(48);
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.centerX.equalTo(self.view);
            make.top.equalTo(logoImageView.mas_bottom).with.offset(45);
        }];

        textField;

    });
    self.cellPhoneNumberTextField = cellPhoneNumberTextField;

    // password
    PIELaunchTextField *passwordTextField = ({
        PIELaunchTextField *textField = [[PIELaunchTextField alloc] init];

        
        textField.placeholder  = @"密码";

        [self.view addSubview:textField];

        @weakify(self);
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.height.mas_equalTo(48);
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.centerX.equalTo(self.view);
            make.top.equalTo(cellPhoneNumberTextField.mas_bottom).with.offset(8);
        }];
        textField;
        
    });
    passwordTextField.hidden = YES;
    self.passwordTextField = passwordTextField;

    // 倒计时button

    // 倒计时的button: 点击开始倒计时


    PIEVerificationCodeCountdownButton
        *countdownButton = ({
            PIEVerificationCodeCountdownButton
            *button = [[PIEVerificationCodeCountdownButton alloc] init];
            button;
    });
    
    @weakify(self);
    countdownButton.fetchVerificationCodeBlock =
    ^void(void){
        @strongify(self);
                 NSMutableDictionary *params =
                 [NSMutableDictionary dictionary];
        
                 params[@"phone"] =
                 @([self.cellPhoneNumberTextField.text integerValue]);
                 [DDBaseService GET:params
                                url:@"account/requestAuthCode"
                              block:^(id responseObject) {
        
                                  // do nothing, 或者以后还要判断短信是否发送成功?
                              }];
    };
    self.countdownButton = countdownButton;


    // 验证码TextField
    PIELaunchTextField *verificationCodeTextField = ({
        PIELaunchTextField *textField  = [[PIELaunchTextField alloc] init];

        textField.placeholder   = @"验证码";
        textField.rightView     = countdownButton;

        [self.view addSubview:textField];

        @weakify(self);
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.height.mas_equalTo(48);
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.centerX.equalTo(self.view);
            make.top.equalTo(passwordTextField.mas_bottom).with.offset(8);
        }];

        textField;
    });
    verificationCodeTextField.hidden = YES;
    self.verificationCodeTextField = verificationCodeTextField;


    // nextStep button
    PIELaunchNextStepButton *nextStepButton = ({
        PIELaunchNextStepButton *button =
        [[PIELaunchNextStepButton alloc] init];

        
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [self.view addSubview:button];

        @weakify(self);
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.centerX.equalTo(self.view.mas_centerX);
            self.nextStepButtonTopConstraint =
            make.top.equalTo(cellPhoneNumberTextField.mas_bottom).with.offset(19);
            make.height.mas_equalTo(48);
        }];

        button;
    });
    self.nextStepButton = nextStepButton;

    // Launch_separator("社交账号登录＋两条分割线")
    UIImageView *launchSeparator = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"lauch_separator"];
        imageView.contentMode = UIViewContentModeCenter;

        [self.view addSubview:imageView];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextStepButton.mas_bottom).with.offset(127);
            make.height.mas_equalTo(10);
            make.centerX.equalTo(self.view);
            make.left.equalTo(nextStepButton);
            make.right.equalTo(nextStepButton);
        }];


        imageView;
    });
    self.launchSeparator = launchSeparator;
    
    // resetUI button
    UIButton *resetUiButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setBackgroundImage:[UIImage imageNamed:@"pie_launch_resetUI"]
                          forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerX.equalTo(self.view);
            make.top.equalTo(nextStepButton.mas_bottom).with.offset(35);
        }];
        
        button;
    });
    resetUiButton.hidden = YES;
    
    [[resetUiButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        [self resetOriginUI];
    }];
    
    self.resetUiButton = resetUiButton;
    
    

    // Sina
    UIButton *sinaButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"pie_share_sina"]
                          forState:UIControlStateNormal];

        button.contentMode = UIViewContentModeScaleAspectFit;

        [self.view addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(23, 19));
            make.centerX.equalTo(self.view);
            make.top.equalTo(launchSeparator.mas_bottom).with.offset(22);

        }];

        button;
    });
    [sinaButton addTarget:self
                   action:@selector(sinaWeiboLogin)
         forControlEvents:UIControlEventTouchUpInside];
    

    // QQ
    UIButton *QQButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:
               [UIImage imageNamed:@"pie_share_qqfriends"]
                          forState:UIControlStateNormal];

        button.contentMode = UIViewContentModeScaleAspectFit;

        [self.view addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(19, 21));
            make.centerY.equalTo(sinaButton);
            make.right.equalTo(sinaButton.mas_left).with.offset(-33);

        }];

        button;

    });
    [QQButton addTarget:self
                 action:@selector(QQLogin)
       forControlEvents:UIControlEventTouchUpInside];

    
    // wechat
    UIButton *wechatButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"wechat_icon"]
                          forState:UIControlStateNormal];

        button.contentMode = UIViewContentModeScaleAspectFit;

        [self.view addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 19));
            make.centerY.equalTo(sinaButton);
            make.left.equalTo(sinaButton.mas_right).with.offset(33);

        }];

        button;
    });
    [wechatButton addTarget:self
                     action:@selector(wechatLogin)
           forControlEvents:UIControlEventTouchUpInside];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Network Request
- (void)setupHasRegisteredRequest
{
    @weakify(self);
    self.hasRegisteredRequestDisposable =
    [[self.nextStepButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        
        if ([self.cellPhoneNumberTextField.text isMobileNumber] == NO) {
            [Hud error:@"手机格式不正确"];
        }
        else{
            [Hud activity:@"验证手机中..."];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"phone"] = @([self.cellPhoneNumberTextField.text integerValue]);
            [DDBaseService GET:params url:URL_ACHasRegistered
                         block:^(id responseObject) {
                             [Hud dismiss];
                             if (responseObject != nil) {
                                 NSDictionary *dataDict = responseObject[@"data"];
                                 BOOL hasRegistered = [dataDict[@"has_registered"] boolValue];
                                
                                 if (hasRegistered) {
                                     [self updateUIForLogin];
                                     [self.hasRegisteredRequestDisposable dispose];
                                     
                                     self.loginOrSignupRequestDisposable =
                                     [[self.nextStepButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                                         [self sendLoginRequest];
                                     }];
                                 }else{
                                     [self updateUIForSignup];
                                     [self.hasRegisteredRequestDisposable dispose];
                                     
                                     self.loginOrSignupRequestDisposable =
                                     [[self.nextStepButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                                         [self sendRegisterRequest];
                                     }];
                                 }
                             }
                         }];
        }
    }];
}

- (void)sendLoginRequest
{
    /*
         － 手机号码输入正确
         － 密码符合客户端的格式要求（不能太短，etc.)
     */
    if ([self.cellPhoneNumberTextField.text isMobileNumber] == NO) {
        [Hud error:@"手机格式不正确"];
    }
    else if ([self.passwordTextField.text isPassword] == NO){
        [Hud error:@"密码格式不正确"];
    }
    else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"]            = self.cellPhoneNumberTextField.text;
        params[@"password"]         = self.passwordTextField.text;
        
        [Hud activity:@"登录中..."];

        [DDBaseService POST:params
                        url:URL_ACLogin
                      block:^(id responseObject) {
                          [Hud dismiss];

                          if (responseObject != nil) {
                              
                              NSDictionary *dataDict = responseObject[@"data"];
                              NSInteger status = [dataDict[@"status"] integerValue];
                              // data: {status: 1, 正常 2， 密码错误 3，未注册}
                              switch (status) {
                                  case 1:
                                  {
                                      PIEUserModel *user =
                                      [MTLJSONAdapter modelOfClass:[PIEUserModel class]
                                                fromJSONDictionary:dataDict error:nil];
                                      
                                      // 用返回的数据为user模型设置token
                                      user.token = responseObject[@"token"];
                                      
                                      // 将用户信息存入沙盒
                                      [DDUserManager updateCurrentUserFromUser:user];
                                      
                                      // 跳转到主控制器
                                      [[AppDelegate APP] switchToMainTabbarController];
                                      
                                      break;
                                  }
                                  case 2:
                                  {
                                      // 密码错误
                                      [Hud error:@"密码错误，请重新输入"];
                                      break;
                                  }
                              }
                          }
                      }];
    }
}

- (void)sendRegisterRequest
{
    
    // ## STEP 2: 发送"注册"请求
    if ([self.cellPhoneNumberTextField.text isMobileNumber] == NO) {
        [Hud error:@"手机号码格式不正确"];
    }else if ([self.passwordTextField.text isPassword] == NO){
        [Hud error:@"密码格式不正确"];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];

        params[@"type"]             = @"mobile";
        params[@"mobile"]           = self.cellPhoneNumberTextField.text;
        params[@"code"]             = self.verificationCodeTextField.text;
        params[@"password"]         = self.passwordTextField.text;
       
        [Hud activity:@"注册中..."];
        
        [DDBaseService
         POST:params
         url:URL_ACRegister
         block:^(id responseObject) {
             [Hud dismiss];
             if (responseObject == nil) {
                 [Hud error:@"注册失败: 网络异常或者是验证码错误"];
             }else{
             
                 NSDictionary *dataDict = responseObject[@"data"];
                 
                 PIEUserModel *user =
                 [MTLJSONAdapter modelOfClass:[PIEUserModel class]
                           fromJSONDictionary:dataDict error:nil];
                 
                 // 用返回的数据为user模型设置token
                 user.token = responseObject[@"token"];
                 
                 // 将用户信息存入沙盒
                 [DDUserManager updateCurrentUserFromUser:user];
                 
                 // 跳转到主控制器
                 [[AppDelegate APP] switchToMainTabbarController];
             }
         }];
    }
}



#pragma mark - update UI
- (void)updateUIForLogin{

    CGFloat padding = 8;
    [self.logoImageViewTopConstraint setOffset:- (CGRectGetHeight(self.cellPhoneNumberTextField.frame) + padding)];
    [self.nextStepButtonTopConstraint setOffset: ( 2 * (padding + CGRectGetHeight(self.cellPhoneNumberTextField.frame)) + 37)];
    
    // “忘记密码”这个passwordTextField的button只会在登陆的页面才会出现
    UIButton *forgotPasswordButton = ({
        UIButton *button = [[UIButton alloc] init];

        [button setBackgroundImage:[UIImage imageNamed:@"pie_launch_forgetPassword"]
                          forState:UIControlStateNormal];
        
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {

             PIEForgotPasswordViewController_Black *forgotPasswordVC =
             [[PIEForgotPasswordViewController_Black alloc] init];
             
             [[AppDelegate APP].baseNav pushViewController:forgotPasswordVC
                                                  animated:YES];

        }];
        [button sizeToFit];
        
        button;
    });
    
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.resetUiButton.hidden        = NO;
        self.logoImageView.hidden        = YES;
        self.passwordTextField.hidden    = NO;
        self.passwordTextField.rightView = forgotPasswordButton;

        [self.nextStepButton setTitle:@"登陆" forState:UIControlStateNormal];
    }];
}

- (void)updateUIForSignup{
    CGFloat padding = 8;
    [self.logoImageViewTopConstraint setOffset:- (CGRectGetHeight(self.cellPhoneNumberTextField.frame) + padding)];
    [self.nextStepButtonTopConstraint setOffset: ( 2 * (padding + CGRectGetHeight(self.cellPhoneNumberTextField.frame)) + 37)];

    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.resetUiButton.hidden             = NO;
        self.logoImageView.hidden             = YES;
        self.passwordTextField.hidden         = NO;
        self.verificationCodeTextField.hidden = NO;
        [self.nextStepButton setTitle:@"注册" forState:UIControlStateNormal];
    }];
    
    
}

- (void)resetOriginUI
{
    [self.logoImageViewTopConstraint setOffset:33];
    [self.nextStepButtonTopConstraint setOffset:19];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                         self.resetUiButton.hidden             = YES;
                         self.logoImageView.hidden             = NO;
                         self.passwordTextField.hidden         = YES;
                         self.verificationCodeTextField.hidden = YES;
                         [self.nextStepButton setTitle:@"下一步"
                                              forState:UIControlStateNormal];
                     }];
    
    // reset 'nextStepButton' click event
    [self.loginOrSignupRequestDisposable dispose];
    [self setupHasRegisteredRequest];
    
}


#pragma mark - touching methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Third-party login
- (void)QQLogin{
    [self thirdPartyLoginWithType:SSDKPlatformTypeQQ];
}

- (void)wechatLogin{
    [self thirdPartyLoginWithType:SSDKPlatformTypeWechat];
}

- (void)sinaWeiboLogin{
    [self thirdPartyLoginWithType:SSDKPlatformTypeSinaWeibo];
}

#pragma mark - private helpers


- (void)thirdPartyLoginWithType:(SSDKPlatformType)platformType
{
    @weakify(self);
    [DDShareManager
     authorize2:platformType
     withBlock:^(SSDKUser *user) {
         @strongify(self);
         if (user != nil) {
             
             PIEUserModel *userModel = [self fetchUserFromOpenId:user.uid
                                                    platformType:platformType];
             if (userModel == nil) {
                 /*
                    openID之前没有走完完整的注册流程，用户处于游客状态，遂制作一个临时的本地UserModel
                  */
                 userModel = [self adHocUserFromShareSDK:user];
             }
             // 保存这个userModel到本地，并且直接跳入主页面, 不需要向后台发送openId
             [DDUserManager updateCurrentUserFromUser:userModel];
             [[AppDelegate APP] switchToMainTabbarController];
         }
     }];
}

- (PIEUserModel *)adHocUserFromShareSDK:(SSDKUser *)user
{
    PIEUserModel *userModel = [[PIEUserModel alloc] init];
    /*
        为临时用户的模型纪录存储从ShareSDK中传递过来的openID(-> NSUserDefaults)
     */
    userModel.uid      = kPIETouristUID;
    userModel.nickname = user.nickname;
    userModel.avatar   = user.icon;
    userModel.mobile   = user.nickname;
//    userModel.openid   = user.uid;
    
    [[NSUserDefaults standardUserDefaults] setObject:user.uid
                                              forKey:PIETouristOpenIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return userModel;
}

- (PIEUserModel *)fetchUserFromOpenId:(NSString *)openId
                          platformType:(SSDKPlatformType)platformType
{
    // NSString SSDKPlatformType -> PIEUserModel, nil if openId is not registered yet
    // 检测这个第三方登录得到的用户openID，是否在之前已经绑定手机号、完成了一整个的登录流程
    // GET, auth/qq, auth/weixin, auth/weibo
    // 参数： openid
    
    NSString *authURL;
    switch (platformType) {
        case SSDKPlatformTypeSinaWeibo: {
            authURL = @"auth/weibo";
            break;
        }
        case SSDKPlatformTypeWechat: {
            authURL = @"auth/weixin";
            break;
        }
        case SSDKPlatformTypeQQ: {
            authURL = @"auth/qq";
            break;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"openid"] = openId;

    __block PIEUserModel *userModel;
    [DDBaseService
     GET:params
     url:authURL
     block:^(id responseObject) {
         /*
          openId未注册：
          {
          "ret": 1,
          "code": 0,
          "info": "",
          "data": {
          "user_obj": false,
          "is_register": 0
          },
          "token": "d0abe2ae188d1a2a7538ca23dcd57d0bb85c4df2",
          "debug": 1
          }
          
          */
         
         /*
          openId已注册：
          {
          "ret": 1,
          "code": 0,
          "info": "",
          "data": {
          "user_obj": { ... }, (PIEUserModel *)
          "is_register": 1
          },
          "token": "d0abe2ae188d1a2a7538ca23dcd57d0bb85c4df2",
          "debug": 1
          }
          
          */
         
         NSDictionary *dataDict  = responseObject[@"data"];
         BOOL openIdIsRegistered = [dataDict[@"is_register"] boolValue];
         
         if (openIdIsRegistered == NO) {
             /* 
                全新的游客态，数据库没有这个用户的相应记录
              */
             userModel = nil;
         }else{
             userModel       = [MTLJSONAdapter
                                modelOfClass:[PIEUserModel class]
                                fromJSONDictionary:dataDict[@"user_obj"]
                                error:nil];
             userModel.token = responseObject[@"token"];
         }
     }];
    
    return userModel;
}



@end



