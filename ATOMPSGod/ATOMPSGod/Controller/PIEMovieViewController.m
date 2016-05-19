//
//  PIEMovieViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 5/17/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMovieViewController.h"
#import "TFHpple.h"

@interface PIEMovieViewController ()
@property (strong, nonatomic)  UIWebView *webView;

@end

@implementation PIEMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *urlB= [NSString stringWithFormat:@"%@?version=%@&token=%@",@"http://wechupin.com/?/",version,[DDUserManager currentUser].token];
    //    NSLog(@"%@ url",urlB);
    
    NSURL *nsurl=[NSURL URLWithString:urlB];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    [self loadDataFromHtml:urlB];
 
}

- (void)loadDataFromHtml:(NSString*)stringUrl {
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    
    NSString *XpathQueryStringTitle = @"//title";
    NSArray *nodes = [parser searchWithXPathQuery:XpathQueryStringTitle];
    for (TFHppleElement *element in nodes) {
        self.title = [[element firstChild]content];
    }
}




@end
