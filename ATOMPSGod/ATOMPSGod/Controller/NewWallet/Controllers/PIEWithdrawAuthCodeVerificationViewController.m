//
//  PIEWithdrawAuthCodeVerificationViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/17/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEWithdrawAuthCodeVerificationViewController.h"
#import "PIEVerificationCodeCountdownButton.h"
#import "PIEFinishWithdrawMoneyViewController_new.h"


@interface PIEWithdrawAuthCodeVerificationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cellphoneNumTextField;
@property (weak, nonatomic) IBOutlet PIEVerificationCodeCountdownButton *requestAuthCodeButton;

@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton    *confirmButton;

@end

@implementation PIEWithdrawAuthCodeVerificationViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configureSubviews];
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
- (void)configureSubviews
{
    [self.requestAuthCodeButton
     setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
     forState:UIControlStateNormal];
    
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
                                  forState:UIControlStateNormal];
    
    @weakify(self);
    self.requestAuthCodeButton.fetchVerificationCodeBlock =
    ^void(void){
        @strongify(self);
        NSMutableDictionary *params =
        [NSMutableDictionary dictionary];
        
        params[@"phone"] =
        @([self.cellphoneNumTextField.text integerValue]);
        [DDBaseService GET:params
                       url:@"account/requestAuthCode"
                     block:^(id responseObject) {
                         
                         // do nothing, 或者以后还要判断短信是否发送成功?
                     }];
    };
    
    self.cellphoneNumTextField.text      = [DDUserManager currentUser].mobile;

    self.cellphoneNumTextField.enabled   = NO;

    self.cellphoneNumTextField.textColor = [UIColor lightGrayColor];
    
    [self.authCodeTextField becomeFirstResponder];
    
}


- (void)setupRAC
{
    @weakify(self);
    [[self.confirmButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if ([self.cellphoneNumTextField.text isMobileNumber]) {
             [self sendMoneyTransferRequest];
         }else{
             NSString *prompt = [NSString stringWithFormat:@"%@ 不是一个手机号码", self.cellphoneNumTextField.text];
             [Hud error:prompt];
         }
         
     }];
}

- (void)setupNavBar
{
    self.navigationItem.title = @"微信";
}

#pragma mark - Network request
- (void)sendMoneyTransferRequest
{
    NSDictionary *params = @{@"type":@"wx",
                             @"amount":self.withdrawAmountStr};
    [Hud activity:@"提现中..."];
    [DDService withdraw:params withBlock:^(BOOL success) {
        
        [Hud dismiss];
        
        if (success) {
            [self pushToFinishWithdrawMoneyViewController];
        }
        else{
            [Hud error:@"提现失败或取消"];
        }
    }];
}

#pragma mark - touching methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Push view controllers
- (void)pushToFinishWithdrawMoneyViewController
{
    PIEFinishWithdrawMoneyViewController_new *finishWithdrawMoneyVC =
    [PIEFinishWithdrawMoneyViewController_new new];
    finishWithdrawMoneyVC.withdrawAmountStr = self.withdrawAmountStr;
    [self.navigationController pushViewController:finishWithdrawMoneyVC
                                         animated:YES];
}

@end
