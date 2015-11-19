//
//  PIEAboutUsViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEAboutUsViewController.h"

@interface PIEAboutUsViewController ()
@property (nonatomic,strong ) UIWebView *webView;

@end

@implementation PIEAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.view = self.webView;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *url= [NSString stringWithFormat:@"%@mobile/contacts.html?version=%@&token=%@",[DDSessionManager shareHTTPSessionManager].baseURL,version,[DDUserManager currentUser].token];
    
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
