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
        
        [psGodView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
            make.height.equalTo(self.mas_height).multipliedBy(0.5);
            make.centerX.equalTo(self.mas_right).with.offset(-4);
            make.centerY.equalTo(self.mas_bottom).with.offset(-3);
        }];
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
