//
//  PIEShareView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//
#define height_sheet 251.0f

#import "PIESharesheetView.h"
#import "POP.h"
@implementation PIESharesheetView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
        [self generateData];
        [self generateIcons];
        [self mansoryIcons];
        
        [self addSubview:self.cancelLabel];
        [self.cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@38);
            make.bottom.equalTo(self).with.offset(-19);
            make.leading.equalTo(self).with.offset(26);
            make.trailing.equalTo(self).with.offset(-26);
        }];
    }
    return self;
}
- (void)configSelf {
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.cornerRadius = 10;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.965, height_sheet);
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}
- (void)generateData {
    _iconArray = [NSMutableArray new];
    _infoArray = [NSArray arrayWithObjects:
                  @[@"新浪微博",@"pie_share_sina"],
                  @[@"QQ空间",@"pie_share_qqzone"],
                  @[@"朋友圈",@"pie_share_wechatmoments"],
                  @[@"微信朋友",@"pie_share_wechatfriends"],
                  @[@"QQ好友",@"pie_share_qqfriends"],
                  @[@"复制链接",@"pie_share_copylinks"],
                  @[@"举报",@"pie_share_report"],
                  @[@"收藏",@"pie_share_collect_hollow"], nil];
}
- (void)generateIcons {
    _icon1 = [PIEShareIcon new];
    _icon2 = [PIEShareIcon new];
    _icon3 = [PIEShareIcon new];
    _icon4 = [PIEShareIcon new];
    _icon5 = [PIEShareIcon new];
    _icon6 = [PIEShareIcon new];
    _icon7 = [PIEShareIcon new];
    _icon8 = [PIEShareIcon new];
    
    [self addSubview:_icon1];
    [self addSubview:_icon2];
    [self addSubview:_icon3];
    [self addSubview:_icon4];
    [self addSubview:_icon5];
    [self addSubview:_icon6];
    [self addSubview:_icon7];
    [self addSubview:_icon8];
    
    [_iconArray addObject:_icon1];
    [_iconArray addObject:_icon2];
    [_iconArray addObject:_icon3];
    [_iconArray addObject:_icon4];
    [_iconArray addObject:_icon5];
    [_iconArray addObject:_icon6];
    [_iconArray addObject:_icon7];
    [_iconArray addObject:_icon8];
    
    for (int i = 0;i < _iconArray.count;i++) {
        PIEShareIcon* icon = [_iconArray objectAtIndex:i];
        NSString* labelName = [[_infoArray objectAtIndex:i]objectAtIndex:0];
        NSString* imageName = [[_infoArray objectAtIndex:i]objectAtIndex:1];
        icon.label.text = labelName;
        [icon setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        // for toggling the state of "Collect" icon
        if (i == _iconArray.count - 1) {
            [icon setImage:[UIImage imageNamed:@"pie_share_collect"]
                  forState:UIControlStateSelected];
        }
    }
}
- (void)mansoryIcons {
    CGFloat itemWidth = 60;
    CGFloat itemHeight = 55;

    CGFloat firstGap_V = 36;
    CGFloat sencondGap_V = 28;

    CGFloat columnGap = ( SCREEN_WIDTH*0.98 -  itemWidth*4 ) / 4;

    [_icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(self).with.offset(columnGap/2);
        make.top.equalTo(self).with.offset(firstGap_V);
    }];
    
    [_icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon1.mas_trailing).with.offset(columnGap);
        make.top.equalTo(self).with.offset(firstGap_V);
    }];

    [_icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon2.mas_trailing).with.offset(columnGap);
        make.top.equalTo(self).with.offset(firstGap_V);
    }];

    [_icon4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon3.mas_trailing).with.offset(columnGap);
        make.top.equalTo(self).with.offset(firstGap_V);
    }];
    [_icon5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(self).with.offset(columnGap/2);
        make.top.equalTo(_icon1.mas_bottom).with.offset(sencondGap_V);
    }];
    [_icon6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon5.mas_trailing).with.offset(columnGap);
        make.top.equalTo(_icon1.mas_bottom).with.offset(sencondGap_V);
    }];
    [_icon7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon6.mas_trailing).with.offset(columnGap);
        make.top.equalTo(_icon1.mas_bottom).with.offset(sencondGap_V);
    }];
    [_icon8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon7.mas_trailing).with.offset(columnGap);
        make.top.equalTo(_icon1.mas_bottom).with.offset(sencondGap_V);
    }];
}

-(UILabel *)cancelLabel {
    if (!_cancelLabel) {
        _cancelLabel = [UILabel new];
        _cancelLabel.text = @"取消";
        _cancelLabel.font = [UIFont lightTupaiFontOfSize:15];
        _cancelLabel.backgroundColor = [UIColor colorWithHex:0xEBEBEB andAlpha:1.0];
        _cancelLabel.textColor = [UIColor colorWithHex:0x4a4a4a andAlpha:1.0];
        _cancelLabel.layer.cornerRadius = 20;
        _cancelLabel.clipsToBounds = YES;
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        _cancelLabel.userInteractionEnabled = YES;
        _cancelLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return _cancelLabel;
}



@end
