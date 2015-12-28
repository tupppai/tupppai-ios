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
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.avatarImageView];

    }
    return self;
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.avatarImageView];

        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}


- (void) addPSGodView {
    [self addSubview:self.psGodView];
    [self.psGodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageView).with.offset(2);
        make.centerX.equalTo(self.avatarImageView.mas_trailing);
        make.width.equalTo(self.avatarImageView).with.multipliedBy(28.0/62.0).with.priorityMedium();
        make.height.equalTo(self.avatarImageView).with.multipliedBy(28.0/62.0).with.priorityMedium();
        make.width.lessThanOrEqualTo(@18);
        make.height.lessThanOrEqualTo(@18);
    }];
}

#pragma mark - lazy loadings
- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {

        _avatarImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _avatarImageView.layer.cornerRadius = self.bounds.size.width / 2.0;
        [_avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
        _avatarImageView.image = [UIImage imageNamed:@"cellHolder"];
        _avatarImageView.clipsToBounds = YES;
    }
    
    return _avatarImageView;
}

- (UIImageView *)psGodView
{
    if (_psGodView == nil) {
        _psGodView = [[UIImageView alloc] init];
        [_psGodView setImage:[UIImage imageNamed:@"icon_psGOD"]];

        [_psGodView setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    return _psGodView;
}

-(void)setImage:(UIImage *)image {
    self.avatarImageView.image = image;
}

#pragma mark - setters

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
-(void)setUrl:(NSString *)url {
    _url = url;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
