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
@interface PIEMyWalletViewController ()<PIEChargeMoneyViewDelegate,PIEChooseChargeSourceViewDelegate>

@property (nonatomic, strong) PIEChargeMoneyView *chargeMoneyView;
@property (nonatomic, strong) PIEChooseChargeSourceView *chooseChargeSourceView;

@end

@implementation PIEMyWalletViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupSubViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    [self setupNavBar];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

#pragma mark - target-actions
- (void)rightBarButtonClicked:(UIBarButtonItem *)rightBarButton
{
    PIECashFlowDetailsViewController *cashFlowDetailsVC =
    [PIECashFlowDetailsViewController new];
    
    [self.navigationController pushViewController:cashFlowDetailsVC
                                         animated:YES];
}


-(void)chargeMoneyView:(PIEChargeMoneyView *)chargeMoneyView tapConfirmButtonWithAmount:(NSInteger)amount {
    
    NSString *chargeTypeStr = @"wechat";
    if (self.chooseChargeSourceView.chargeType == PIEWalletChargeSourceTypeAlipay) {
        chargeTypeStr = @"";
    } else if (self.chooseChargeSourceView.chargeType == PIEWalletChargeSourceTypeWechat) {
        chargeTypeStr = @"";
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(amount),@"amount",chargeTypeStr,@"type",nil];

    [DDService POST:param url:@"money/charge" block:^(id responseObject) {
        NSLog(@"responseObject%@",responseObject);
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
    self.navigationItem.title = @"我的零钱";
    
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
    UIImageView *moneyIconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.image = [UIImage imageNamed:@"pie_myWallet_money"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(101);
            make.height.mas_equalTo(101);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(45);
        }];
        imageView;
    });
    
    // 我的零钱 label
    UILabel *myMoneyLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.text = @"我的零钱";
        label.font = [UIFont lightTupaiFontOfSize:13];
        label.textColor = [UIColor colorWithHex:0xFF5B38];
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(moneyIconImageView.mas_bottom).with.offset(26);
        }];
        
        label;
    });
    
    

    // 我的零钱－确切数量 label
    UILabel *myCashCountLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%.2f",[DDUserManager currentUser].balance];
        label.font = [UIFont mediumTupaiFontOfSize:45];
        label.textColor = [UIColor colorWithHex:0xFF5B38];
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
            make.leading.and.trailing.equalTo(self.view);
            make.top.equalTo(myMoneyLabel.mas_bottom).with.offset(14);
        }];
        label;
    });
    
    // ¥ label
    UIImageView *rmbIconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.image = [UIImage imageNamed:@"pie_myWallet_rmbIcon"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.size.mas_equalTo(CGSizeMake(24, 33));
            make.bottom.equalTo(myCashCountLabel.mas_baseline);
            make.right.equalTo(myCashCountLabel.mas_left).with.offset(-14);
        }];
        
        imageView;
    });
    
    // "元" label
    UILabel *yuanLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.text = @"元";
        label.textColor = [UIColor colorWithHex:0xFF5B38];
        label.font = [UIFont lightTupaiFontOfSize:13];
        
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(myCashCountLabel.mas_right).with.offset(8);
            make.bottom.equalTo(myCashCountLabel.mas_baseline);
        }];
        
        label;
    });
    
    // 充值 button
    UIButton *chargeMoneyButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:@"充值" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
                          forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.equalTo(self.view).with.offset(21);
            make.right.equalTo(self.view).with.offset(-21);
            make.top.equalTo(myCashCountLabel.mas_baseline).with.offset(58);
        }];
        
        button;
    });
    
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
            make.top.equalTo(chargeMoneyButton.mas_bottom).with.offset(20);
        }];
        
        button;
    });
    [[withdrawFromWeixinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        PIEBindWeixinPaymentViewController *bindWeixinPaymentVC =
//        [PIEBindWeixinPaymentViewController new];
//        [self.navigationController pushViewController:bindWeixinPaymentVC
//                                             animated:YES];
        
        PIEWithdrawlMoneyViewController *withDrawlVC =
        [[PIEWithdrawlMoneyViewController alloc] init];
        [self.navigationController pushViewController:withDrawlVC animated:YES];
        
        
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
        label.numberOfLines = 0;
        
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(lineSeparator.mas_bottom).with.offset(44);
        }];
        
        label;
    });
    
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



@end
