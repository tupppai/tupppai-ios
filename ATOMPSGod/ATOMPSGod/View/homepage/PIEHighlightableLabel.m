//
//  PIECountLabel.m
//  TUPAI
//
//  Created by chenpeiwei on 9/24/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEHighlightableLabel.h"

@interface PIEHighlightableLabel()
@end
@implementation PIEHighlightableLabel
-(void)awakeFromNib {
    _numberString = @"0";
    _number = 0;
    self.font = [UIFont systemFontOfSize:11];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
    self.textColor = [UIColor blackColor];
}
-(instancetype)init {
    self = [super init];
    if (self) {
        _numberString = @"0";
        _number = 0;
        self.font = [UIFont systemFontOfSize:11];
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithHex:PIEColorHex];
    } else {
        self.backgroundColor = [UIColor colorWithHex:0x4a4a4a andAlpha:0.3];
    }
}

-(void)setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = [UIColor colorWithHex:PIEColorHex];
        self.number++;
    } else {
        self.backgroundColor = [UIColor colorWithHex:0x4a4a4a andAlpha:0.3];
        self.number--;
    }
}

-(void)setNumber:(NSInteger)number {
    _number = number;
    _numberString = [NSString stringWithFormat:@"%zd",number];
    self.text = [NSString stringWithFormat:@"%zd",number];
}

-(void)setNumberString:(NSString *)numberString {
    _number = [numberString integerValue];
    _numberString = numberString;
    self.text = numberString;
}
@end
