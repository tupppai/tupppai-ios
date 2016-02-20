//
//  PIEFinishWithdrawMoneyViewController_new.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/17/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFinishWithdrawMoneyViewController_new.h"
#import "UINavigationBar+Awesome.h"
#import "PIEMyWalletViewController_new.h"

@interface PIEFinishWithdrawMoneyViewController_new ()
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIImageView *luckmoneyBagImageView;
@property (nonatomic, weak) UILabel     *withdrawAmountLabel;
@property (nonatomic, weak) UILabel     *rmbChineseCharacterLabel;
@property (nonatomic, weak) UILabel     *finishWithdrawPromptLabel;
@property (nonatomic, weak) UILabel     *nextStepPromptLabel;


@end

@implementation PIEFinishWithdrawMoneyViewController_new
#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavBar];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - UI components setup
- (void)setupSubviews
{
    // 背景，黄色
    UIImageView *backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode  = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"pie_withdrawSucceed_background"];
        
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        imageView;
    });
    self.backgroundImageView = backgroundImageView;
    
    // 福袋
    UIImageView *luckyMoneyBagImageView =({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.image = [UIImage imageNamed:@"myWallet_luckmoneyBag"];
        
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(74);
            make.width.mas_equalTo(168);
            make.height.mas_equalTo(202);
            make.centerX.equalTo(self.view);
        }];
        imageView;
    });
    
    UILabel *withdrawAmountLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.text = _withdrawAmountStr;
        label.font = [UIFont lightTupaiFontOfSize:28];
        label.textColor = [UIColor whiteColor];
        [luckyMoneyBagImageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(luckyMoneyBagImageView).with.offset(-6);
            make.centerY.equalTo(luckyMoneyBagImageView);
        }];
        
        label;
    });
    self.withdrawAmountLabel = withdrawAmountLabel;
    
    // "元" label
    UILabel *rmbChineseCharacterLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.text      = @"元";
        label.textColor = [UIColor whiteColor];
        label.font      = [UIFont lightTupaiFontOfSize:13];
        
        [luckyMoneyBagImageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.baseline.equalTo(withdrawAmountLabel.mas_baseline);
            make.left.equalTo(withdrawAmountLabel.mas_right).with.offset(5);
        }];
        
        label;
    });
    self.rmbChineseCharacterLabel = rmbChineseCharacterLabel;
    
    // "提现成功!" label
    UILabel *finishWithdrawPromptLabel = ({
        UILabel *label  = [[UILabel alloc] init];

        label.text      = @"提现成功！";
        label.textColor = [UIColor whiteColor];
        label.font      = [UIFont lightTupaiFontOfSize:13];
        
        [luckyMoneyBagImageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(luckyMoneyBagImageView).with.offset(5);
            make.top.equalTo(withdrawAmountLabel.mas_baseline).with.offset(18);
        }];
        
        label;
    });
    self.finishWithdrawPromptLabel = finishWithdrawPromptLabel;
    
    // 领红包方式Label
    UILabel *nextStepPromptLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.text = @"请至图派微信公众号领取红包";
        label.font = [UIFont lightTupaiFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0xFF5757];
        
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(luckyMoneyBagImageView.mas_bottom).with.offset(40);
        }];
        
        label;
    });
    self.nextStepPromptLabel = nextStepPromptLabel;
    
    
}

- (void)setupNavBar
{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithHex:0xFFD117]];
    
    UIBarButtonItem *leftButtonItem =
    [[UIBarButtonItem alloc]
     initWithImage:[UIImage imageNamed:@"nav_back_white"]
     style:UIBarButtonItemStylePlain target:self
     action:@selector(leftBarButtonClicked)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

#pragma mark - target-Actions
- (void)leftBarButtonClicked
{
    [self segueBackToMyWallet];
}

#pragma mark - touching methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self segueBackToMyWallet];
}

#pragma mark - segue methods
- (void)segueBackToMyWallet
{
    // Question：怎样才能pop到MyWalletVC_new那里？我必须要时刻保持着那个引用吗？用segue？
    [self.navigationController popViewControllerAnimated:YES];
    
    
    PIEMyWalletViewController_new *myWalletVC = nil;
    // 遍历一次controllers, 找到那个MywalletVC
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[PIEMyWalletViewController_new class]]) {
            myWalletVC = (PIEMyWalletViewController_new *)viewController;
            break;
        }
    }
    
    [self.navigationController popToViewController:myWalletVC animated:YES];
}

@end
