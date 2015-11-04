//
//  PIEBannerWebViewViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBannerWebViewViewController.h"

@interface PIEBannerWebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PIEBannerWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *url= _viewModel.url;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
