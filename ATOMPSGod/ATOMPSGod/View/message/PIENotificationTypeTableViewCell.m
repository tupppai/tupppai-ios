//
//  ATOMMyMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIENotificationTypeTableViewCell.h"
#import "CustomBadge.h"

@interface PIENotificationTypeTableViewCell()

@property (nonatomic, strong) CustomBadge *badge;

@end

@implementation PIENotificationTypeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.separatorInset = UIEdgeInsetsMake(0, 50, 0, 10);
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont lightTupaiFontOfSize:14];
    }
    return self;
}
-(void)setBadgeNumber:(NSInteger)badgeNumber {
    [self.badge removeFromSuperview];
    if (badgeNumber > 0) {
        self.badge.badgeText = [NSString stringWithFormat:@"%zd",badgeNumber];
        [self addSubview:self.badge];
        [_badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).with.offset(-100);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
    }
}
- (CustomBadge *)badge {
    if (!_badge) {
        _badge = [CustomBadge customBadgeWithString:@""];
    }
    return _badge;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20,(self.frame.size.height-15)/2,20,15);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
























@end
