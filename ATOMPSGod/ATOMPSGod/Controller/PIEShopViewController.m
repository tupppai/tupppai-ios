//
//  PIEShopViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 5/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEShopViewController.h"

#import "YZSDK.h"
#import "CacheUserInfo.h"


//warning:目前使用的是 libYouzan_debug SDK,不是发行版本

@interface PIEShopViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *commonWebView;
@property (strong, nonatomic) UIView *backView;

@end

@implementation PIEShopViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commonWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.commonWebView];
    self.commonWebView.scalesPageToFit = YES;
    self.commonWebView.backgroundColor = [UIColor clearColor];
    self.commonWebView.contentMode = UIViewContentModeScaleAspectFit;
    self.commonWebView.delegate = self;

    [self initBackButton];
    
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self loadRequestFromString:@"https://wap.koudaitong.com/v2/showcase/homepage?alias=5q58ne2k"];
    
    
//    NSDictionary* textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
//    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString {
    
    CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
    if(!cacheModel.isValid) {
        
        YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
        [YZSDK registerYZUser:userModel callBack:^(NSString *message, BOOL isError) {
            if(isError) {
                cacheModel.isValid = NO;
            } else {
                cacheModel.isValid = YES;
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                [self.commonWebView loadRequest:urlRequest];
            }
        }];
    } else {
        cacheModel.isValid = YES;
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.commonWebView loadRequest:urlRequest];
    }
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
    if ([self.commonWebView canGoBack] && button.tag == 10002) {
        [self.commonWebView  goBack];
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

    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.navigationItem.title = [self.commonWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self.commonWebView stringByEvaluatingJavaScriptFromString:[[YZSDK sharedInstance] jsBridgeWhenWebDidLoad]];
//        _backView.hidden = !webView.canGoBack;
        
    }


}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    _backView.hidden = !webView.canGoBack;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    
    if(![[url absoluteString] hasPrefix:@"http"]){//非http
//        
//        NSString *jsBridageString = [[YZSDK sharedInstance] parseYOUZANScheme:url];
//
//        if(jsBridageString) {
//            
//            CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
//            if([jsBridageString isEqualToString:CHECK_LOGIN] && !cacheModel.isValid) {
//                
//                if(cacheModel.isLogined) {//【如果是您是先登录，在打开我们商城，走这种方式】
//                    YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
//                    NSString *string = [[YZSDK sharedInstance] webUserInfoLogin:userModel];
//                    [self.commonWebView stringByEvaluatingJavaScriptFromString:string];
//                    return YES;
//                }
//                //【如果您需要使用自己原生的登录，看这里的代码】
//                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                UINavigationController *navigation = [board instantiateViewControllerWithIdentifier:@"loginnav"];
//                LoginViewController *loginVC = [navigation.viewControllers objectAtIndex:0];
//                loginVC.loginBlock = ^(CacheUserInfo *cacheModel) {
//                    NSString *string = [[YZSDK sharedInstance] webUserInfoLogin:[CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel]];
//                    [self.commonWebView stringByEvaluatingJavaScriptFromString:string];
//                };
//                [self presentViewController:navigation animated:YES completion:^{
//                    
//                }];
//                return NO;
//                
//            } else if([jsBridageString isEqualToString:SHARE_DATA]) {//【分享请看这里】
//                
//                NSDictionary * shareDic = [[YZSDK sharedInstance] shareDataInfo:url];
//                NSString *message = [NSString stringWithFormat:@"title:%@ \\n 链接: %@ " , shareDic[SHARE_TITLE],shareDic[SHARE_LINK]];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据已经获取到了,赶紧来分享吧" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
//                [alertView show];
//                
//            } else if([jsBridageString isEqualToString:WEB_READY]) {
//                
//                self.navigationItem.rightBarButtonItem.enabled = YES;
//                _shareButton.hidden = NO;
//                
//            } else if ([[url absoluteString] hasSuffix:@"common/prefetching"]) {//加载静态资源 暂时先屏蔽
//                
//                return YES;
//                
//            }  else if([jsBridageString isEqualToString:WX_PAY]) { //【微信支付暂时用的有赞wap微信支付，我们给您的链接已经包含了微信支付所有信息，直接可以唤起您手机上的微信，进行支付，分享之后因为不是走微信注册的模式，所以无法直接返回您的App，详细可以看文档说明】
//                
//                //如果是微信自有支付或者app支付，现在基本没有商户在使用app支付了，因此这里默认是微信自有支付
//                
//                [YZSDK selfWXPayURL:url callback:^(NSDictionary *response, NSError *error) {
//                    
//                    //返回的是一个包含微信支付的字典，取出微信支付相对应的参数
//                    /*
//                     PayReq* req  = [[PayReq alloc] init];
//                     req.openID   = response[@"response"][@"appid"];
//                     req.partnerId  = response[@"response"][@"partnerid"];
//                     req.prepayId  = response[@"response"][@"prepayid"];
//                     req.nonceStr  = response[@"response"][@"noncestr"];
//                     req.timeStamp   = (unsigned int)[response[@"response"][@"timestamp"] longValue];
//                     req.package  = response[@"response"][@"package"];
//                     req.sign   = response[@"response"][@"sign"];
//                     [WXApi sendReq:req]; */
//                }];
//            }
        }
//    }
    return YES;
}

- (void) sharePage {//【分享是被动的，所以要给出点击事件进行触发】
    NSString *jsonString = [[YZSDK sharedInstance] jsBridgeWhenShareBtnClick];
    [self.commonWebView stringByEvaluatingJavaScriptFromString:jsonString];
    
}

@end

