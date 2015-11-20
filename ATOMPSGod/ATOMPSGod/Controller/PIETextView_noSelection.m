//
//  PIETextView.m
//  TUPAI
//
//  Created by chenpeiwei on 11/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIETextView_noSelection.h"
#import "PIEWebViewViewController.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
@implementation PIETextView_noSelection

-(void)awakeFromNib {
    [self commonInit];
}
-(instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(void)commonInit {
    self.editable = NO;
    self.scrollEnabled = NO;
    self.dataDetectorTypes = UIDataDetectorTypeLink;
    self.delegate = self;
}

-(BOOL)canBecomeFirstResponder {
    return NO;
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    PIEWebViewViewController* vc = [PIEWebViewViewController new];
    vc.url = [URL absoluteString];
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES ];
    return NO;
}

@end
