//
//  PIELaunchTextField.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/9/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELaunchTextField.h"

@implementation PIELaunchTextField

#pragma mark - initial setup
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configureCustomView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self configureCustomView];
    }
    
    return self;
}

- (void)configureCustomView
{
    self.font               = [UIFont lightTupaiFontOfSize:13];
    self.textColor          = [UIColor blackColor];
    self.borderStyle        = UITextBorderStyleLine;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
