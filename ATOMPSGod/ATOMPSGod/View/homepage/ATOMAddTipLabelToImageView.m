//
//  ATOMAddTipLabelToImageView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAddTipLabelToImageView.h"

@interface ATOMAddTipLabelToImageView ()

@property (nonatomic, strong) UILabel *bigLabel;
@property (nonatomic, strong) UILabel *littleLabel;
@property (nonatomic, strong) UIImageView *pointImageView;

@end

static const int BOTTOMHEIGHT = 76;
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
    _bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, SCREEN_WIDTH, 20)];
    _bigLabel.text = @"点击图片";
    _bigLabel.textColor = [UIColor colorWithHex:0xb3b3b3];
    _bigLabel.textAlignment = NSTextAlignmentCenter;
    _bigLabel.font = [UIFont systemFontOfSize:20.f];
    
    _littleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bigLabel.frame) + 6, SCREEN_WIDTH, 15)];
    _littleLabel.text = @"用标签告诉大神你要什么效果";
    _littleLabel.textColor = [UIColor colorWithHex:0xb3b3b3];
    _littleLabel.textAlignment = NSTextAlignmentCenter;
    _littleLabel.font = [UIFont systemFontOfSize:15.f];
    
    [_bottomView addSubview:_bigLabel];
    [_bottomView addSubview:_littleLabel];
    
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








@end
