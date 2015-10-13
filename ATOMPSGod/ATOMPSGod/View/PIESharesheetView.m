//
//  PIEShareView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESharesheetView.h"

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
            make.top.equalTo(_icon5.mas_bottom).with.offset(10);
            make.leading.equalTo(_icon1);
            make.trailing.equalTo(_icon4);
            make.height.equalTo(@40);
        }];
    }
    return self;
}
- (void)configSelf {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
}
- (void)generateData {
    _iconArray = [NSMutableArray new];
    _infoArray = [NSArray arrayWithObjects:@[@"新浪微博",@"pie_share_sina"],
                  @[@"QQ空间",@"pie_share_qqzone"],
                  @[@"朋友圈",@"pie_share_wechatmoments"],
                  @[@"微信朋友",@"pie_share_wechatfriends"],
                  @[@"QQ好友",@"pie_share_qqfriends"],
                  @[@"复制链接",@"pie_share_copylinks"],
                  @[@"QQ好友",@"pie_share_report"],
                  @[@"QQ好友",@"pie_share_collect"], nil];
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
        icon.imageView.image = [UIImage imageNamed:imageName];
    }

}
- (void)mansoryIcons {
    CGFloat itemWidth = 30;
    CGFloat itemHeight = 50;

    CGFloat rowGap = 20;
    CGFloat columnGap = ( SCREEN_WIDTH*0.95 -  itemWidth*4 ) / 4;

    [_icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(self).with.offset(columnGap/2);
        make.top.equalTo(self).with.offset(rowGap);
    }];
    
    [_icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon1.mas_trailing).with.offset(columnGap);
        make.top.equalTo(self).with.offset(rowGap);
    }];

    [_icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon2.mas_trailing).with.offset(columnGap);
        make.top.equalTo(self).with.offset(rowGap);
    }];

    [_icon4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon3.mas_trailing).with.offset(columnGap);
        make.top.equalTo(self).with.offset(rowGap);
    }];
    [_icon5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(self).with.offset(columnGap/2);
        make.top.equalTo(_icon1.mas_bottom).with.offset(rowGap);
    }];
    [_icon6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon5.mas_trailing).with.offset(columnGap);
        make.top.equalTo(_icon1.mas_bottom).with.offset(rowGap);
    }];
    [_icon7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon6.mas_trailing).with.offset(columnGap);
        make.top.equalTo(_icon1.mas_bottom).with.offset(rowGap);
    }];
    [_icon8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon7.mas_trailing).with.offset(columnGap);
        make.top.equalTo(_icon1.mas_bottom).with.offset(rowGap);
    }];
}

-(UILabel *)cancelLabel {
    if (!_cancelLabel) {
        _cancelLabel = [UILabel new];
        _cancelLabel.text = @"取消";
        _cancelLabel.font = [UIFont systemFontOfSize:15];
        _cancelLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _cancelLabel.textColor = [UIColor darkGrayColor];
        _cancelLabel.layer.cornerRadius = 10;
        _cancelLabel.clipsToBounds = YES;
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cancelLabel;
}
-(void)dismiss {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)show {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [UIView animateWithDuration:0.2 animations:^{
        self.hidden = false;
    } completion:^(BOOL finished) {
    }];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    self.frame = view.bounds;
    [view addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [UIView animateWithDuration:0.2 animations:^{
        self.hidden = false;
    } completion:^(BOOL finished) {
    }];
    
}

@end