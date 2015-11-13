//
//  PIEAgreementsViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEAgreementsViewController.h"

@interface PIEAgreementsViewController ()
@property (nonatomic,strong ) UIWebView *webView;

@end

@implementation PIEAgreementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *url= @"http://www.ps.com/mobile/agreement.html";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    self.view = self.webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
