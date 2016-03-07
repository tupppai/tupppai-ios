//
//  PIEPIEBindWeixinPaymentViewController_new.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/17/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBindWeixinPaymentViewController_new.h"
#import "PIEWithdrawAuthCodeVerificationViewController.h"

@interface PIEBindWeixinPaymentViewController_new ()

@property (nonatomic, strong) UIButton *bindWeixinButton;

@end

@implementation PIEBindWeixinPaymentViewController_new

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor   = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self setupSubviews];
    [self setupRAC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavBar];
}

#pragma mark - UI components setup
- (void)setupSubviews
{
    // containerView
    UIView *containerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(140);
        }];
        
        view;
    });
    
    // big wechat icon
    UIImageView *largeWechatIcon = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [containerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(78, 78));
            make.center.equalTo(containerView);
        }];
        
        imageView;
    });
    largeWechatIcon.image = [UIImage imageNamed:@"wechat_big"];
    
    // 第一步 label
    UILabel *prompt1  = [[UILabel alloc] init];
    prompt1.text      = @"第1步 请绑定微信";
    prompt1.textColor = [UIColor blackColor];
    prompt1.font      = [UIFont lightTupaiFontOfSize:15];
    
    [self.view addSubview:prompt1];
    [prompt1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(containerView.mas_bottom).with.offset(20);
    }];
    
    // 绑定的微信... label
    UILabel *prompt2 = [[UILabel alloc] init];
    prompt2.text = @"绑定的微信将成为你的提现账户";
    prompt2.textColor = [UIColor blackColor];
    prompt2.font = [UIFont lightTupaiFontOfSize:13];
    
    [self.view addSubview:prompt2];
    [prompt2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(prompt1.mas_left);
        make.top.equalTo(prompt1.mas_bottom).with.offset(15);
    }];
    
    // 绑定button
    UIButton *bindWeixinButton = [[UIButton alloc] init];
    [bindWeixinButton setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
                                forState:UIControlStateNormal];
    [bindWeixinButton setTitle:@"绑定" forState:UIControlStateNormal];
    [bindWeixinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bindWeixinButton.titleLabel.font = [UIFont lightTupaiFontOfSize:16];
    [self.view addSubview:bindWeixinButton];
    [bindWeixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(prompt2.mas_baseline).with.offset(25);
    }];
    self.bindWeixinButton = bindWeixinButton;
    
}

- (void)setupNavBar
{
    self.navigationItem.title = @"微信";
}

- (void)setupRAC
{
    @weakify(self);
    [[self.bindWeixinButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        [self bindWeixinAccountRequest];
    }];
}

#pragma mark - Network request
- (void)bindWeixinAccountRequest
{
    // 尚未绑定微信， 先绑定微信账户
    @weakify(self);
    [DDShareManager
     authorize_openshare:ATOMAuthTypeWeixin
     withBlock:^(OpenshareAuthUser *user) {
         [DDShareManager
          bindUserWithThirdPartyPlatform:@"weixin"
          openId:user.uid
          failure:^{
              [Hud error:@"绑定失败"];
          } success:^{
              @strongify(self);
              [DDUserManager currentUser].bindWechat = YES;
              [DDUserManager updateCurrentUserInDatabase];
              
              [self pushToAuthcodeViewController];
          }];
     }];
}

#pragma mark - Push view controllers
- (void)pushToAuthcodeViewController
{
    PIEWithdrawAuthCodeVerificationViewController *withdrawAuthCodeVerificationVC =
    [PIEWithdrawAuthCodeVerificationViewController new];
    
    withdrawAuthCodeVerificationVC.withdrawAmountStr = self.withdrawAmountStr;
    
    [self.navigationController pushViewController:withdrawAuthCodeVerificationVC
                                         animated:YES];
}
@end
