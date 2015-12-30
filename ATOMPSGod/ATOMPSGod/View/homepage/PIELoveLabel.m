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
    self.layer.cornerRadius = 6.5;
    self.clipsToBounds = YES;
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


-(void)setStatus:(PIELoveButtonStatus)status {
    _status = status;
    switch (status) {
        case PIELoveButtonStatusNormal:
            self.backgroundColor = [UIColor blackColor];
            self.textColor = [UIColor whiteColor];
            break;
        case PIELoveButtonStatusSelectedLow:
            self.backgroundColor = [UIColor colorWithHex:0xFF5B3F];
            self.textColor = [UIColor whiteColor];

            break;
        case PIELoveButtonStatusSelectedMedium:
            self.backgroundColor = [UIColor colorWithHex:0xF5A623];
            self.textColor = [UIColor whiteColor];

            break;
        case PIELoveButtonStatusSelectedHigh:
            self.backgroundColor = [UIColor colorWithHex:0xFFEF00];
            self.textColor = [UIColor blackColor];

            break;
        default:
            break;
    }
}

- (void)increaseCount {
    //利用变化后的status
    switch (self.status) {
        case PIELoveButtonStatusNormal:
            self.number -= 3;
            break;
        case PIELoveButtonStatusSelectedLow:
            self.number += 1;
            break;
        case PIELoveButtonStatusSelectedMedium:
            self.number += 1;
            break;
        case PIELoveButtonStatusSelectedHigh:
            self.number += 1;
            break;
        default:
            break;
    }
}
- (void)decreaseCount {
    switch (self.status) {
        case PIELoveButtonStatusNormal:
            self.number -= 1;
            break;
        case PIELoveButtonStatusSelectedLow:
            self.number -= 1;
            break;
        case PIELoveButtonStatusSelectedMedium:
            self.number -= 1;
            break;
        case PIELoveButtonStatusSelectedHigh:
            self.number += 3;
            break;
        default:
            break;
    }
}
- (void)revert {
    switch (self.status) {
        case PIELoveButtonStatusNormal:
            break;
        case PIELoveButtonStatusSelectedLow:
            self.number -= 1;
            break;
        case PIELoveButtonStatusSelectedMedium:
            self.number -= 2;
            break;
        case PIELoveButtonStatusSelectedHigh:
            self.number -= 3;
            break;
        default:
            break;
    }
    self.status = PIELoveButtonStatusNormal;
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
