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
//        [self addSubview:self.imageView];
//        self.titleEdgeInsets = UIEdgeInsetsMake(40, -48, 0, 0);
//        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        self.titleLabel.font = [UIFont systemFontOfSize:12];
//        self.titleLabel.adjustsFontSizeToFitWidth = YES;
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.imageView.backgroundColor = [UIColor grayColor];
//        self.titleLabel.backgroundColor = [UIColor greenColor];
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
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self).multipliedBy(0.4);
//        make.height.equalTo(self.imageView.mas_width);
//        make.top.equalTo(self);
//        make.centerX.equalTo(self);
//    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@30);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];

}
//-(UIImageView *)imageView {
//    if (!_imageView) {
//        _imageView = [UIImageView new];
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
//    return _imageView;
//}
-(UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor darkGrayColor];
        _label.highlightedTextColor = [UIColor whiteColor];
        _label.adjustsFontSizeToFitWidth = YES;
    }
    return _label;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
//    // Move the image to the top and center it horizontally
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.y = 0;
//    imageFrame.origin.x = (self.frame.size.width / 2) - (imageFrame.size.width / 2);
//    imageFrame.size.height = imageFrame.size.width;
    self.imageView.frame = imageFrame;
//
//    // Adjust the label size to fit the text, and move it below the image
//    CGRect titleLabelFrame = self.titleLabel.frame;
//
//    
//    CGSize labelSize = [self.titleLabel.text sizeWithAttributes:
//                   @{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
//    
//    // Values are fractional -- you should take the ceilf to get equivalent values
//    labelSize = CGSizeMake(ceilf(labelSize.width), ceilf(labelSize.height));
//    
//    titleLabelFrame.size.width = labelSize.width;
//    titleLabelFrame.size.height = labelSize.height;
//    titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.width / 2);
//    titleLabelFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 10;
//    self.titleLabel.frame = titleLabelFrame;

}
@end
