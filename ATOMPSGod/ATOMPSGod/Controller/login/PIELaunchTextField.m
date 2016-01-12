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
    self.font          = [UIFont lightTupaiFontOfSize:13];
    self.textColor     = [UIColor blackColor];
    self.borderStyle   = UITextBorderStyleNone;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.background    = [UIImage imageNamed:@"pie_launch_textFieldBorder"];
}

#pragma mark - overridden methods
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect textRect     = [super textRectForBounds:bounds];
    textRect.origin.x   += 12;
    textRect.size.width -= 12;
    return textRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect editingTextRect     = [super editingRectForBounds:bounds];
    editingTextRect.origin.x   += 12;
    editingTextRect.size.width -= 12;
    return editingTextRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect rightViewRect = [super rightViewRectForBounds:bounds];
    
    rightViewRect.origin.x -= 7;
    
    return rightViewRect;
}

@end
