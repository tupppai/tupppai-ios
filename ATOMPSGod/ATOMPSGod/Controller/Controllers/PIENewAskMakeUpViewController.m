//
//  PIENewAskMakeUpViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/7.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENewAskMakeUpViewController.h"

@interface PIENewAskMakeUpViewController ()

@property (nonatomic, assign) BOOL isFirstLoading;

@property (nonatomic, assign) NSMutableArray *source;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) long long timeStamp;

@property (nonatomic, assign) BOOL canRefreshFooter;



@end

@implementation PIENewAskMakeUpViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
