//
//  PIEBindWeixinPaymentViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/21/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBindWeixinPaymentViewController.h"




@interface PIEBindWeixinPaymentViewController ()

@end

@implementation PIEBindWeixinPaymentViewController

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
    [self setupNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
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
    // invalid weixin icon
    @weakify(self);
    UIImageView *paleWeixinIcon = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pie_bindWeixinPayment_paleWeixin"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(CGSizeMake(74, 74));
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(40);
        }];
        imageView;
    });
    
    // title
    UILabel *title = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.text = @"第一步    请绑定微信";
        label.font = [UIFont lightTupaiFontOfSize:21];
        label.textColor = [UIColor blackColor];
        
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.view);
            make.top.equalTo(paleWeixinIcon.mas_bottom).with.offset(50);
        }];
        
        label;
    });
    
    // subtitle
    UILabel *subtitle = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.text = @"绑定的微信将成为你的提现账户";
        label.font = [UIFont lightTupaiFontOfSize:14];
        label.textColor = [UIColor blackColor];
        
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.view);
            make.top.equalTo(title.mas_bottom).with.offset(18);
        }];
        
        label;
    });
    
    // bindWeixinPayment button
    UIButton *bindWeixinPaymentButton = ({
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:@"绑定" forState:UIControlStateNormal];
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
            make.top.equalTo(subtitle.mas_bottom).with.offset(85);
        }];
        
        button;
    });
    [[bindWeixinPaymentButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            [DDShareManager authorize2:SSDKPlatformTypeWechat withBlock:^(SSDKUser *user) {
                NSMutableDictionary *params = [NSMutableDictionary <NSString *, NSString *> new];
                params[@"type"]             = @"weixin";
                params[@"openid"]           = user.uid;
                [DDBaseService POST:params
                                url:@"auth/bind"
                              block:^(id responseObject) {
                                  if (responseObject) {
                                      [DDUserManager currentUser].bindWechat = YES;
                                      [DDUserManager updateCurrentUserInDatabase];
                                      [Hud success:@"绑定微信成功"];
                                  } else {
                                      [Hud error:@"绑定微信失败"];
                                  }
                                  
                                  BOOL success = !(responseObject == nil);
                                  if (_delegate && [_delegate respondsToSelector:@selector(bindWechatViewController:success:)]) {
                                      [_delegate bindWechatViewController:self success:success];
                                  }
                                  [self dismiss];
                              }];
            }];
        
    }];
    
}



@end
