//
//  PIEChannelDetailDetailViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/3/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelDetailIntoViewController.h"

@interface PIEChannelDetailIntoViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PIEChannelDetailIntoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    
    [self.webView
     loadRequest:[NSURLRequest
                  requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Setup UI components
- (void)setupSubviews
{
    UIWebView *webView = ({
        UIWebView *webView = [[UIWebView alloc] init];
        
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor clearColor];
        webView.contentMode = UIViewContentModeScaleAspectFit;

        
        webView;
    });
    self.webView = webView;
}

@end
