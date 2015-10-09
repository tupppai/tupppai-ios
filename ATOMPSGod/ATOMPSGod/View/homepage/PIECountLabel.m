//
//  PIECountLabel.m
//  TUPAI
//
//  Created by chenpeiwei on 9/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECountLabel.h"

@implementation PIECountLabel

-(void)awakeFromNib {
//    self.textColor = [UIColor blackColor];
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
        NSInteger count =  [self.text integerValue];
        count++;
        self.text = [NSString stringWithFormat:@"%zd",count];
    } else {
        NSInteger count =  [self.text integerValue];
        count--;
        self.text = [NSString stringWithFormat:@"%zd",count];
    }
}



@end