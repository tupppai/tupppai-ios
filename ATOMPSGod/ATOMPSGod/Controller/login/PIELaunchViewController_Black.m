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




/* Variables */
@interface PIELaunchViewController_Black ()

@property (nonatomic, weak  ) UIImageView   *logoImageView;
@property (nonatomic, weak  ) UITextField   *cellPhoneNumberTextField;
@property (nonatomic, weak  ) UITextField   *passwordTextField;

@property (nonatomic, strong) UIButton      *countdownButton;
@property (nonatomic, weak  ) UITextField   *verificationCodeTextField;


@property (nonatomic, weak  ) UIButton      *nextStepButton;
@property (nonatomic, weak  ) UIImageView   *launchSeparator;

@property (nonatomic, strong) MASConstraint *logoImageViewTopConstraint;
@property (nonatomic, strong) MASConstraint *nextStepButtonTopConstraint;


@end

@implementation PIELaunchViewController_Black
#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setupUI];

    [self setupBasicRAC];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];


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
    UITextField *cellPhoneNumberTextField = ({
        UITextField *textField = [[UITextField alloc] init];

        textField.font = [UIFont lightTupaiFontOfSize:13];
        textField.textColor = [UIColor blackColor];
        textField.placeholder = @"手机号";
        textField.borderStyle = UITextBorderStyleLine;


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
    UITextField *passwordTextField = ({
        UITextField *textField = [[UITextField alloc] init];

        textField.font         = [UIFont lightTupaiFontOfSize:13];
        textField.textColor    = [UIColor blackColor];
        textField.placeholder  = @"密码";
        textField.borderStyle  = UITextBorderStyleLine;

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
    // TODO: 封装成PIECountdownButton

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


    // 验证码TextField
    UITextField *verificationCodeTextField = ({
        UITextField *textField  = [[UITextField alloc] init];

        textField.font          = [UIFont lightTupaiFontOfSize:13];
        textField.textColor     = [UIColor blackColor];
        textField.placeholder   = @"验证码";
        textField.borderStyle   = UITextBorderStyleLine;


        textField.rightView     = countdownButton;
        textField.rightViewMode = UITextFieldViewModeAlways;

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
    [[sinaButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         NSLog(@"sinaButton clicked!");
    }];

    // QQ
    UIButton *QQButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"pie_share_qqfriends"]
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

    [[QQButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         NSLog(@"QQButton clicked!");
    }];

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
    [[wechatButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         NSLog(@"wechatButton clicked!");
     }];

}


#pragma mark - Reactivecocoa Signals binding

- (void)setupBasicRAC
{
    RACSignal *validCellPhoneNumberInputSignal =
    [[self.cellPhoneNumberTextField.rac_textSignal
    distinctUntilChanged]
     map:^id(NSString *value) {

         // NSString -> BOOL
         if ([value isMobileNumber]) {
             return @(YES);
         }else{
             return @(NO);
         }
     }];



    /*
        忘了要weak-strong dance, 在后面爆出了内核的错误了……不会debug啊
     */
    @weakify(self);
    self.nextStepButton.rac_command =
    [[RACCommand alloc]
     initWithEnabled:validCellPhoneNumberInputSignal
     signalBlock:^RACSignal *(id input) {
         @strongify(self);

         RACSignal *networkResponseSignal =
         [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            //  // network request
            //  NSMutableDictionary *params = [NSMutableDictionary dictionary];
            //  params[@"phone"] = self.cellPhoneNumberTextField.text;
            //  [DDBaseService GET:params
            //                 url:URL_ACHasRegistered
            //               block:^(id responseObject) {
            //                   if (responseObject == nil) {
            //                       /* "ret" 字段为0:是不正常的意思？ */
            //                   }
            //                   else{
            //                       NSDictionary *data = responseObject[@"data"];
            //                       BOOL hasRegistered = [data[@"has_registered"] boolValue];
             //
            //                       if (hasRegistered) {
            //                           // send Next & complete
             //
            //                           [subscriber sendNext:@"Yeah! You made it!"];
            //                           [subscriber sendCompleted];
             //
            //                       }else{
            //                           // send Error
            //                           [subscriber sendError:
            //                            [NSError errorWithDomain:
            //                             @"this cellphone is not currently registered"
            //                                                code:233
            //                                            userInfo:@{@"你是傻X吗？":@"是啊"}]];
            //                       }
            //                   }
            //               }];
            // 没向腾讯交保护费，改域名也没用啊！

            [subscriber sendError:
                                      [NSError errorWithDomain:
                                       @"this cellphone is not currently registered"
                                                          code:233
                                                      userInfo:@{@"疼讯的保护费你交了吗？":@"没😢"}]];



             return [RACDisposable disposableWithBlock:^{
                 // cancel network request upon unregistering subscriber

             }];
        }];

         return networkResponseSignal;
     }];




    [[self.nextStepButton.rac_command errors] subscribeNext:^(id x) {
        // 没办法用用户输入的手机号码登陆，所以Plan B:  弹出注册页面
        @strongify(self);
        NSLog(@"%@", x);

        /* 更新UI，并且按照需求让nextStepButton绑定新的RACCommand */
        [self updateUIForSignup];
        [self setupRegisterRAC];
    }];

    [[[self.nextStepButton.rac_command executionSignals] switchToLatest] subscribeNext:^(id x) {
        // PlanA：用户输入的手机号码是已经注册过的了，所以弹出登陆页面
        // question: a signal of signal? 所以最后要switchToLatest 或者是　flatten?
        @strongify(self);
        NSLog(@"%@", x);

        /* 更新UI，并且按照需求让nextStepButton绑定新的RACCommand */
        [self updateUIForLogin];
        [self setupLoginRAC];
    }];

}


- (void)setupLoginRAC
{
    /*
        信号的合并：
         － 手机号码输入正确
         － 密码符合客户端的格式要求（不能太短，etc.)

     */

    RACSignal *validPasswordInputSignal =
    [self.passwordTextField.rac_textSignal
     map:^id(NSString  *value) {
         if ([value isPassword]) {
             return @(YES);
         }else{
             return @(NO);
         }
    }];

    RACSignal *validCellPhoneNumberInputSignal =
    [self.cellPhoneNumberTextField.rac_textSignal
     map:^id(NSString *value) {
         if ([value isMobileNumber]) {
             return @(YES);
         }else{
             return @(NO);
         }
    }];


    RACSignal *loginButtonEnabledSignal =
    [RACSignal combineLatest:@[validCellPhoneNumberInputSignal,
                               validPasswordInputSignal]
                      reduce:^NSNumber *(NSNumber *isValidCellPhoneNumber,
                                         NSNumber *isValidPassword){
                          // BOOL BOOL -> BOOL
                          return
                          @([isValidCellPhoneNumber boolValue] &&
                            [isValidPassword boolValue]);
                      }];


    // 给nextStepButton换上新的RACCommand. 希望不要崩掉吧。


    self.nextStepButton.rac_command =
    [[RACCommand alloc]
     initWithEnabled:loginButtonEnabledSignal
     signalBlock:^RACSignal *(id input) {
         return [RACSignal
                 createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                     // send network request: login

                     // if success:
//                     [subscriber sendNext:@"Yeah I managed myself to login!"];
//                     [subscriber sendCompleted];

                     // if failure:
                     [subscriber sendError:[NSError errorWithDomain:@"Cannot login!"
                                                               code:234
                                                           userInfo:nil]];


                     return nil;
         }];
     }];


    [[[self.nextStepButton.rac_command executionSignals]
      switchToLatest]
     subscribeNext:^(id x) {
         [Hud text:[NSString stringWithFormat:@"%@", x]];
    }];

    [[self.nextStepButton.rac_command errors] subscribeNext:^(id x) {
        [Hud text:@"Failed to Login!"];
    }];


}

- (void)setupRegisterRAC
{
    // ## Step 1: 获取验证码->倒计时 + 发网络请求，一系列的信号处理

    // RAC-signal binding
    const NSInteger numberLimit   = 10;
    __block NSInteger numberCount = numberLimit;

    /*
        weak-strong dance!
     */
    @weakify(self);
    RACSignal *countdownSignal =
    [[[[RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]]
       startWith:@"Let's GO!"]
      take:numberLimit + 1]
     doNext:^(id x) {
         @strongify(self);

         /*
          WARNING: 第一个信号是@“Let's GO!”，接下来的5个信号才是NSDate
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

    self.countdownButton.rac_command = [[RACCommand alloc]
                                   initWithSignalBlock:^RACSignal *(id input) {

                                       // 这里实在是想不明白：理论上说RACCommand在这里返回的信号一般都是网络请求然后自己手写的信号，
                                       // 那为什么在这里返回的是一个时钟信号？然后就会触发时钟信号开始send next了？
                                       // 我返回一个自己创造的信号结果不会触发任何东西。

                                       // send network request here.
                                       [Hud text:@"我要发请求获取验证码啦"];

                                       return countdownSignal;
                                   }];


    // ## STEP 2: 三大信号的整合 -> 成为self.nextStepButton的RACCommand
    RACSignal *countdownButtonIsCountingSignal = [self.countdownButton.rac_command executing];

    RACSignal *validPasswordInputSignal =
    [self.passwordTextField.rac_textSignal
     map:^id(NSString  *value) {
         if ([value isPassword]) {
             return @(YES);
         }else{
             return @(NO);
         }
    }];

    RACSignal *validCellPhoneNumberInputSignal =
    [self.cellPhoneNumberTextField.rac_textSignal
     map:^id(NSString *value) {
         if ([value isMobileNumber]) {
             return @(YES);
         }else{
             return @(NO);
         }
    }];
    
    RACSignal *signupButtonEnabledSignal =
    [RACSignal combineLatest:@[validCellPhoneNumberInputSignal,
                               validPasswordInputSignal,
                               countdownButtonIsCountingSignal]
                      reduce:^NSNumber *(NSNumber *isValidCellPhoneNumber,
                                         NSNumber *isValidPassword,
                                         NSNumber *countdownButtonIsCounting){
                          // BOOL BOOL BOOL -> BOOL
                          /*
                                nextButton是enabled的条件：必须同时满足以下三个条件：
                                 - 用户输入了正常的手机号码;
                                 - 用户输入了合适格式的密码（不能太短）
                                 - "获取验证码"的倒计时还没有结束
                           */
                          return @([isValidCellPhoneNumber boolValue] &&
                                   [isValidPassword boolValue] &&
                                   [countdownButtonIsCounting boolValue]);
                      }];
    
    // 更换nextStepButton的RACCommand，之前的那个肯定被auto release掉了
    self.nextStepButton.rac_command =
    [[RACCommand alloc] initWithEnabled:signupButtonEnabledSignal
                            signalBlock:^RACSignal *(id input) {
                                
                                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                    
                                    // send signup request here:
                                    
                                    // if success:
                                    [subscriber sendNext:@"Yeah! You have signed up!"];
                                    [subscriber sendCompleted];
                                    
                                    // if failure
//                                    [subscriber sendError:[NSError errorWithDomain:
//                                                           @"You cannot sign up!"
//                                                                              code:234
//                                                                          userInfo:@{@"哎呀我注册不了啊":@"hehe😄"}]];
                                    
                                    return [RACDisposable disposableWithBlock:^{
                                        // cancel network request here.
                                    }];
                                }];
                            
                            }];
    
    [[[self.nextStepButton.rac_command executionSignals] switchToLatest] subscribeNext:^(id x) {
        // 注册成功
        
        NSString *prompt = [NSString stringWithFormat:@"%@", x];
        [Hud text:prompt];
    }];
    
    [[self.nextStepButton.rac_command errors] subscribeNext:^(id x) {
        // 注册失败
        [Hud text:@"注册失败！"];
    }];
    
    
    // 倒计时结束，提示用户重新获取验证码
    [[countdownButtonIsCountingSignal
     map:^NSNumber *(NSNumber *value) {
         // BOOL -> BOOL
         // 逻辑取反
         
         return @(![value boolValue]);
    }] subscribeNext:^(NSNumber *value) {
        if ([value boolValue] == YES) {
            [Hud text:@"超时未输入验证码，请重新获取"];
        }
    }];
    

}



