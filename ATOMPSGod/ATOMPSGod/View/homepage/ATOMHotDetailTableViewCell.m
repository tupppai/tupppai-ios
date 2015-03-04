//
//  ATOMHotDetailTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHotDetailTableViewCell.h"

@interface ATOMHotDetailTableViewCell ()

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userPublishTimeLabel;
@property (nonatomic, strong) UIImageView *userSexImageView;
@property (nonatomic, strong) UIButton *psButton;
@property (nonatomic, strong) UIImageView *userWorkImageView;
@property (nonatomic, strong) UIButton *praiseButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UIImage *userWorkImage;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *thinCenterView;
@property (nonatomic, strong) UIView *bottomView;



@end

@implementation ATOMHotDetailTableViewCell

static CGFloat totalHeight;
static int padding = 10;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;
        [self createSubView];
        [self addGestureToView];
    }
    return self;
}

- (void)setViewModel {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
    _userHeaderButton.frame = CGRectMake(padding, padding, 45, 45);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame), padding, 80, 30);
    _userPublishTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame), CGRectGetMaxY(_userNameLabel.frame), 80, 15);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17);
    _psButton.frame = CGRectMake(SCREEN_WIDTH - padding - 46, 17.5, 46, 32);
    
    CGSize userWorkingImageViewSize = [self calculateWorkImageViewSize];
    _userWorkImageView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), userWorkingImageViewSize.width, userWorkingImageViewSize.height);
    
    _thinCenterView.frame = CGRectMake(0, CGRectGetMaxY(_userWorkImageView.frame), SCREEN_WIDTH, 40);
    
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 61);
    
    totalHeight = _topView.frame.size.height + _userWorkImageView.frame.size.height + _thinCenterView.frame.size.height + _bottomView.frame.size.height;
}

- (CGSize)calculateWorkImageViewSize {
    CGSize result;
    result.width = SCREEN_WIDTH;
    if (_userWorkImage) {
        CGFloat imageWidth = _userWorkImage.size.width;
        CGFloat imageHeight = _userWorkImage.size.height;
        CGFloat ratio = imageHeight / imageWidth;
        result.height = result.width * ratio;
    } else {
        result.height = result.width;
    }
    return result;
}

+ (CGFloat)calculateCellHeight {
    return totalHeight;
}

- (void)createSubView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    _userWorkImageView = [UIImageView new];
    _userWorkImageView.backgroundColor = [UIColor yellowColor];
    _thinCenterView = [UIView new];
    _thinCenterView.backgroundColor = [UIColor whiteColor];
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    [self addSubview:_bottomView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.backgroundColor = [UIColor brownColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    _userNameLabel = [UILabel new];
    _userNameLabel.backgroundColor = [UIColor orangeColor];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userPublishTimeLabel = [UILabel new];
    _userPublishTimeLabel.backgroundColor = [UIColor greenColor];
    _userPublishTimeLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
    _userSexImageView = [UIImageView new];
    [_userSexImageView setImage:[UIImage imageNamed:@"man"]];
    _psButton = [UIButton new];
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_normal"] forState:UIControlStateNormal];
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_pressed"] forState:UIControlStateHighlighted];
    
    [_topView addSubview:_userHeaderButton];
    [_topView addSubview:_userNameLabel];
    [_topView addSubview:_userPublishTimeLabel];
    [_topView addSubview:_userSexImageView];
    [_topView addSubview:_psButton];
    
    _praiseButton = [UIButton new];
    _shareButton = [UIButton new];
    _commentButton = [UIButton new];
    [_thinCenterView addSubview:_praiseButton];
    [_thinCenterView addSubview:_shareButton];
    [_thinCenterView addSubview:_commentButton];
    
}

- (void)addGestureToView {
    
}





@end
