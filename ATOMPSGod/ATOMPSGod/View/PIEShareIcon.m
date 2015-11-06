//
//  PIEShareIcon.m
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEShareIcon.h"

@implementation PIEShareIcon
-(instancetype)init {
    self = [super init];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.imageView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.label];
        [self mansory];
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.label.highlighted = highlighted;
}
- (void)mansory {

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@24);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self.imageView);
    }];

}

-(UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor darkGrayColor];
        _label.highlightedTextColor = [UIColor lightGrayColor];
        _label.adjustsFontSizeToFitWidth = YES;
//        _label.backgroundColor = [UIColor lightGrayColor];
    }
    return _label;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
//    // Move the image to the top and center it horizontally
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.y = 0;
    imageFrame.size = CGSizeMake(30,26);
    imageFrame.origin.x = (self.frame.size.width / 2) - (imageFrame.size.width / 2);
//    imageFrame.size.height = imageFrame.size.width;
    self.imageView.frame = imageFrame;
    

}
@end
