//
//  PIELaunchNextStepButton.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/9/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELaunchNextStepButton.h"

@implementation PIELaunchNextStepButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customViewSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customViewSetup];
    }
    return self;
}

- (void)customViewSetup
{
    [self setBackgroundImage:[UIImage imageNamed:@"launchViewControllerButtonBackground"]
                      forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"launchViewControllerButtonBackground_highlighted"]
                      forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont lightTupaiFontOfSize:13];
}


@end
