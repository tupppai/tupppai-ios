//
//  PIEWebViewViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEWebViewViewController.h"

@interface PIEWebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PIEWebViewViewController
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *urlB = @"";
    if (_viewModel) {
        self.title = _viewModel.desc;
        urlB= [NSString stringWithFormat:@"%@?version=%@&token=%@",_viewModel.url,version,[DDUserManager currentUser].token];

    } else if (_url) {
        urlB= [NSString stringWithFormat:@"%@?version=%@&token=%@",_url,version,[DDUserManager currentUser].token];
    }

    NSURL *nsurl=[NSURL URLWithString:urlB];
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
