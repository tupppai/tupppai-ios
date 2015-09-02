//
//  kfcButton.m
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "kfcButton.h"
#import "DDHomePageManager.h"
@interface kfcButton ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat extralWidth;
@property (nonatomic, strong) NSDictionary *attributeDict;
@end

@implementation kfcButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _number = @"0";
        self.selected = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (NSDictionary *)attributeDict {
    _attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont kfcButton], NSFontAttributeName, _currentColor, NSForegroundColorAttributeName, nil];
    return _attributeDict;
}

- (void)setNumber:(NSString *)number{
    _number = number;
    CGFloat numberWidth = [[[NSAttributedString alloc] initWithString:_number attributes:_attributeDict] size].width;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kfcButtonHeight+4+numberWidth));
    }];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
    }
    [self toggleColor];
    [self setNeedsDisplay];
}
-(void)toggleLikeWhenSelectedChanged:(BOOL)selected {
    if (_selected != selected) {
        //call setSelected (set _selected and toggle color)
        self.selected = selected;
        [self toggleNumber];
    }
}
-(void)toggleColor {
    if (self.selected) {
        _currentColor = [UIColor kfcButtonSelected];
    } else {
        _currentColor = [UIColor kfcButton];
    }
}
-(void)toggleNumber {
    if (![_number isEqualToString:kfcMaxNumberString]) {
        if (self.selected) {
                self.number =  [NSString stringWithFormat:@"%d",[_number intValue] + 1 ];
        } else {
            self.number =  [NSString stringWithFormat:@"%d",[_number intValue] - 1 ];
        }
    }
    [self setNeedsDisplay];
}
-(void)toggleSeleted {
    self.selected = !self.selected;
}
-(void)toggleLike {
    [self toggleSeleted];
    [self toggleNumber];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat numberWidth = [[[NSAttributedString alloc] initWithString:_number attributes:_attributeDict] size].width;
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor whiteColor] set];
    [rectPath fill];
    if (_selected) {
        [[UIImage imageNamed:@"btn_comment_like_pressed"] drawInRect:CGRectMake(0, 0, kfcButtonHeight, kfcButtonHeight)];
    } else {
        [_image drawInRect:CGRectMake(0, 0, kfcButtonHeight, kfcButtonHeight)];
    }
  
    [_number drawInRect:CGRectMake(kfcButtonHeight + 4, (CGHeight(rect) - 6 ) / 2 - 3,numberWidth, 12) withAttributes:self.attributeDict];
}






































@end
