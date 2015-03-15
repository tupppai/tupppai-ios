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

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(padding, padding, 45, 45);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, padding, 80, 30);
    _praiseButton.frame = CGRectMake(SCREEN_WIDTH - 60 - padding, padding, 60, 25);
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
    CGFloat height1 = [[self class] calculateCommentDeailTextSize:viewModel.userCommentDetail].height + 30 + padding *2;
    CGFloat height2 = 45 + padding * 2;
    return fmaxf(height1, height2);
}

- (void)createSubView {
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.backgroundColor = [UIColor brownColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:20.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userCommentDetailLabel = [UILabel new];
    _userCommentDetailLabel.numberOfLines = 0;
    _userCommentDetailLabel.font = [UIFont systemFontOfSize:20.f];
    _userCommentDetailLabel.textColor = [UIColor blackColor];
    _userSexImageView = [UIImageView new];
    
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
