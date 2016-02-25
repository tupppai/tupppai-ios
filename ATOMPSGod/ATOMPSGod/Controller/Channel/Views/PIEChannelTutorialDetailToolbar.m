//
//  PIEChannelTutorialDetailToolbar.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/26/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialDetailToolbar.h"

@implementation PIEChannelTutorialDetailToolbar


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [self commonInit];
    
}

+ (PIEChannelTutorialDetailToolbar *)toolbar
{
    return [[[NSBundle mainBundle]
             loadNibNamed:@"PIEChannelTutorialDetailToolbar"
             owner:nil options:nil] lastObject];
}

- (void)commonInit
{
    self.rollDiceButton.titleLabel.numberOfLines = 0;
    [self.rollDiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rollDiceButton setTitle:@"超级赞随机打赏\n1元内" forState:UIControlStateNormal];
    self.rollDiceButton.titleLabel.font = [UIFont lightTupaiFontOfSize:11];
    self.rollDiceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.rollDiceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 13);
    
    self.rollDiceButton.adjustsImageWhenHighlighted = NO;
}


- (void)setHasBought:(BOOL)hasBought
{
    _hasBought = hasBought;
    
    if (hasBought) {
        self.rollDiceButton.selected = YES;
    }
}

@end
