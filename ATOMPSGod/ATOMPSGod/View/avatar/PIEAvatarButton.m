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

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
        self.imageView.clipsToBounds = YES;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
        self.imageView.clipsToBounds = YES;
    }
    return self;
}
- (void) addPSGodView {
    [self addSubview:self.psGodView];
    [self.psGodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageView).with.offset(2);
        make.centerX.equalTo(self.imageView.mas_trailing);
        make.width.equalTo(self.imageView).with.multipliedBy(28.0/62.0);
        make.height.equalTo(self.imageView).with.multipliedBy(28.0/62.0);
    }];
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
