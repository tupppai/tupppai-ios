//
//  PIEWithdrawlMoneyViewController_new.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEWithdrawlMoneyViewController_new.h"
#import "PIEWithdrawMoneyView.h"


#import "PIEWithdrawAuthCodeVerificationViewController.h"
#import "PIEBindWeixinPaymentViewController_new.h"



@interface PIEWithdrawlMoneyViewController_new ()

@property (nonatomic, strong) UIScrollView         *scrollView;
@property (nonatomic, strong) PIEWithdrawMoneyView *withdrawMoneyView;
@property (nonatomic, assign) double               remainingBalance;
@property (nonatomic, strong) RACSignal            *fetchRemainingBalanceRequestSignal;
@property (nonatomic, strong) RACSignal            *validWithdrawAmountSignal;

@end

@implementation PIEWithdrawlMoneyViewController_new

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
    
}

#pragma mark - UI components setup
- (void)setupSubviews
{
    @weakify(self);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.withdrawMoneyView];
    [self.withdrawMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.scrollView);
        
        // 需要在这里设置withdrawMoneyView的宽高，撑大上面的scrollView（变相设置它的contentSize）
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT + 110);
    }];
    
}

- (void)setupRAC
{
    @weakify(self);
    RAC(self.withdrawMoneyView.remainingBalanceLabel, text) =
    self.fetchRemainingBalanceRequestSignal;
    
    RAC(self.withdrawMoneyView.confirmWithdrawButton, enabled) =
    self.validWithdrawAmountSignal;
    
    [[self.withdrawMoneyView.confirmWithdrawButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self);
        if ([DDUserManager currentUser].bindWechat == NO) {
            [self pushToBindWeixinPaymentViewController];
        }else{
            [self pushToAuthcodeViewController];
        }
    }];
}

#pragma mark - Push View Controllers

- (void)pushToBindWeixinPaymentViewController
{
    PIEBindWeixinPaymentViewController_new *bindWeixinPaymentVC =
    [PIEBindWeixinPaymentViewController_new new];
    
    bindWeixinPaymentVC.withdrawAmountStr = self.withdrawMoneyView.inputAmountTextField.text;
    
    [self.navigationController pushViewController:bindWeixinPaymentVC
                                         animated:YES];
}

- (void)pushToAuthcodeViewController
{
    PIEWithdrawAuthCodeVerificationViewController *authcodeVerificationVC =
    [[PIEWithdrawAuthCodeVerificationViewController alloc] init];
    authcodeVerificationVC.withdrawAmountStr = self.withdrawMoneyView.inputAmountTextField.text;
    [self.navigationController pushViewController:authcodeVerificationVC animated:YES];
}

#pragma mark - Lazy loadings
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (PIEWithdrawMoneyView *)withdrawMoneyView{
    if (_withdrawMoneyView == nil) {
        _withdrawMoneyView = [PIEWithdrawMoneyView withdrawMoneyView];
    }
    
    return _withdrawMoneyView;
}

- (RACSignal *)fetchRemainingBalanceRequestSignal
{
    if (_fetchRemainingBalanceRequestSignal == nil) {
        _fetchRemainingBalanceRequestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"正在获取用户余额......"];
            
            @weakify(self);
            [DDService GET:nil url:@"profile/view" block:^(id responseObject) {
                @strongify(self);
                if (responseObject == nil) {
                    [subscriber sendNext:@"获取用户余额失败"];
                    [subscriber sendCompleted];
                }
                NSDictionary *dataDict = [responseObject objectForKey:@"data"];
                double balance = [[dataDict objectForKey:@"balance"] doubleValue];
                
                NSString *remainingBalanceText =
                [NSString stringWithFormat:@"￥ %.2f", balance];
                self.remainingBalance = balance;
                
                [subscriber sendNext:remainingBalanceText];
                [subscriber sendCompleted];
            }];
            
            return  nil;
        }];
    }
    
    return _fetchRemainingBalanceRequestSignal;
}

- (RACSignal *)validWithdrawAmountSignal
{
    if (_validWithdrawAmountSignal == nil) {
        @weakify(self);
        _validWithdrawAmountSignal =
        [[self.withdrawMoneyView.inputAmountTextField.rac_textSignal
          distinctUntilChanged]
         map:^NSNumber *(NSString *inputAmoutStr) {
             double inputAmount = [inputAmoutStr doubleValue];
             
             @strongify(self);
             if (inputAmount > 1 &&
                 inputAmount < self.remainingBalance) {
                 return @YES;
             }else{
                 return @NO;
             }
        }];
    }
    return _validWithdrawAmountSignal;
}

#pragma mark - touching methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
