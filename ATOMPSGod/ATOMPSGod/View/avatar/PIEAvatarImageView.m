//
//  PIEAvatarImageView.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 12/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEAvatarImageView.h"


/* variables */
@interface PIEAvatarImageView ()

@property (nonatomic, weak)UIImageView *psGodView;

@end

@implementation PIEAvatarImageView


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
        
        // 不知道怎么才能做出需求的“圆角 ＋ V”的效果。先放一边。
//        self.layer.cornerRadius = self.frame.size.width/2;
//        self.clipsToBounds = YES;
        
    }
    
    return  _psGodView;
}

#pragma mark - Setters
- (void)setIsV:(BOOL)isV
{
    _isV = isV;
    
    self.psGodView.hidden = !isV;
}



@end