#pragma mark - update UI
- (void)updateUIForLogin{

    [Hud text:@"该手机号已注册, 准备进入登陆页面"];
    CGFloat padding = 8;
    [self.logoImageViewTopConstraint setOffset:- (CGRectGetHeight(self.cellPhoneNumberTextField.frame) + padding)];
    [self.nextStepButtonTopConstraint setOffset: ( 2 * (padding + CGRectGetHeight(self.cellPhoneNumberTextField.frame)) + 37)];

    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.logoImageView.hidden = YES;
        self.passwordTextField.hidden = NO;
        [self.nextStepButton setTitle:@"登陆" forState:UIControlStateNormal];
    }];


}

- (void)updateUIForSignup{
    [Hud text:@"该手机号码尚未注册，进入注册流程。。。"];

    CGFloat padding = 8;
    [self.logoImageViewTopConstraint setOffset:- (CGRectGetHeight(self.cellPhoneNumberTextField.frame) + padding)];
    [self.nextStepButtonTopConstraint setOffset: ( 2 * (padding + CGRectGetHeight(self.cellPhoneNumberTextField.frame)) + 37)];

    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.logoImageView.hidden = YES;
        self.passwordTextField.hidden         = NO;
        self.verificationCodeTextField.hidden = NO;
        [self.nextStepButton setTitle:@"注册" forState:UIControlStateNormal];
    }];

}



@end
