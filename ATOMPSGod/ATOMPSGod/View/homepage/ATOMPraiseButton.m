//
//  ATOMPraiseButton.m
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPraiseButton.h"
#import "ATOMShowDetailOfComment.h"

@interface ATOMPraiseButton ()

@property (nonatomic, strong) NSDictionary *attributeDict;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat extralWidth;

@end

@implementation ATOMPraiseButton

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _extralWidth = 14 + kPadding5 * 2 + 2;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (NSDictionary *)attributeDict {
    _attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, _currentColor, NSForegroundColorAttributeName, nil];
    return _attributeDict;
}

- (void)setLikeNumber:(NSString *)likeNumber{
    _likeNumber = likeNumber;
    [self setNeedsDisplay];
}
//toggle Color and Number
-(void)toggleLike {
    [self toggleSelected];
    [self toggleNumber];
}
- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    [self toggleColor];
    [self setNeedsDisplay];
}
//toggle Color
-(void)toggleColor {
    if (self.selected) {
        _currentColor = [UIColor colorWithHex:0xfe8282];
    } else {
        _currentColor = [UIColor colorWithHex:0xb2b2b2];
    }
}
//toggle Number
-(void)toggleNumber {
    if (self.selected) {
        self.likeNumber =  [NSString stringWithFormat:@"%ld",[_likeNumber integerValue] + 1 ];
    } else {
        self.likeNumber =  [NSString stringWithFormat:@"%ld",[_likeNumber integerValue] - 1 ];
    }
    [self setNeedsDisplay];
}
//toggle Selected andColor  
-(void)toggleSelected {
    self.selected = !self.selected;
}



- (void)drawRect:(CGRect)rect {
    NSLog(@"like number in drawRect %@",_likeNumber);
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor whiteColor] set];
    [rectPath fill];
    if (self.selected) {
        [[UIImage imageNamed:@"icon_like_pressed"] drawInRect:CGRectMake(0, 0, 14, 13)];
    } else {
        [[UIImage imageNamed:@"icon_like_normal"] drawInRect:CGRectMake(0, 0, 14, 13)];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(14 + kPadding5, 5.5, 2, 2)];
    [_currentColor set];
    [path fill];
    CGRect praiseRect = CGRectMake(_extralWidth, 0, CGWidth(rect) - _extralWidth, CGHeight(rect));
    NSLog(@"%@", NSStringFromCGRect(praiseRect));
    [_likeNumber drawInRect:praiseRect withAttributes:self.attributeDict];
}























@end
