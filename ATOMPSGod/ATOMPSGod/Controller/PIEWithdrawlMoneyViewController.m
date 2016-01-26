//
//  PIEWithdrawlMoneyViewController.m
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEWithdrawlMoneyViewController.h"


#import "PIEAvatarView.h"


@interface PIEWithdrawlMoneyViewController ()

@property (nonatomic, strong) UIView *titleView;

@end

@implementation PIEWithdrawlMoneyViewController

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

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBar];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - UI components setup
- (void)setupNavBar{
    self.navigationItem.titleView = self.titleView;
}

- (void)setupSubViews{
    
    PIEUserModel *currentUser = [DDUserManager currentUser];
    
    
    @weakify(self);
    // 1. 圆角头像
    PIEAvatarView *avatarImageView = ({
        PIEAvatarView *view = [[PIEAvatarView alloc] init];
        
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(CGSizeMake(71, 71));
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(27);
        }];
        
        [view.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        
        view.layer.cornerRadius = 71.0 / 2;
        view.clipsToBounds = YES;
        
        [view.avatarImageView
         sd_setImageWithURL:[NSURL URLWithString:[currentUser.avatar trimToImageWidth:200]]
         placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        view;
    });
    
    // 2. 姓名 label
    UILabel *nameLabel = ({
        UILabel *label  = [[UILabel alloc] init];
        label.font      = [UIFont mediumTupaiFontOfSize:16];
        label.text      = currentUser.nickname;
        label.textColor = [UIColor blackColor];
        
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(avatarImageView.mas_bottom).with.offset(15);
        }];
        
        label;
    });
    
    
    // 3. line separator 1
    UIView *lineSeparator1 = ({
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
        
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(nameLabel.mas_bottom).with.offset(32);
        }];
        
        view;
    });
    
    // 4. 无边框的 textField，输入提现金额
    UITextField *moneyCountTextField = ({
        UITextField *textField  = [[UITextField alloc] init];
        textField.borderStyle   = UITextBorderStyleNone;
        textField.placeholder   = @"请输入提现金额";
        textField.textAlignment = NSTextAlignmentRight;
        textField.font          = [UIFont lightTupaiFontOfSize:15];

        textField.leftViewMode  = UITextFieldViewModeAlways;
        textField.rightViewMode = UITextFieldViewModeAlways;
        
        UILabel *leftViewLabel  =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        leftViewLabel.text = @"提现金额";
        leftViewLabel.font = [UIFont lightTupaiFontOfSize:15];
        leftViewLabel.textColor = [UIColor blackColor];
        
        
        UILabel *rightViewLabel = [[UILabel alloc]
                                   initWithFrame:CGRectMake(0, 0, 20, 20)];
        rightViewLabel.text = @"元";
        rightViewLabel.textAlignment = NSTextAlignmentCenter;
        rightViewLabel.font = [UIFont lightTupaiFontOfSize:15];
        rightViewLabel.textColor = [UIColor blackColor];
        
        textField.leftView = leftViewLabel;
        textField.rightView = rightViewLabel;
        
        [self.view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(21);
            make.right.equalTo(self.view).with.offset(-10);
            make.top.equalTo(lineSeparator1.mas_bottom);
            make.height.mas_equalTo(55);
        }];
        
        textField;
    });
    
    // 5. line separator 2
    UIView *lineSeparator2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
        
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(moneyCountTextField.mas_bottom);
        }];
        view;
    });
    
    // 6. 确定 按钮
    UIButton *confirmButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
                          forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont lightTupaiFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            make.height.mas_equalTo(40);
            make.top.equalTo(lineSeparator2).with.offset(60);
        }];
        
        button;
    });
    
}

#pragma mark - Lazy loadings
- (UIView *)titleView{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        
        UILabel *title = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"确认提现";
            label.font = [UIFont lightTupaiFontOfSize:18];
            label.textColor = [UIColor blackColor];
            [_titleView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleView.mas_top);
                make.centerX.equalTo(_titleView.mas_centerX);
            }];
            
            label;
        });
        
        UILabel *subTitle = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"提现至微信账号";
            label.font = [UIFont lightTupaiFontOfSize:10];
            label.textColor = [UIColor blackColor];
            [_titleView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(title.mas_bottom);
                make.centerX.equalTo(_titleView.mas_centerX);
                
            }];
            label;
        });
        
    }
    
    return _titleView;
}

#pragma mark - touching methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
