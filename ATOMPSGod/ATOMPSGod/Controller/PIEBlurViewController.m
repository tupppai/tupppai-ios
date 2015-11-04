//
//  PIEBlurViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBlurViewController.h"
#import "FXBlurView.h"
@interface PIEBlurViewController ()

@end

@implementation PIEBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FXBlurView* blurView = [[FXBlurView alloc]initWithFrame:self.view.bounds];
    //configure blur view
    blurView.dynamic = NO;
//    blurView.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];
//    blurView.contentMode = UIViewContentModeBottom;
    self.view = blurView;
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
