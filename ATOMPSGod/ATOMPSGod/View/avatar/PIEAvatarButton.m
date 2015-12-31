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

@property (nonatomic, strong)UIImageView *psGodView;

@end

@implementation PIEAvatarButton

- (void) addPSGodView {
    [self addSubview:self.psGodView];
    [self.psGodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageView);
        make.trailing.equalTo(self.imageView);
        
        make.width.equalTo(self.imageView).with.multipliedBy(22.0/62.0).with.priorityHigh();
        make.height.equalTo(self.imageView).with.multipliedBy(22.0/62.0).with.priorityHigh();
        
        make.width.lessThanOrEqualTo(@18);
        make.height.lessThanOrEqualTo(@18);
        
    }];
    self.psGodView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.psGodView.layer.borderWidth = 1;
    self.psGodView.layer.cornerRadius = (self.bounds.size.width * (22.0 / 62.0)) / 2;
    self.psGodView.layer.masksToBounds = YES;
    self.psGodView.layer.shouldRasterize = YES;
}

#pragma mark - layout methods
- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = self.bounds; 
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.shouldRasterize = YES;
}
#pragma mark - lazy loadings
- (UIImageView *)psGodView
{
    if (_psGodView == nil) {
         _psGodView = [[UIImageView alloc] init];
        [_psGodView setImage:[UIImage imageNamed:@"icon_psGOD"]];
        _psGodView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _psGodView;
}

#pragma mark - Setters
- (void)setIsV:(BOOL)isV
{
    _isV = isV;
    
    if (_isV) {
        [self addPSGodView];
        _psGodView.hidden = NO;
    } else {
        if (_psGodView) {
            _psGodView.hidden = YES;
        }
    }
}

@end
