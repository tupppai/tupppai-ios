//
//  PIESearchViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchViewController.h"
#import "PIESearchPageViewController.h"
#import "PIESearchUserViewController.h"
#import "CAPSPageMenu.h"

@interface PIESearchViewController ()<UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
//@property (weak, nonatomic) IBOutlet UIView *verticalLine;

@property (nonatomic, strong) UITextField *textField2;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, strong) NSString *lastSearchKeyword;

//@property (nonatomic, assign) BOOL notFirstLoading;
@property (nonatomic, assign) BOOL notFirstShowKeyboard;
@property (nonatomic) CAPSPageMenu *pageMenu;

@property (nonatomic, assign)  long long timeStamp;

@end

@implementation PIESearchViewController

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_notFirstShowKeyboard) {
        [_textField2 becomeFirstResponder];
        _notFirstShowKeyboard = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    [self setupPageMenu];
}

- (void)setupNavigationBar {
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* searchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    searchView.image = [UIImage imageNamed:@"pie_search"];
    searchView.contentMode = UIViewContentModeLeft;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"pie_search"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(tapSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem =  barBackButtonItem;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(tapCancel)];
    
    NSShadow *textShadow    = [[NSShadow alloc] init];
    textShadow.shadowOffset = CGSizeMake(0, 0);
    textShadow.shadowColor  = [UIColor clearColor];
    [rightButtonItem setTitleTextAttributes:
     @{NSShadowAttributeName:textShadow,
       NSFontAttributeName:[UIFont systemFontOfSize:14.0],
       NSForegroundColorAttributeName:[UIColor blackColor]}
                                   forState:UIControlStateNormal];
    
    
    self.navigationItem.rightBarButtonItem =  rightButtonItem;
    
    _textField2 = [[UITextField alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH - 100, 30)];
    _textField2.borderStyle = UITextBorderStyleNone;
    _textField2.placeholder = @"搜索用户或内容";
    _textField2.delegate = self;
    _textField2.font = [UIFont systemFontOfSize:14.0];
    self.navigationItem.titleView = _textField2;
    [_textField2 setReturnKeyType:UIReturnKeySearch];
//    [_textField2 addTarget:self
//                        action:@selector(textFieldDidChange:)
//              forControlEvents:UIControlEventEditingChanged];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([_lastSearchKeyword isEqualToString: textField.text ] && _lastIndex == _pageMenu.currentPageIndex ) {
    } else {
        _lastSearchKeyword = textField.text;
        _lastIndex = _pageMenu.currentPageIndex;
            if (_pageMenu.currentPageIndex == 0) {
                PIESearchUserViewController *vc = [_pageMenu.controllerArray objectAtIndex:0];;
                vc.textToSearch = textField.text;
                
                // 需求：两边一起刷新数据
                PIESearchPageViewController *vc2 = [_pageMenu.controllerArray objectAtIndex:1];
                vc2.textToSearch = textField.text;
                
            } else if (_pageMenu.currentPageIndex == 1) {
                PIESearchPageViewController *vc = [_pageMenu.controllerArray objectAtIndex:1];;
                vc.textToSearch = textField.text;
                
                // 需求：两边一起刷新数据
                PIESearchUserViewController *vc1 = [_pageMenu.controllerArray objectAtIndex:0];
                vc1.textToSearch= textField.text;
            }
        
    }


    return YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xfff119];
}
- (void) tapSearch {
    [self.textField2 becomeFirstResponder];
}
- (void) tapCancel {
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)setupPageMenu {
    // Array to keep track of controllers in page menu
    
    NSMutableArray *controllerArray = [NSMutableArray array];
    PIESearchUserViewController *controller1 = [PIESearchUserViewController new];
    controller1.title = @"用户";
    
    PIESearchPageViewController *controller2 = [PIESearchPageViewController new];
    controller2.title = @"内容";
    
    [controllerArray addObject:controller1];
    [controllerArray addObject:controller2];

    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor pieYellowColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithHex:0x000000 andAlpha:0.1],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont boldSystemFontOfSize:15.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor blackColor],
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                 CAPSPageMenuOptionSelectionIndicatorWidth:@30,
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0, 0, SCREEN_WIDTH, 100) options:parameters];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5, 4, 1, _pageMenu.menuHeight-8)];
    line.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    [_pageMenu.menuScrollView addSubview:line];
    _pageMenu.view.backgroundColor = [UIColor whiteColor];
    _pageMenu.view.layer.borderColor = [UIColor colorWithHex:0x000000 andAlpha:0.1].CGColor;
    _pageMenu.view.layer.borderWidth = 0.5;
    [self.view addSubview:_pageMenu.view];
    
    [_pageMenu.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    
}




- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}





@end
