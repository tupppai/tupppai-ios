//
//  PIEMyWalletViewController_new.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/4/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyWalletViewController_new.h"
#import "PIECashFlowDetailsViewController.h"
#import "TTTAttributedLabel.h"
#import "PIEBindWeixinPaymentViewController.h"

#import "PIEFinishWithdralViewController.h"
#import "PIEChargeMoneyView.h"
#import "PIEWithdrawlMoneyViewController_new.h"
#import "LxDBAnything.h"
#import "PIEChooseChargeSourceView.h"
#import "PIEPIEMyWalletFaqViewController.h"
#import "PIECashFlowDetailsViewController_new.h"


// testing
#import "PIEFinishWithdrawMoneyViewController_new.h"
#import "PIEBindWeixinPaymentViewController_new.h"
#import "PIEWithdrawAuthCodeVerificationViewController.h"


@interface PIEMyWalletViewController_new ()
<
    /* Protocols */
    PIEChargeMoneyViewDelegate,
    PIEChooseChargeSourceViewDelegate
>

@property (nonatomic, strong) PIEChargeMoneyView *chargeMoneyView;
@property (nonatomic, strong) PIEChooseChargeSourceView *chooseChargeSourceView;

@property (nonatomic, strong) UILabel *myCashCountLabel;

@end

@implementation PIEMyWalletViewController_new

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

#pragma mark - UI components setup
- (void)setupNavBar{
    self.navigationItem.title = @"我的零钱";
}

- (void)setupSubViews
{
    // money icon
    UIImageView *moneyIconImageView = [[UIImageView alloc] init];
    
    moneyIconImageView.image = [UIImage imageNamed:@"pie_myWallet_money"];
    moneyIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:moneyIconImageView];
    
    [moneyIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(77);
        make.height.mas_equalTo(96);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(57);
    }];
    
    // 钱包余额 label
    UILabel *myMoneyLabel = [[UILabel alloc] init];
    myMoneyLabel.text = @"钱包余额";
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
    [chargeMoneyButton setTitle:@"充值" forState:UIControlStateNormal];
    [chargeMoneyButton setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
                                 forState:UIControlStateNormal];
    chargeMoneyButton.titleLabel.font = [UIFont lightTupaiFontOfSize:16];
    [chargeMoneyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:chargeMoneyButton];
    
    [chargeMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view).with.offset(21);
        make.right.equalTo(self.view).with.offset(-21);
        make.top.equalTo(self.myCashCountLabel.mas_baseline).with.offset(30);
    }];
    
    [[chargeMoneyButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
        
         [Hud text:@"充值"];
        
    }];
    // 目前需求暂时不需要用到充值button
    chargeMoneyButton.hidden = YES;
    
    // 提现 button
    
    UIButton *withdrawFromWeixinButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"提现" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_withdraw"]
                          forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.equalTo(self.view).with.offset(21);
            make.right.equalTo(self.view).with.offset(-21);
            make.top.equalTo(chargeMoneyButton.mas_top);
        }];
        button;
    });
    [[withdrawFromWeixinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        PIEWithdrawlMoneyViewController_new *withDrawlVC =
        [[PIEWithdrawlMoneyViewController_new alloc] init];
        [self.navigationController pushViewController:withDrawlVC animated:YES];
    }];
    
    // bottomButton separator
    UIView *bottomButtonSeparatorView = ({
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
        [self.view addSubview:view];
        
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(CGSizeMake(1, 10));
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).with.offset(-20);
        }];
        
        view;
    });
    
    // 常见问题button
    UIButton *faqButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:@"常见问题" forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.5]
                     forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:11];
        
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomButtonSeparatorView).with.offset(-13);
            make.centerY.equalTo(bottomButtonSeparatorView);
        }];
        
        button;
    });
    [[faqButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        PIEPIEMyWalletFaqViewController *faqVC =
        [[PIEPIEMyWalletFaqViewController alloc] init];
        
        faqVC.url = @"http://www.baidu.com";
        [self.navigationController pushViewController:faqVC animated:YES];
    }];
    
    // 交易明细button
    UIButton *transactionDetailsButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"交易明细" forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.5]
                     forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:11];
        
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomButtonSeparatorView).with.offset(13);
            make.centerY.equalTo(bottomButtonSeparatorView);
        }];
        
        button;
    });
    [[transactionDetailsButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        PIECashFlowDetailsViewController_new *cashFlowDetailsVC =
        [[PIECashFlowDetailsViewController_new alloc] init];
        [self.navigationController pushViewController:cashFlowDetailsVC animated:YES];
    }];
    
}

- (void)setupObservers {
    RAC(self.myCashCountLabel,text) =  [[RACObserve([DDUserManager currentUser], balance) filter:^BOOL(id _) {
        return YES;
    }]map:^id(id value) {
        return [NSString stringWithFormat:@"%.2f",[value floatValue]];
    }];
}

#pragma mark - <PIEChargeMoneyViewDelegate>
- (void)chargeMoneyView:(PIEChargeMoneyView *)chargeMoneyView tapConfirmButtonWithAmount:(CGFloat)amount {
    
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
        }
    }];
}

#pragma mark - <PIEChooseChargeSourceViewDelegate>
- (void)chooseChargeSourceView:(PIEChooseChargeSourceView *)chooseChargeSourceView tapButtonOfIndex:(NSInteger)index {
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

#pragma mark - target-actions
- (void)rightBarButtonClicked:(UIBarButtonItem *)rightBarButton
{
    PIECashFlowDetailsViewController *cashFlowDetailsVC =
    [PIECashFlowDetailsViewController new];
    
    [self.navigationController pushViewController:cashFlowDetailsVC
                                         animated:YES];
}



#pragma mark - lazy loadings
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
