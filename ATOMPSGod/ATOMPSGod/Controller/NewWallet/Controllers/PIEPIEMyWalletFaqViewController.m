//
//  PIEPIEMyWalletFaqViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/4/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPIEMyWalletFaqViewController.h"

@interface PIEPIEMyWalletFaqViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PIEPIEMyWalletFaqViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    [self.webView
     loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI componennts setup 
- (void)setupSubviews
{
    UIWebView *webView = ({
        UIWebView *webView = [[UIWebView alloc] init];
        
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor clearColor];
        webView.contentMode     = UIViewContentModeScaleAspectFit;
        
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        webView;
    });
    self.webView = webView;
}

@end
