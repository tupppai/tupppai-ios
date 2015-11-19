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
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _viewModel.desc;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *url= [NSString stringWithFormat:@"%@?version=%@&token=%@",_viewModel.url,version,[DDUserManager currentUser].token];
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
