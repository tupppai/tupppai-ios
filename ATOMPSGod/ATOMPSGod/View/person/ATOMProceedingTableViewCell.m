//
//  ATOMProceedingTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMProceedingTableViewCell.h"

@implementation ATOMProceedingTableViewCell

static int padding10 = 10;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, padding10, 45, 45)];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.backgroundColor = [UIColor greenColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17)];
    _userSexImageView.image = [UIImage imageNamed:@"man"];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding10, 120, 30)];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00aff0];
    _userNameLabel.font = [UIFont systemFontOfSize:20.f];
    _userNameLabel.text = @"atom";
    [self addSubview:_userNameLabel];
    
    _userPublishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), 120, 15)];
    _userPublishTimeLabel.textColor = [UIColor colorWithHex:0xadadad];
    _userPublishTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _userPublishTimeLabel.text = @"3小时前";
    [self addSubview:_userPublishTimeLabel];
    
    _userUploadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userHeaderButton.frame) + padding10, 112.5, 112.5)];
//    _userUploadImageView.backgroundColor = [UIColor colorWithHex:0xf9ffff];
    _userUploadImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_userUploadImageView];
    
    _uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding10 - 57, 19, 57 , 31)];
    _uploadButton.userInteractionEnabled = NO;
    _uploadButton.backgroundColor = [UIColor colorWithHex:0x00adef];
    _uploadButton.layer.cornerRadius = 5;
    _uploadButton.layer.masksToBounds = YES;
    _uploadButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_uploadButton setTitle:@"上传作品" forState:UIControlStateNormal];
    [_uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_uploadButton];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding10 - 30, CGRectGetMaxY(_userUploadImageView.frame) - 20, 30, 20)];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_deleteButton setTitleColor:[UIColor colorWithHex:0x797979] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
}

+ (CGFloat)calculateCellHeight {
    return 187.5;
}





































@end
