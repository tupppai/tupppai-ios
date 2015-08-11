//
//  ATOMAddTipLabelToImageView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAddTipLabelToImageView.h"

@interface ATOMAddTipLabelToImageView ()

@property (nonatomic, strong) UIImageView *pointImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *bigLabel;
@property (nonatomic, strong) UILabel *smallLabel;
@property (nonatomic, assign) int BOTTOMHEIGHT;


@end



static int padding10 = 10;

@implementation ATOMAddTipLabelToImageView

- (instancetype)init {
    self = [super init];
    if (self) {
         _BOTTOMHEIGHT = (SCREEN_HEIGHT-NAV_HEIGHT)-(SCREEN_WIDTH-kPadding15*2)*4/3;
        [self createSubView];
    }
    return self;
}

- (void)setWorkImage:(UIImage *)workImage {
    _workImage = workImage;
    _workImageView = [[UIImageView alloc] initWithFrame:[self calculateImageViewFrame]];
    _workImageView.contentMode = UIViewContentModeScaleAspectFit;
    _workImageView.userInteractionEnabled = YES;
    _workImageView.image = _workImage;
    [self createBlinkBlinkPoint];
    [self createOperationButton];
    [_imageContainerView addSubview:_workImageView];
}

- (void)createSubView {
    self.backgroundColor = [UIColor whiteColor];
    _imageContainerView = [[UIView alloc] initWithFrame:CGRectMake(kPadding15, 0, SCREEN_WIDTH,SCREEN_HEIGHT - NAV_HEIGHT -  _BOTTOMHEIGHT)];

    [self addSubview:_imageContainerView];
    [self createBottomView];
}

- (void)createBlinkBlinkPoint {
    _pointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag_point"]];
    _pointImageView.hidden = YES;
    [_workImageView addSubview:_pointImageView];
}

- (void)createBottomView {
//    NSString *str = [[NSUserDefaults standardUserDefaults] objectforKey:@"AskOrReply"];
//    if ([str isEqualToString:@"Reply"]) {
//        CGFloat buttonInterval = 25;
//        CGFloat xlButtonLeftPadding = (SCREEN_WIDTH - 3 * buttonInterval - 4 * 28) / 2;
//        _xlButton = [[UIButton alloc] initWithFrame:CGRectMake(xlButtonLeftPadding, padding10, 28, 28)];
//        _wxButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_xlButton.frame) + buttonInterval, padding10, 28, 28)];
//        _qqButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_wxButton.frame) + buttonInterval, padding10, 28, 28)];
//        _qqzoneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_qqButton.frame) + buttonInterval, padding10, 28, 28)];
//        [self setCommonButton:_xlButton WithImage:[UIImage imageNamed:@"weibo_grey"] AndSelectedImage:[UIImage imageNamed:@"weibo"]];
//        [self setCommonButton:_wxButton WithImage:[UIImage imageNamed:@"wechat_grey"] AndSelectedImage:[UIImage imageNamed:@"wechat"]];
//        [self setCommonButton:_qqButton WithImage:[UIImage imageNamed:@"qq_grey"] AndSelectedImage:[UIImage imageNamed:@"qq"]];
//        [self setCommonButton:_qqzoneButton WithImage:[UIImage imageNamed:@"qqzone_grey"] AndSelectedImage:[UIImage imageNamed:@"qqzone"]];
//        
//        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, padding10, xlButtonLeftPadding, 28)];
//        _tipLabel.text = @"同步到:";
//        _tipLabel.textColor = [UIColor colorWithHex:0x666666];
//        _tipLabel.textAlignment = NSTextAlignmentCenter;
//        [_bottomView addSubview:_tipLabel];
//    } else
    
//        if ([str isEqualToString:@"Ask"]) {
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAV_HEIGHT - _BOTTOMHEIGHT, SCREEN_WIDTH, _BOTTOMHEIGHT)];
    [self addSubview:_bottomView];
    _bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _BOTTOMHEIGHT/5, SCREEN_WIDTH, 30)];
    _bigLabel.text = @"点击图片";
    _bigLabel.textColor = [UIColor colorWithHex:0x637685];
    _bigLabel.font = [UIFont systemFontOfSize:18];
    _bigLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_bigLabel];
    _smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bigLabel.frame) + 20, SCREEN_WIDTH, 12)];
    _smallLabel.text = @"在标签里添加你要的效果";
    _smallLabel.textColor = [UIColor colorWithHex:0x637685];
    _smallLabel.font = [UIFont systemFontOfSize:14];
    _smallLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_smallLabel];
    NSString *pushTypeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"AskOrReply"];
    if ([pushTypeStr isEqualToString:@"Reply"]) {
        _bigLabel.text = @"求PS大神";
        _smallLabel.text = @"感谢有你";
        }
    
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(10.0f, 0.0f, _bottomView.frame.size.width-20, 1.0f);
    TopBorder.backgroundColor = [UIColor colorWithHex:0xc6c6c6 andAlpha:0.8].CGColor;
    [_bottomView.layer addSublayer:TopBorder];
}

