//
//  PIEAvatarView.m
//  tupai-demo
//
//  Created by TUPAI-Huangwei on 12/27/15.
//  Copyright © 2015 TUPAI-Huangwei. All rights reserved.
//

#import "PIEAvatarView.h"

@interface PIEAvatarView ()


@property (nonatomic, strong) UIImageView *psGodView;

@end


@implementation PIEAvatarView

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.psGodView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.psGodView];
    }
    
    return self;
}

#pragma mark - layout methods
- (void)layoutSubviews
{
    self.avatarImageView.frame = self.bounds;
    
    // 也许是这里代码的设计有点问题，先后次序没搞对：设置corderRadius一定要在这里，其他地方bounds 没有值。(懒加载的时机不对？)
    _avatarImageView.layer.cornerRadius = self.bounds.size.width / 2.0;

    CGFloat psGodWH = self.avatarImageView.frame.size.width / 2;
    CGFloat psGodY  = self.avatarImageView.frame.size.height - psGodWH;
    CGFloat psGodX  = self.avatarImageView.frame.size.width  - psGodWH + 3;
    
    self.psGodView.frame = CGRectMake(psGodX, psGodY, psGodWH, psGodWH);
    
    [super layoutSubviews];
}



#pragma mark - lazy loadings
- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView setContentMode:UIViewContentModeScaleToFill];
        
        [_avatarImageView clipsToBounds];
    }
    
    return _avatarImageView;
}

- (UIImageView *)psGodView
{
    if (_psGodView == nil) {
        _psGodView = [[UIImageView alloc] init];
        [_psGodView setImage:[UIImage imageNamed:@"icon_psGOD"]];
        [_avatarImageView setContentMode:UIViewContentModeScaleToFill];
        
    }
    
    return _psGodView;
}

#pragma mark - setters

- (void)setIsV:(BOOL)isV
{
    _isV = isV;
    
    self.psGodView.hidden = !isV;
}


@end
