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
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = self.frame.size.width/2;
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = self.frame.size.width/2;
        self.clipsToBounds = NO;
    }
    
    return self;
}

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

        /*
             severe bug in PIECommentReplyHeaderView:
             可能是因为自动布局产生的影响；最后改用手写frame布局，问题引刃而解。
         */
//        [psGodView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(self.mas_width).multipliedBy(0.5);
//            make.height.equalTo(self.mas_height).multipliedBy(0.5);
//            make.centerX.equalTo(self.mas_right).with.offset(-4);
//            make.centerY.equalTo(self.mas_bottom).with.offset(-3);
//        }];
        
//        [self layoutIfNeeded];
        

 
        
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
