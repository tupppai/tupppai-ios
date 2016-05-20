//
//  PIEMovieViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 5/17/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//


static NSString *WEB_READY = @"web_ready";


#import "PIEMovieViewController.h"
#import "TFHpple.h"




@interface PIEMovieViewController ()<UIWebViewDelegate>
@property (strong, nonatomic)  UIWebView *webView;
@property (strong, nonatomic) UIView *backView;
@property (assign, nonatomic) NSInteger clickTimes;

@end

@implementation PIEMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    self.webView.delegate = self;
    
    [self initBackButton];
    
    
    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *urlB= [NSString stringWithFormat:@"%@?version=%@&token=%@",@"http://wechupin.com/?/",version,[DDUserManager currentUser].token];    
    NSURL *nsurl=[NSURL URLWithString:urlB];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
 
}

- (void)initBackButton {
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 90, 44)];
    [self.view addSubview:_backView];
//    _backView.hidden = YES;
    
    UIButton *sysButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [sysButton setTitle:@"关闭" forState:UIControlStateNormal];
    [sysButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sysButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    sysButton.tag = 10001;
    [_backView addSubview:sysButton];
    
    UIButton *sysButton2 = [[UIButton alloc] initWithFrame:CGRectMake(45, 0, 40, 44)];
    [sysButton2 setTitle:@"返回" forState:UIControlStateNormal];
    [sysButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sysButton2 addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    sysButton2.tag = 10002;
    [_backView addSubview:sysButton2];

    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:_backView];
    leftBar.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = leftBar;
    
}

- (void)closeButtonPressed {
    [self dismissViewControllerAnimated:true completion:NULL];
}
- (void)backButtonPressed:(UIButton *)button {
    if ([self.webView canGoBack] && button.tag == 10002) {
        [self.webView  goBack];
    }
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.navigationItem.title = @"载入中...";
    
    NSLog(@"webViewDidStartLoad canGoBack%d",webView.canGoBack);
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"webViewDidFinishLoad canGoBack%d",webView.canGoBack);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSLog(@"didFailLoadWithError canGoBack%d",webView.canGoBack);

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request %@ navigationType %d canGoBack %d",request,navigationType,webView.canGoBack);
//    _backView.hidden = !webView.canGoBack;
    
    NSLog(@"shouldStartLoadWithRequest count %d ,length%f",webView.pageCount,webView.pageLength);
    return YES;
}


@end
