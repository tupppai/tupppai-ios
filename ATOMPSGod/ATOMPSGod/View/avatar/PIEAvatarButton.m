//
//  PIEAvatarButton.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 12/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEAvatarButton.h"

/* Variables */
@interface PIEAvatarButton ()

@property (nonatomic, weak)UIImageView *psGodView;

@end

@implementation PIEAvatarButton

#pragma mark - layout methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat psGodViewW = self.frame.size.width * 0.5;
    CGFloat psGodViewH = self.frame.size.height * 0.5;
    CGFloat psGodViewX = self.frame.size.width - psGodViewW;
    CGFloat psGodViewY = self.frame.size.height - psGodViewH;
    
    self.psGodView.frame = CGRectMake(psGodViewX, psGodViewY, psGodViewW, psGodViewH);
    
}

#pragma mark - lazy loadings
- (UIImageView *)psGodView
{
    if (_psGodView == nil) {
        UIImageView *psGodView = [[UIImageView alloc] init];
        [psGodView setImage:[UIImage imageNamed:@"icon_psGOD"]];
        psGodView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:psGodView];
        _psGodView = psGodView;
    }
    
    return _psGodView;
}

#pragma mark - Setters
- (void)setIsV:(BOOL)isV
{
    _isV = isV;
    
    self.psGodView.hidden = !isV;
}

@end
