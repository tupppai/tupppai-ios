//
//  PIESignUpSheetView.m
//  TUPAI
//
//  Created by chenpeiwei on 10/19/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESignUpSheetView.h"

@implementation PIESignUpSheetView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
        [self generateData];
        [self generateIcons];
        [self mansoryIcons];
        [self generateCloseView];
    }
    return self;
}

- (void)generateCloseView {
    [self addSubview:self.closeView];
    [self.closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_icon1.mas_bottom).with.offset(29);
        make.centerX.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
}

- (void)configSelf {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
}
- (void)generateData {
    _iconArray = [NSMutableArray new];
    _infoArray = [NSArray arrayWithObjects:@[@"QQ注册",@"pie_signup_qq"],
                  @[@"微信注册",@"pie_signup_wechat"],
                  @[@"手机注册",@"pie_signup_phone"], nil];
}
- (void)generateIcons {
    _icon1 = [PIEShareIcon new];
    _icon2 = [PIEShareIcon new];
    _icon3 = [PIEShareIcon new];
    
    [self addSubview:_icon1];
    [self addSubview:_icon2];
    [self addSubview:_icon3];
    
    [_iconArray addObject:_icon1];
    [_iconArray addObject:_icon2];
    [_iconArray addObject:_icon3];
    
    for (int i = 0;i < _iconArray.count;i++) {
        PIEShareIcon* icon = [_iconArray objectAtIndex:i];
        NSString* labelName = [[_infoArray objectAtIndex:i]objectAtIndex:0];
        NSString* imageName = [[_infoArray objectAtIndex:i]objectAtIndex:1];
        icon.label.text = labelName;
        [icon setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
}
- (void)mansoryIcons {
    CGFloat itemWidth = 80;
    CGFloat itemHeight = 60;
    
    CGFloat rowGap = 30;
    CGFloat columnGap = ( SCREEN_WIDTH*0.98 -  itemWidth*3 ) / 3;
    
    [_icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.trailing.equalTo(_icon2.mas_leading).with.offset(-columnGap);
        make.top.equalTo(self).with.offset(rowGap);
    }];
    [_icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(rowGap);
    }];
    
    [_icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemHeight));
        make.leading.equalTo(_icon2.mas_trailing).with.offset(columnGap);
        make.top.equalTo(self).with.offset(rowGap);
    }];
}

-(UIImageView *)closeView {
    if (!_closeView) {
        _closeView = [UIImageView new];
        _closeView.userInteractionEnabled = YES;
        _closeView.image = [UIImage imageNamed:@"pie_signup_close"];
        _closeView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _closeView;
}
@end
