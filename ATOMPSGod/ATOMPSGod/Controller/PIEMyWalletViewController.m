//
//  PIEMyWalletViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/21/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyWalletViewController.h"
#import "PIECashFlowDetailsViewController.h"
#import "TTTAttributedLabel.h"
#import "PIEBindWeixinPaymentViewController.h"

#import "PIEFinishWithdralViewController.h"
#import "PIEChargeMoneyView.h"
#import "PIEWithdrawlMoneyViewController.h"
#import "LxDBAnything.h"
#import "PIEChooseChargeSourceView.h"
#import "DDNavigationController.h"

@interface PIEMyWalletViewController ()<PIEChargeMoneyViewDelegate,PIEChooseChargeSourceViewDelegate,PIEBindWeixinPaymentViewControllerDelegate>

@property (nonatomic, strong) PIEChargeMoneyView *chargeMoneyView;
@property (nonatomic, strong) PIEChooseChargeSourceView *chooseChargeSourceView;

@property (nonatomic, strong) UILabel *myCashCountLabel;

@end

@implementation PIEMyWalletViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    [self setupSubViews];
    [self setupObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavBar];
    [DDUserManager updateBalanceFromRemote];
}
- (void)setupObservers {
    RAC(self.myCashCountLabel,text) =  [[RACObserve([DDUserManager currentUser], balance) filter:^BOOL(id _) {
        return YES;
    }]map:^id(id value) {
        return [NSString stringWithFormat:@"%.0f",[value floatValue]];
    }];
}



#pragma mark - target-actions
- (void)rightBarButtonClicked:(UIBarButtonItem *)rightBarButton
{
    PIECashFlowDetailsViewController *cashFlowDetailsVC =
    [PIECashFlowDetailsViewController new];
    
    [self.navigationController pushViewController:cashFlowDetailsVC
                                         animated:YES];
}


-(void)chargeMoneyView:(PIEChargeMoneyView *)chargeMoneyView tapConfirmButtonWithAmount:(CGFloat)amount {
    
    [self.chargeMoneyView disableConfirmButton];
    
    NSString *chargeTypeStr = @"wx";
    if (self.chooseChargeSourceView.chargeType == PIEWalletChargeSourceTypeAlipay) {
        chargeTypeStr = @"alipay";
    } else if (self.chooseChargeSourceView.chargeType == PIEWalletChargeSourceTypeWechat) {
        chargeTypeStr = @"wx";
    }
    NSString *amountString = [NSString stringWithFormat:@"%.0f", amount];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:amountString,@"amount",chargeTypeStr,@"type",nil];
    [DDService charge:param withBlock:^(BOOL success) {
        if (success) {
            [self.chargeMoneyView dismiss];
            [DDUserManager updateBalanceFromRemote];
        }
    }];
}

-(void)chooseChargeSourceView:(PIEChooseChargeSourceView *)chooseChargeSourceView tapButtonOfIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [self.chooseChargeSourceView dismiss];
            self.chooseChargeSourceView.chargeType = PIEWalletChargeSourceTypeAlipay;
            [self.chargeMoneyView show];
            break;
        case 1:
            [self.chooseChargeSourceView dismiss];
            self.chooseChargeSourceView.chargeType = PIEWalletChargeSourceTypeWechat;
            [self.chargeMoneyView show];
            break;
        case 2:
            [self.chooseChargeSourceView dismiss];
            
            break;
            
        default:
            break;
    }
}



