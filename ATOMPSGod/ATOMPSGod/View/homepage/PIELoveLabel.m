//
//  PIELoveLabel.m
//  TUPAI
//
//  Created by chenpeiwei on 12/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIELoveLabel.h"

@implementation PIELoveLabel

-(void)awakeFromNib {
    _numberString = @"0";
    _number = 0;
    self.font = [UIFont lightTupaiFontOfSize:10];
    
    //======== TO BE REFINED
    self.layer.cornerRadius = 6.5;
    self.clipsToBounds = YES;
    //========
    self.layer.shouldRasterize = YES;
    
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
}
-(instancetype)init {
    self = [super init];
    if (self) {
        _numberString = @"0";
        _number = 0;
        self.font = [UIFont systemFontOfSize:10];
        self.layer.cornerRadius = 6.5;
        self.clipsToBounds = YES;
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

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
////    // 1. 获取上下文
////    CGContextRef contextRef = UIGraphicsGetCurrentContext();
////    
////    // 2. 拼接路径
////    UIBezierPath *path = [UIBezierPath bezierPath];
//    
//    //
//    
//    
//}

@end