//- (void) setCommonButton:(UIButton *)button WithImage:(UIImage *)image AndSelectedImage:(UIImage *)simage {
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button setBackgroundImage:simage forState:UIControlStateSelected];
//    [_bottomView addSubview:button];
//}

- (CGRect)calculateImageViewFrame {

    CGFloat maxWith = SCREEN_WIDTH-kPadding15*2;
    CGFloat maxHeight = SCREEN_HEIGHT - _BOTTOMHEIGHT - NAV_HEIGHT;
    CGFloat imageScale = maxWith/_workImage.size.width;
    CGFloat relativeHeight = _workImage.size.height*imageScale;
    CGPoint location;
    
    CGRect rect;
    if (relativeHeight <= maxHeight) {
            rect = CGRectMake(0, 0, maxWith, relativeHeight);
    } else {
            rect = CGRectMake(0, 0, maxWith, maxHeight);
    }
    if ((int)_workImage.size.width <= maxWith) {
        location.x = (maxWith - _workImage.size.width) / 2;
    } else {
        location.x = 0;
    }

    location.y = (maxHeight - rect.size.height) / 2;
    rect.origin = location;
    return rect;
    
}

- (void)createOperationButton {
    CGFloat centerY = CGHeight(_workImageView.frame) / 2;
    _changeTipLabelDirectionButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, centerY - 28, 41, 41)];
    [_changeTipLabelDirectionButton setBackgroundImage:[UIImage imageNamed:@"btn_changeside_normal"] forState:UIControlStateNormal];
    [_changeTipLabelDirectionButton setBackgroundImage:[UIImage imageNamed:@"btn_changeside_pressed"] forState:UIControlStateHighlighted];
    [self addSubview:_changeTipLabelDirectionButton];
    _changeTipLabelDirectionButton.hidden = YES;
    
    _deleteTipLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, centerY + 28, 41, 41)];
    [_deleteTipLabelButton setBackgroundImage:[UIImage imageNamed:@"btn_delete_normal"] forState:UIControlStateNormal];
    [_deleteTipLabelButton setBackgroundImage:[UIImage imageNamed:@"btn_delete_pressed"] forState:UIControlStateHighlighted];
    [self addSubview:_deleteTipLabelButton];
    _deleteTipLabelButton.hidden = YES;
}

- (void)showOperationButton {
    _changeTipLabelDirectionButton.hidden = NO;
    _deleteTipLabelButton.hidden = NO;
}

- (void)hideOperationButton {
    _changeTipLabelDirectionButton.hidden = YES;
    _deleteTipLabelButton.hidden = YES;
}

- (BOOL)isOperationButtonShow {
    return !_changeTipLabelDirectionButton.hidden;
}

- (void)addTemporaryPointAt:(CGPoint)point {
    if (point.x <= CGWidth(_workImageView.frame) / 2) {
        _pointImageView.frame = CGRectMake(point.x, point.y - 7.5, 15, 15);
        _pointImageView.hidden = NO;
    } else {
        _pointImageView.frame = CGRectMake(point.x - 15, point.y - 7.5, 15, 15);
        _pointImageView.hidden = NO;
    }

}

- (void)removeTemporaryPoint {
    _pointImageView.hidden = YES;
}

//- (void)changeStatusOfShareButton:(UIButton *)button {
//    if (button == _xlButton) {
//        _xlButton.selected = YES;
//        _wxButton.selected = NO;
//        _qqButton.selected = NO;
//        _qqzoneButton.selected = NO;
//    } else if (button == _wxButton) {
//        _xlButton.selected = NO;
//        _wxButton.selected = YES;
//        _qqButton.selected = NO;
//        _qqzoneButton.selected = NO;
//    } else if (button == _qqButton) {
//        _xlButton.selected = NO;
//        _wxButton.selected = NO;
//        _qqButton.selected = YES;
//        _qqzoneButton.selected = NO;
//    } else if (button == _qqzoneButton) {
//        _xlButton.selected = NO;
//        _wxButton.selected = NO;
//        _qqButton.selected = NO;
//        _qqzoneButton.selected = YES;
//    }
//    
//}























@end
