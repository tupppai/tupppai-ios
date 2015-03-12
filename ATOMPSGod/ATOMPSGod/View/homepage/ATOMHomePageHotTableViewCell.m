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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, padding, 80, 30);
    _userPublishTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMaxY(_userNameLabel.frame), 80, 15);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17);
    
    CGSize userWorkingImageViewSize = [self calculateWorkImageViewSize];
    _userWorkImageView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), userWorkingImageViewSize.width, userWorkingImageViewSize.height);
    _thinCenterView.frame = CGRectMake(0, userWorkingImageViewSize.height-30, SCREEN_WIDTH, 30);
    _praiseButton.frame = CGRectMake(padding, 0, 60, 30);
    _shareButton.frame = CGRectMake(CGRectGetMaxX(_praiseButton.frame), 0, 60, 30);
    _commentButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 30);
    
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

+ (CGRect)calculateHomePageHotImageViewRect:(UIImageView *)imageView {
    CGRect rect = imageView.frame;
//    NSLog(@"origin height = %f",rect.size.height);
    rect.size.height -= 30;
    return rect;
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
    
    _userHeaderButton = [UIImageView new];
    _userHeaderButton.backgroundColor = [UIColor brownColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    _userNameLabel = [UILabel new];
//    _userNameLabel.backgroundColor = [UIColor orangeColor];
    _userNameLabel.text = @"宋祥伍";
    _userNameLabel.font = [UIFont systemFontOfSize:20.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userPublishTimeLabel = [UILabel new];
//    _userPublishTimeLabel.backgroundColor = [UIColor greenColor];
    _userPublishTimeLabel.text = @"3小时前";
    _userPublishTimeLabel.font = [UIFont systemFontOfSize:10.f];
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
    [_praiseButton setImage:[UIImage imageNamed:@"btn_comment_like_normal"] forState:UIControlStateNormal];
    [_praiseButton setImage:[UIImage imageNamed:@"btn_comment_like_pressed"] forState:UIControlStateSelected];
    [_praiseButton setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 5)];
    [_praiseButton setTitle:@"100" forState:UIControlStateNormal];
    [_praiseButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 5, 7, 0)];
    [_praiseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_praiseButton setTitleColor:[UIColor colorWithHex:0xf80630] forState:UIControlStateSelected];
    _praiseButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    _shareButton = [UIButton new];
    [_shareButton setImage:[UIImage imageNamed:@"btn_newshare"] forState:UIControlStateNormal];
    [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 5)];
    [_shareButton setTitle:@"100" forState:UIControlStateNormal];
    [_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 5, 7, 0)];
    [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    _commentButton = [UIButton new];
    [_commentButton setImage:[UIImage imageNamed:@"btn_newcomment"] forState:UIControlStateNormal];
    [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 5)];
    [_commentButton setTitle:@"100" forState:UIControlStateNormal];
    [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 5, 7, 0)];
    [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    
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
