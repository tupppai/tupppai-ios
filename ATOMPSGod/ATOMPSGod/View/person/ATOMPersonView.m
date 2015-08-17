//
//  ATOMPersonView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPersonView.h"

@implementation ATOMPersonView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    _topBackGroundImageView.userInteractionEnabled = YES;
    _topBackGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topBackGroundImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topBackGroundImageView];
    
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - kUserBigHeaderButtonWidth) / 2, kPadding25, kUserBigHeaderButtonWidth, kUserBigHeaderButtonWidth)];
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[ATOMCurrentUser currentUser].avatar] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _userHeaderButton.layer.cornerRadius = kUserBigHeaderButtonWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [_topBackGroundImageView addSubview:_userHeaderButton];
    
    NSString *str = [NSString stringWithFormat:@"%d", (int)[ATOMCurrentUser currentUser].fansNumber];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:kFont15], NSFontAttributeName, [UIColor colorWithHex:0x74c3ff], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    CGFloat buttonWidth = 60;
    CGFloat buttonPadding = (CGRectGetMinX(_userHeaderButton.frame) - buttonWidth) / 2;
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonPadding, 0, buttonWidth, 80)];
    _fansLabel.center = CGPointMake(_fansLabel.center.x, _userHeaderButton.center.y);
    _fansLabel.userInteractionEnabled = YES;
    _fansLabel.numberOfLines = 0;
    NSMutableAttributedString *fansLabelText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n粉丝", (long)[ATOMCurrentUser currentUser].fansNumber] attributes:attributeDict];
//    [fansLabelText addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont15], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(str.length + 1, 2)];
    _fansLabel.attributedText = fansLabelText;
    _fansLabel.minimumScaleFactor = 0.7;
    _fansLabel.textAlignment = NSTextAlignmentCenter;
    [_topBackGroundImageView addSubview:_fansLabel];
    
    _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + buttonPadding, 0, buttonWidth, 80)];
    _likeLabel.center = CGPointMake(_likeLabel.center.x, _userHeaderButton.center.y);
    _likeLabel.minimumScaleFactor = 0.7;
    _likeLabel.numberOfLines = 0;
    NSMutableAttributedString *likeLabelText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n赞", (int)[ATOMCurrentUser currentUser].likeNumber] attributes:attributeDict];
    str = [NSString stringWithFormat:@"%d", (int)[ATOMCurrentUser currentUser].likeNumber];
//    [likeLabelText addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont15], NSFontAttributeName, [UIColor colorWithHex:0xc3cbd2], NSForegroundColorAttributeName, nil] range:NSMakeRange(str.length + 1, 1)];
    _likeLabel.attributedText = likeLabelText;
    _likeLabel.textAlignment = NSTextAlignmentCenter;
    [_topBackGroundImageView addSubview:_likeLabel];
    
    _personTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topBackGroundImageView.frame), SCREEN_WIDTH, CGHeight(self.frame) - CGHeight(_topBackGroundImageView.frame)) style:UITableViewStylePlain];
    _personTableView.backgroundColor = [UIColor whiteColor];
    _personTableView.tableFooterView = [UIView new];
    _personTableView.rowHeight = 60;
    _personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_personTableView];
}
















@end
