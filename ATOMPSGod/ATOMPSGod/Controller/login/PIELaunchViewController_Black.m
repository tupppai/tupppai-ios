//
//  PIELaunchViewController_Black.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/4/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELaunchViewController_Black.h"

/* Variables */
@interface PIELaunchViewController_Black ()

@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UITextField *cellPhoneNumberTextField;
@property (nonatomic, weak) UIButton    *nextStepButton;
@property (nonatomic, weak) UIImageView *launchSeparator;

@end

@implementation PIELaunchViewController_Black
#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
 
    [self setupUI];
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
        imageView.image = [UIImage imageNamed:@"pie_logo"];
        imageView.contentMode =UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(43, 30));
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
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(48);
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.centerX.equalTo(self.view);
            make.top.equalTo(logoImageView.mas_bottom).with.offset(45);
        }];
        
        
        textField;
    
    });
    self.cellPhoneNumberTextField = cellPhoneNumberTextField;
    
    // nextStep button
    UIButton *nextStepButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setBackgroundColor:[UIColor colorWithHex:0x090909]];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:13];
        button.adjustsImageWhenHighlighted = YES;
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(40);
            make.right.equalTo(self.view.mas_right).with.offset(-40);
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(cellPhoneNumberTextField.mas_bottom).with.offset(19);
            make.height.mas_equalTo(48);
        }];
        
        [button addTarget:self
                   action:@selector(nextStepButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        
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
        [button addTarget:self
                   action:@selector(sinaButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(23, 19));
            make.centerX.equalTo(self.view);
            make.top.equalTo(launchSeparator.mas_bottom).with.offset(22);
            
        }];
        
        button;
    });
    
    // QQ
    UIButton *QQButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"pie_share_qqfriends"]
                          forState:UIControlStateNormal];
        
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:self
                   action:@selector(QQButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(19, 21));
            make.centerY.equalTo(sinaButton);
            make.right.equalTo(sinaButton.mas_left).with.offset(-33);
            
        }];
        
        button;
    
    });
    
    // wechat
    UIButton *wechatButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"wechat_icon"]
                          forState:UIControlStateNormal];
        
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:self
                   action:@selector(wechatButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 19));
            make.centerY.equalTo(sinaButton);
            make.left.equalTo(sinaButton.mas_right).with.offset(33);
            
        }];
        
        button;
    });
    
}


#pragma mark - target-actions
- (void)nextStepButtonClicked:(UIButton *)button
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)sinaButtonClicked:(UIButton *)button
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)QQButtonClicked:(UIButton *)button
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)wechatButtonClicked:(UIButton *)button
{
    NSLog(@"%s", __FUNCTION__);
}

@end
