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
//
- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    [self toggleColor];
    [self setNeedsDisplay];
}
-(void)toggleColor {
    if (self.selected) {
        _currentColor = [UIColor colorWithHex:0xfe8282];
    } else {
        _currentColor = [UIColor colorWithHex:0xb2b2b2];
    }
}
-(void)toggleNumber {
    if (self.selected) {
        self.likeNumber =  [NSString stringWithFormat:@"%ld",[_likeNumber integerValue] + 1 ];
    } else {
        self.likeNumber =  [NSString stringWithFormat:@"%ld",[_likeNumber integerValue] - 1 ];
    }
    [self setNeedsDisplay];
}

-(void)toggleApperance {
    self.selected = !self.selected;
    [self toggleColor];
    [self toggleNumber];
}

//- (void)toggleLike:(NSInteger)commentID {
//    //call setSelected() and change color
//    self.selected = !self.selected;
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    NSInteger status = !self.selected? 0:1;
//    NSInteger likeNumber = !self.selected? -1:1;
//    [param setValue:@(status) forKey:@"status"];
//    
//    ATOMShowDetailOfComment * showCommentDetail = [ATOMShowDetailOfComment new];
//    [showCommentDetail toggleLike:param withID:commentID withBlock:^(NSError *error) {
//        if (!error) {
//            NSLog(@"Server成功toggle like");
//            NSInteger number = [_praiseNumber integerValue]+likeNumber;
//            [self setPraiseNumber:[NSString stringWithFormat:@"%ld",(long)number]];
//        } else {
//            NSLog(@"Server失败 toggle like");
//        }
//
//    }];
// 
//}

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
