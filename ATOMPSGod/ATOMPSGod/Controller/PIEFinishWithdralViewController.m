//
//  PIEFinishWithdralViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/21/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFinishWithdralViewController.h"


@interface PIEFinishWithdralViewController ()
@end

@implementation PIEFinishWithdralViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    [super viewWillAppear:animated];
}

#pragma mark - UI components setup
- (void)setupNavBar
{
    self.navigationItem.title = @"微信绑定";
    UIButton *buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [buttonLeft setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem =  buttonItem;
    
    [buttonLeft addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismiss {
    if (self.navigationController.viewControllers.count <= 1) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupSubViews
{
    @weakify(self);
    // wallet button
    UIImageView *walletIconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"pie_finishWithdral_wallet"];
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(CGSizeMake(75, 100));
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(15);
        }];
        imageView;
    });
    
    
    // withdrawlCount label
    UILabel *withdrawlCountLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        NSString *promptText =
        [NSString stringWithFormat:@"¥ %.2f",_amount];
        label.text = promptText;
        label.font = [UIFont lightTupaiFontOfSize:21];
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
        
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.view);
            make.top.equalTo(walletIconImageView.mas_bottom).with.offset(32);
        }];
        
        label;
    });
    
    
    // withdrawlPrompt label
    UILabel *withdrawlPromptLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        NSString *promptText =
        [NSString stringWithFormat:@"提现申请已提交，请去微信查看"];
        label.text = promptText;
        label.font = [UIFont lightTupaiFontOfSize:14];
        label.textColor = [UIColor colorWithHex:0x7f7f7f];
        label.numberOfLines = 0;
        
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.view);
            make.top.equalTo(withdrawlCountLabel.mas_bottom).with.offset(32);
        }];
        
        
        label;
        
    });
    
    // finish button
    UIButton *finishButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor]
                     forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:16];
        [button setBackgroundImage:
         [UIImage imageNamed:@"pie_myWallet_chargeButton"]
                          forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.height.mas_equalTo(40);
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            make.top.equalTo(withdrawlPromptLabel.mas_bottom).with.offset(66);
        }];
        
        button;
    });
    [[finishButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self dismiss];
    }];
    
    // timePrompt label
    UILabel *timePromptLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        NSString *promptText =
        [NSString stringWithFormat:@"预计24小时内到账"];
        label.text = promptText;
        label.font = [UIFont lightTupaiFontOfSize:14];
        label.textColor = [UIColor colorWithHex:0x7f7f7f];
        label;
    });
    
    [self.view addSubview:timePromptLabel];
    [timePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.view);
        make.top.equalTo(finishButton.mas_bottom).with.offset(20);
    }];

    
}

@end
