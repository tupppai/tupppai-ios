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

@end

static const int BOTTOMHEIGHT = 150;
static int padding10 = 10;

@implementation ATOMAddTipLabelToImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)setWorkImage:(UIImage *)workImage {
    _workImage = workImage;
    _workImageView = [[UIImageView alloc] initWithFrame:[self calculateImageViewFrame]];
    _workImageView.userInteractionEnabled = YES;
    _workImageView.image = _workImage;
    [self createTemporaryPoint];
    [self createOperationButton];
    [self addSubview:_workImageView];
}

- (void)createSubView {
    self.backgroundColor = [UIColor whiteColor];
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAV_HEIGHT - BOTTOMHEIGHT, SCREEN_WIDTH, BOTTOMHEIGHT)];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xf4f7f7];
    [self addSubview:_bottomView];
    [self createBottomView];
}

- (void)createTemporaryPoint {
    _pointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag_point"]];
    _pointImageView.hidden = YES;
    [_workImageView addSubview:_pointImageView];
}

- (void)createBottomView {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"UploadingOrSeekingHelp"];
    if ([str isEqualToString:@"Uploading"]) {
        CGFloat buttonInterval = 25;
        CGFloat xlButtonLeftPadding = (SCREEN_WIDTH - 3 * buttonInterval - 4 * 28) / 2;
        _xlButton = [[UIButton alloc] initWithFrame:CGRectMake(xlButtonLeftPadding, padding10, 28, 28)];
        _wxButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_xlButton.frame) + buttonInterval, padding10, 28, 28)];
        _qqButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_wxButton.frame) + buttonInterval, padding10, 28, 28)];
        _qqzoneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_qqButton.frame) + buttonInterval, padding10, 28, 28)];
        [self setCommonButton:_xlButton WithImage:[UIImage imageNamed:@"weibo_grey"] AndSelectedImage:[UIImage imageNamed:@"weibo"]];
        [self setCommonButton:_wxButton WithImage:[UIImage imageNamed:@"wechat_grey"] AndSelectedImage:[UIImage imageNamed:@"wechat"]];
        [self setCommonButton:_qqButton WithImage:[UIImage imageNamed:@"qq_grey"] AndSelectedImage:[UIImage imageNamed:@"qq"]];
        [self setCommonButton:_qqzoneButton WithImage:[UIImage imageNamed:@"qqzone_grey"] AndSelectedImage:[UIImage imageNamed:@"qqzone"]];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, padding10, xlButtonLeftPadding, 28)];
        _tipLabel.text = @"同步到:";
        _tipLabel.textColor = [UIColor colorWithHex:0x666666];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:_tipLabel];
    } else if ([str isEqualToString:@"SeekingHelp"]) {
        _bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, SCREEN_WIDTH, 30)];
        _bigLabel.text = @"点击图片";
        _bigLabel.textColor = [UIColor colorWithHex:0xb3b3b3];
        _bigLabel.font = [UIFont systemFontOfSize:30.f];
        _bigLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:_bigLabel];
        _smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bigLabel.frame) + 20, SCREEN_WIDTH, 12)];
        _smallLabel.text = @"在标签里添加你要的效果";
        _smallLabel.textColor = [UIColor colorWithHex:0xb3b3b3];
        _smallLabel.font = [UIFont systemFontOfSize:18.f];
        _smallLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:_smallLabel];
    }
}

- (void) setCommonButton:(UIButton *)button WithImage:(UIImage *)image AndSelectedImage:(UIImage *)simage {
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:simage forState:UIControlStateSelected];
    [_bottomView addSubview:button];
}

- (CGRect)calculateImageViewFrame {
    
    CGFloat maxWith = SCREEN_WIDTH;
    CGFloat maxHeight = SCREEN_HEIGHT - BOTTOMHEIGHT - NAV_HEIGHT;
    CGFloat imageScale;
    CGPoint location;
    
    CGRect rect = CGRectMake(0, 0, _workImage.size.width, _workImage.size.height);
    if ((int)CGWidth(rect) <= maxWith && (int)CGHeight(rect) <= maxHeight) {
        location.x = (maxWith - _workImage.size.width) / 2;
        location.y = (maxHeight - _workImage.size.height) / 2;
        rect.origin = location;
        return rect;
    }
    
    imageScale = maxHeight / _workImage.size.height;
    rect = CGRectMake(0, 0, _workImage.size.width * imageScale, _workImage.size.height * imageScale);
    if ((int)CGWidth(rect) <= maxWith && (int)CGHeight(rect) <= maxHeight) {
        location.x = (maxWith - rect.size.width) / 2;
        location.y = (maxHeight - rect.size.height) / 2;
        rect.origin = location;
        return rect;
    }
    
    imageScale = maxWith / _workImage.size.width;
    rect = CGRectMake(0, 0, _workImage.size.width * imageScale, _workImage.size.height * imageScale);
    location.x = (maxWith - rect.size.width) / 2;
    location.y = (maxHeight - rect.size.height) / 2;
    rect.origin = location;
    return rect;
    
}

- (void)createOperationButton {
    CGFloat centerY = CGHeight(_workImageView.frame) / 2;
    _changeTipLabelDirectionButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, centerY - 28, 41, 41)];
    [_changeTipLabelDirectionButton setBackgroundImage:[UIImage imageNamed:@"btn_changeside_normal"] forState:UIControlStateNormal];
    [_changeTipLabelDirectionButton setBackgroundImage:[UIImage imageNamed:@"btn_changeside_pressed"] forState:UIControlStateHighlighted];
    [_workImageView addSubview:_changeTipLabelDirectionButton];
    _changeTipLabelDirectionButton.hidden = YES;
    
    _deleteTipLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, centerY + 28, 41, 41)];
    [_deleteTipLabelButton setBackgroundImage:[UIImage imageNamed:@"btn_delete_normal"] forState:UIControlStateNormal];
    [_deleteTipLabelButton setBackgroundImage:[UIImage imageNamed:@"btn_delete_pressed"] forState:UIControlStateHighlighted];
    [_workImageView addSubview:_deleteTipLabelButton];
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

- (void)changeStatusOfShareButton:(UIButton *)button {
    if (button == _xlButton) {
        _xlButton.selected = YES;
        _wxButton.selected = NO;
        _qqButton.selected = NO;
        _qqzoneButton.selected = NO;
    } else if (button == _wxButton) {
        _xlButton.selected = NO;
        _wxButton.selected = YES;
        _qqButton.selected = NO;
        _qqzoneButton.selected = NO;
    } else if (button == _qqButton) {
        _xlButton.selected = NO;
        _wxButton.selected = NO;
        _qqButton.selected = YES;
        _qqzoneButton.selected = NO;
    } else if (button == _qqzoneButton) {
        _xlButton.selected = NO;
        _wxButton.selected = NO;
        _qqButton.selected = NO;
        _qqzoneButton.selected = YES;
    }
    
}























@end
