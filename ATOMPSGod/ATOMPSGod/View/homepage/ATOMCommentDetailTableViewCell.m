//
//  ATOMCommentDetailTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDetailTableViewCell.h"
#import "ATOMCommentDetailViewModel.h"

@interface ATOMCommentDetailTableViewCell ()



@end

@implementation ATOMCommentDetailTableViewCell

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
    if (_viewModel.isFirst) {
        if (_isViewRed) {
            _littleVerticalRedView.frame = CGRectMake(padding, padding, 2, padding * 2);
            _hotCommentLabel.frame = CGRectMake(CGRectGetMaxX(_littleVerticalRedView.frame) + padding, padding, 80, padding *2);
            _littleVerticalBlueView.frame = CGRectZero;
            _recentCommentLabel.frame = CGRectZero;
        } else {
            _littleVerticalBlueView.frame = CGRectMake(padding, padding, 2, padding * 2);
            _recentCommentLabel.frame = CGRectMake(CGRectGetMaxX(_littleVerticalBlueView.frame) + padding, padding, 80, padding *2);
            _littleVerticalRedView.frame = CGRectZero;
            _hotCommentLabel.frame = CGRectZero;
        }
    } else {
        _littleVerticalRedView.frame = CGRectZero;
        _littleVerticalBlueView.frame = CGRectZero;
        _hotCommentLabel.frame = CGRectZero;
        _recentCommentLabel.frame = CGRectZero;
    }
    
    if (_isViewRed == YES) {
        _userHeaderButton.frame = CGRectMake(padding, CGRectGetMaxY(_littleVerticalRedView.frame) + padding, 45, 45);
        _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMaxY(_littleVerticalRedView.frame) + padding, 80, 30);
        _praiseButton.frame = CGRectMake(SCREEN_WIDTH - 60 - padding, CGRectGetMaxY(_littleVerticalRedView.frame) + padding, 60, 25);
    } else {
        _userHeaderButton.frame = CGRectMake(padding, CGRectGetMaxY(_littleVerticalBlueView.frame) + padding, 45, 45);
        _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMaxY(_littleVerticalBlueView.frame) + padding, 80, 30);
        _praiseButton.frame = CGRectMake(SCREEN_WIDTH - 60 - padding, CGRectGetMaxY(_littleVerticalBlueView.frame) + padding, 60, 25);
    }
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17);
    CGSize commentDetailTextSize = [[self class] calculateCommentDeailTextSize:_viewModel.userCommentDetail];
    _userCommentDetailLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMaxY(_userNameLabel.frame), commentDetailTextSize.width, commentDetailTextSize.height);
    
}

+ (CGSize)calculateCommentDeailTextSize:(NSString *)commentDetailStr {
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.f], NSFontAttributeName, nil];
    CGSize actualSize = [commentDetailStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding * 2 - 55, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    return actualSize;
}

+ (CGFloat)calculateCellHeightWithModel:(ATOMCommentDetailViewModel *)viewModel {
    CGFloat extraHeight = viewModel.isFirst ? padding * 3 : 0;
    CGFloat height1 = extraHeight + [[self class] calculateCommentDeailTextSize:viewModel.userCommentDetail].height + 30 + padding *2;
    CGFloat height2 = extraHeight + 45 + padding * 2;
    return fmaxf(height1, height2);
}

- (void)createSubView {
    
    _littleVerticalRedView = [UIView new];
    _littleVerticalRedView.backgroundColor = [UIColor colorWithHex:0xf80630];
    _littleVerticalBlueView = [UIView new];
    _littleVerticalBlueView.backgroundColor = [UIColor colorWithHex:0x00adef];
    _hotCommentLabel = [UILabel new];
    _hotCommentLabel.text = @"最热评论";
    _hotCommentLabel.textColor = [UIColor colorWithHex:0x6e6e70];
    _recentCommentLabel = [UILabel new];
    _recentCommentLabel.text = @"最新评论";
    _recentCommentLabel.textColor = [UIColor colorWithHex:0x6e6e70];
    
    [self addSubview:_littleVerticalRedView];
    [self addSubview:_littleVerticalBlueView];
    [self addSubview:_hotCommentLabel];
    [self addSubview:_recentCommentLabel];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.backgroundColor = [UIColor brownColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    _userNameLabel = [UILabel new];
    //    _userNameLabel.backgroundColor = [UIColor orangeColor];
//    _userNameLabel.text = @"宋祥伍";
    _userNameLabel.font = [UIFont systemFontOfSize:20.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userCommentDetailLabel = [UILabel new];
    _userCommentDetailLabel.numberOfLines = 0;
    _userCommentDetailLabel.font = [UIFont systemFontOfSize:20.f];
//        _userCommentDetailLabel.backgroundColor = [UIColor greenColor];
//    _userCommentDetailLabel.text = @"灰色的技术的房价开始了对方就阿里快速的风景阿里可是对方就卡死的减肥尽快了解阿克苏登陆福建按快了点睡觉法拉克是点击付款 克拉大书法家阿斯顿两份简历看见阿斯顿发了卡上打饭卡里看见阿斯蒂芬徕卡就是的放假了安师大飞拉萨到付款记录";
    _userCommentDetailLabel.textColor = [UIColor blackColor];
    _userSexImageView = [UIImageView new];
//    [_userSexImageView setImage:[UIImage imageNamed:@"man"]];
    
    [self addSubview:_userHeaderButton];
    [self addSubview:_userNameLabel];
    [self addSubview:_userCommentDetailLabel];
    [self addSubview:_userSexImageView];
    
    _praiseButton = [UIButton new];
//    _praiseButton.backgroundColor = [UIColor orangeColor];
    [_praiseButton setImage:[UIImage imageNamed:@"icon_like_normal"] forState:UIControlStateNormal];
    [_praiseButton setImage:[UIImage imageNamed:@"btn_comment_like_pressed"] forState:UIControlStateSelected];
    [_praiseButton setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 4, 5)];
//    [_praiseButton setTitle:@"10" forState:UIControlStateNormal];
    [_praiseButton setTitleEdgeInsets:UIEdgeInsetsMake(4, 5, 4, 0)];
    [_praiseButton setTitleColor:[UIColor colorWithHex:0x6e6e70] forState:UIControlStateNormal];
    [_praiseButton setTitleColor:[UIColor colorWithHex:0xf80630] forState:UIControlStateSelected];
    _praiseButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [self addSubview:_praiseButton];
    
}

- (void)setViewModel:(ATOMCommentDetailViewModel *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.userName;
    if ([viewModel.userSex isEqualToString:@"woman"]) {
        [_userSexImageView setImage:[UIImage imageNamed:@"woman"]];
    } else {
        [_userSexImageView setImage:[UIImage imageNamed:@"man"]];
    }
    
    _userCommentDetailLabel.text = viewModel.userCommentDetail;
    [_praiseButton setTitle:viewModel.praiseNumber forState:UIControlStateNormal];
    [self setNeedsLayout];
}





















@end
