//
//  PIEWebViewViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEWebViewViewController.h"
#import "TFHpple.h"
@interface PIEWebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation PIEWebViewViewController
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
    [self loadDataFromHtml:urlB];
    
    
    if (self.navigationController.viewControllers.count<=1) {
        [self setupNavBar];
    }
}

- (void)loadDataFromHtml:(NSString*)stringUrl {
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    
    NSString *XpathQueryStringTitle = @"//title";
    NSArray *nodes = [parser searchWithXPathQuery:XpathQueryStringTitle];
    
    NSLog(@"%@",nodes);
//    NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (TFHppleElement *element in nodes) {
        self.title = [[element firstChild]content];
    }
}

- (void)setupNavBar {
    UIButton *buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [buttonLeft setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem =  buttonItem;
}
- (void) dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
