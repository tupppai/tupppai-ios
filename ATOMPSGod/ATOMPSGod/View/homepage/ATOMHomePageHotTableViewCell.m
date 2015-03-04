//
//  ATOMHomePageHotTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomePageHotTableViewCell.h"

@interface ATOMHomePageHotTableViewCell ()



@end

@implementation ATOMHomePageHotTableViewCell

static CGFloat totalHeight;
static int padding = 10;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;
        [self createSubView];
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
    
    CGSize userWorkingImageViewSize = [self calculateWorkImageViewSize];
    _userWorkImageView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), userWorkingImageViewSize.width, userWorkingImageViewSize.height);
    _thinCenterView.frame = CGRectMake(0, userWorkingImageViewSize.height-30, SCREEN_WIDTH, 30);
    
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_userWorkImageView.frame), SCREEN_WIDTH, 61);
    _totalPSButton.frame = CGRectMake(SCREEN_WIDTH - padding - 46, (_bottomView.frame.size.height - 25) / 2, 46, 25);
    
    totalHeight = _topView.frame.size.height + _userWorkImageView.frame.size.height + _bottomView.frame.size.height;
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
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
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
    [_topView addSubview:_userHeaderButton];
    [_topView addSubview:_userNameLabel];
    [_topView addSubview:_userPublishTimeLabel];
    [_topView addSubview:_userSexImageView];
    
    _thinCenterView = [UIView new];
    _thinCenterView.backgroundColor = [UIColor blackColor];
    _thinCenterView.alpha = 0.5;
    [_userWorkImageView addSubview:_thinCenterView];
    
    _praiseButton = [UIButton new];
    _shareButton = [UIButton new];
    _commentButton = [UIButton new];
    [_thinCenterView addSubview:_praiseButton];
    [_thinCenterView addSubview:_shareButton];
    [_thinCenterView addSubview:_commentButton];
    
    _totalPSButton = [UIButton new];
    _totalPSButton.backgroundColor = [UIColor whiteColor];
    _totalPSButton.layer.cornerRadius = 3;
    _totalPSButton.layer.masksToBounds = YES;
    [_bottomView addSubview:_totalPSButton];
    
}




















@end