#pragma mark - UI components setup
- (void)setupNavBar{
    self.navigationItem.title = @"我的钱包";
    
    UIBarButtonItem *rightBarButton =
    [[UIBarButtonItem alloc] initWithTitle:@"明细"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(rightBarButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}


- (void)setupSubViews
{
    // money icon
        UIImageView *moneyIconImageView = [[UIImageView alloc] init];
        
        moneyIconImageView.image = [UIImage imageNamed:@"pie_myWallet_money"];
        moneyIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view addSubview:moneyIconImageView];
        
        [moneyIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(101);
            make.height.mas_equalTo(101);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(45);
        }];
    
    
    // 我的零钱 label
        UILabel *myMoneyLabel = [[UILabel alloc] init];
        myMoneyLabel.text = @"我的钱包";
        myMoneyLabel.font = [UIFont lightTupaiFontOfSize:13];
        myMoneyLabel.textColor = [UIColor colorWithHex:0xFF5B38];
        [self.view addSubview:myMoneyLabel];
        
        [myMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(moneyIconImageView.mas_bottom).with.offset(26);
        }];
    
    [self.view addSubview:self.myCashCountLabel];
    [self.myCashCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(myMoneyLabel.mas_bottom).with.offset(14);
        make.width.greaterThanOrEqualTo(@20);
    }];
    
 
    
    // ¥ label
        UIImageView *rmbIconImageView = [[UIImageView alloc] init];
        rmbIconImageView.image = [UIImage imageNamed:@"pie_myWallet_rmbIcon"];
        rmbIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:rmbIconImageView];
        
        [rmbIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 33));
            make.bottom.equalTo(self.myCashCountLabel.mas_baseline);
            make.right.equalTo(self.myCashCountLabel.mas_left).with.offset(-14);
            make.leading.greaterThanOrEqualTo(self.view);
        }];
        
    
    // "元" label
        UILabel *yuanLabel = [[UILabel alloc] init];
        yuanLabel.text = @"元";
        yuanLabel.textColor = [UIColor colorWithHex:0xFF5B38];
        yuanLabel.font = [UIFont lightTupaiFontOfSize:13];
        
        [self.view addSubview:yuanLabel];
        
        [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myCashCountLabel.mas_right).with.offset(8);
            make.bottom.equalTo(self.myCashCountLabel.mas_baseline);
            make.trailing.greaterThanOrEqualTo(self.view);
        }];

    
    // 充值 button
        UIButton *chargeMoneyButton = [[UIButton alloc] init];
        [chargeMoneyButton setTitle:@"充值测试用" forState:UIControlStateNormal];
        [chargeMoneyButton setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
                          forState:UIControlStateNormal];
        chargeMoneyButton.titleLabel.font = [UIFont lightTupaiFontOfSize:16];
        [chargeMoneyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.view addSubview:chargeMoneyButton];
        
        [chargeMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.equalTo(self.view).with.offset(21);
            make.right.equalTo(self.view).with.offset(-21);
            make.top.equalTo(self.myCashCountLabel.mas_baseline).with.offset(110);
        }];
    
        [[chargeMoneyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.chooseChargeSourceView show];
        }];
    

    // 微信提现 button

    UIButton *withdrawFromWeixinButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"微信提现" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_withdraw"]
                          forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.equalTo(self.view).with.offset(21);
            make.right.equalTo(self.view).with.offset(-21);
            make.top.equalTo(self.myCashCountLabel.mas_baseline).with.offset(58);
        }];
        
        button;
    });
    [[withdrawFromWeixinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([DDUserManager currentUser].bindWechat == NO) {
            PIEBindWeixinPaymentViewController *bindWechatVC = [PIEBindWeixinPaymentViewController new];
            bindWechatVC.delegate = self;
            DDNavigationController *nav = [[DDNavigationController alloc]initWithRootViewController:bindWechatVC];
            [self presentViewController:nav animated:YES completion:NULL];
        } else {
            [self pushToWithDraw];
        }
    }];
    
    // line separator
    UIView *lineSeparator = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHex:0xDEDEDE];
        
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(withdrawFromWeixinButton.mas_bottom).with.offset(100);
        }];
        
        view;
    });
    
    // 客服label
    UILabel *serviceLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        NSString *promptText =
        [NSString stringWithFormat:@"常见问题\n紧急问题请联系QQ 2974252463"];
        label.text = promptText;
        label.font = [UIFont lightTupaiFontOfSize:14];
        label.textColor = [UIColor colorWithHex:0x7f7f7f];
        
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(lineSeparator.mas_bottom).with.offset(44);
        }];
        
        label;
    });
    serviceLabel.numberOfLines = 0;
    
}
-(void)bindWechatViewController:(PIEBindWeixinPaymentViewController *)bindWechatViewController success:(BOOL)success {
    if (success) {
        [self pushToWithDraw];
    }
}

- (void)pushToWithDraw {
    PIEWithdrawlMoneyViewController *withDrawlVC =
    [[PIEWithdrawlMoneyViewController alloc] init];
    [self.navigationController pushViewController:withDrawlVC animated:YES];
}
#pragma mark - Lazy loadings

-(PIEChargeMoneyView *)chargeMoneyView {
    if (_chargeMoneyView == nil) {
        _chargeMoneyView = [PIEChargeMoneyView new];
        _chargeMoneyView.delegate = self;
    }
    return _chargeMoneyView;
}
-(PIEChooseChargeSourceView *)chooseChargeSourceView {
    if (_chooseChargeSourceView == nil) {
        _chooseChargeSourceView = [PIEChooseChargeSourceView new];
        _chooseChargeSourceView.delegate = self;
    }
    return _chooseChargeSourceView;
}

-(UILabel *)myCashCountLabel {
    if (!_myCashCountLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont mediumTupaiFontOfSize:45];
        label.textColor = [UIColor colorWithHex:0xFF5B38];
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
        label.textAlignment = NSTextAlignmentCenter;
        _myCashCountLabel = label;
    }
    return _myCashCountLabel;
}

@end
