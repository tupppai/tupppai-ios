//
//  PIELoveLabel.m
//  TUPAI
//
//  Created by chenpeiwei on 12/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELoveLabel.h"
#import "UIView+RoundedCorner.h"

@implementation PIELoveLabel

-(void)awakeFromNib {
    _numberString = @"0";
    _number = 0;
    self.font = [UIFont lightTupaiFontOfSize:10];
    
    /**
        以前setRoundedCorners是可以用的，不知道为何现在失效；
        改回原先使用cornerRadius
     */
    
//    [self setRoundedCorners:UIRectCornerAllCorners radius:0.1];
    self.layer.cornerRadius  = 6.5;
    self.layer.masksToBounds = YES;
    
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
}
-(instancetype)init {
    self = [super init];
    if (self) {
        _numberString = @"0";
        _number = 0;
        self.font = [UIFont systemFontOfSize:10];
//        [self setRoundedCorners:UIRectCornerAllCorners radius:0.1];
        
        self.layer.cornerRadius  = 6.5;
        self.layer.masksToBounds = YES;
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


-(void)setStatus:(PIEPageLoveStatus)status {
    _status = status;
    switch (status) {
        case PIEPageLoveStatus0:
            self.backgroundColor = [UIColor blackColor];
            self.textColor = [UIColor whiteColor];
            break;
        case PIEPageLoveStatus1:
            self.backgroundColor = [UIColor colorWithHex:0xFF5B3F];
            self.textColor = [UIColor whiteColor];

            break;
        case PIEPageLoveStatus2:
            self.backgroundColor = [UIColor colorWithHex:0xF5A623];
            self.textColor = [UIColor whiteColor];

            break;
        case PIEPageLoveStatus3:
            self.backgroundColor = [UIColor colorWithHex:0xFFEF00];
            self.textColor = [UIColor blackColor];

            break;
        default:
            break;
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
