
//
//  PIEButton_Tag.m
//  TUPAI
//
//  Created by chenpeiwei on 12/2/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEButton_Tag.h"

@implementation PIEButton_Tag

-(instancetype)initWithText:(NSString*)text {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xf2f2f2 andAlpha:1.0];
        self.titleLabel.font = [UIFont lightTupaiFontOfSize:13];

        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[self.titleLabel font]}];
        self.frame = CGRectMake(0, 0, textSize.width+20, textSize.height+12);
        [self setTitle:text forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self setBackgroundImage:[Util imageWithColor:[UIColor pieYellowColor]] forState:UIControlStateSelected];
        [self setBackgroundImage:[Util imageWithColor:[UIColor pieYellowColor]] forState:UIControlStateHighlighted];
    }
    return self;
}




@end
