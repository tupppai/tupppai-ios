//
//  ATOMMyMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyMessageTableViewCell.h"

@implementation ATOMMyMessageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIImageView* arrowImageView = [UIImageView new];
//        arrowImageView.contentMode = UIViewContentModeCenter;
//        self.textLabel.textColor = [UIColor colorWithHex:0x737373 andAlpha:1.0];
//        arrowImageView.image = [UIImage imageNamed:@"ic_right-arrow"];
//        self.accessoryView = arrowImageView;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.separatorInset = UIEdgeInsetsMake(0, kPadding20, 0, kPadding20);
        self.textLabel.textColor = [UIColor colorWithHex:0x737373];
    }
    return self;
}

//- (void)createSubViewConstaints {
//    
//    [self.themeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        NSLog(@"themeImageView mas");
//        make.left.equalTo(self).with.offset(kPadding28);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(24, 24));
//    }];
//    
//    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_themeImageView.mas_right).with.offset(kPadding20);
//        make.centerY.equalTo(self);
//    }];
//}

#pragma mark - Getter & Setter
//
//-(UIImageView *)themeImageView {
//    if (!_themeImageView) {
//        _themeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _themeImageView.contentMode = UIViewContentModeCenter;
//    }
//    return _themeImageView;
//}
//-(UILabel *)themeLabel {
//    if (!_themeLabel) {
//        _themeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _themeLabel.font =  [UIFont fontWithName:@"Hiragino Sans GB W3" size:kFont14];
//        _themeLabel.textColor = [UIColor darkGrayColor];
//    }
//    return _themeLabel;
//}
























@end
