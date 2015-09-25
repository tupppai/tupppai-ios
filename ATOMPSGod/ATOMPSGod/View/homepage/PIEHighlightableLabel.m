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
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
    self.textColor = [UIColor blackColor];
}
//-(instancetype)init {
//    self = [super init];
//    if (self) {
//        self.layer.cornerRadius = self.frame.size.height/2;
//        self.clipsToBounds = YES;
//    }
//    return self;
//}
-(void)setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = [UIColor colorWithHex:PIEColorHex];
        NSInteger count =  [self.text integerValue];
        count++;
        self.text = [NSString stringWithFormat:@"%zd",count];
    } else {
        self.backgroundColor = [UIColor clearColor];
        NSInteger count =  [self.text integerValue];
        count--;
        self.text = [NSString stringWithFormat:@"%zd",count];
    }
}


@end
