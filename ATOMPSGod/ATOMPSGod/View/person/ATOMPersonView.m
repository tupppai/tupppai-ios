//
//  ATOMPersonView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPersonView.h"

@implementation ATOMPersonView

static int padding = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156)];
    _topBackGroundImageView.userInteractionEnabled = YES;
    _topBackGroundImageView.image = [UIImage imageNamed:@"header_bg"];
    [self addSubview:_topBackGroundImageView];
    
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 72) / 2, padding, 72, 72)];
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    _userHeaderButton.layer.cornerRadius = 36;
    _userHeaderButton.layer.masksToBounds = YES;
    [_topBackGroundImageView addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS)];
    _userSexImageView.image = [UIImage imageNamed:@"woman"];
    _userSexImageView.layer.cornerRadius = 8.5;
    _userSexImageView.layer.masksToBounds = YES;
    [_topBackGroundImageView addSubview:_userSexImageView];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    CGFloat centerX = SCREEN_WIDTH / 2;
    CGFloat buttonWidth = 60;
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - buttonWidth, CGRectGetMaxY(_userHeaderButton.frame) + padding, buttonWidth, 40)];
    _fansLabel.userInteractionEnabled = YES;
    _fansLabel.numberOfLines = 0;
    NSAttributedString *fansLabelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"粉丝\n123"] attributes:attributeDict];
    _fansLabel.attributedText = fansLabelText;
    _fansLabel.textAlignment = NSTextAlignmentCenter;
    [_topBackGroundImageView addSubview:_fansLabel];
    
    _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX, CGRectGetMaxY(_userHeaderButton.frame) + padding, buttonWidth, 40)];
    _praiseLabel.numberOfLines = 0;
    NSAttributedString *praiseLabelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"赞\n123"] attributes:attributeDict];
    _praiseLabel.attributedText = praiseLabelText;
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    [_topBackGroundImageView addSubview:_praiseLabel];
    
    _personTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topBackGroundImageView.frame), SCREEN_WIDTH, CGHeight(self.frame) - CGHeight(_topBackGroundImageView.frame)) style:UITableViewStylePlain];
    _personTableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _personTableView.tableFooterView = [UIView new];
    _personTableView.rowHeight = 45.f;
    [self addSubview:_personTableView];
    
}
















@end
