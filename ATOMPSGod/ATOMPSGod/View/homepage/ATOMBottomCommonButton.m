//
//  ATOMBottomCommonButton.m
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBottomCommonButton.h"
#import "ATOMShowHomepage.h"
@interface ATOMBottomCommonButton ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat extralWidth;
@property (nonatomic, strong) NSDictionary *attributeDict;
@end

@implementation ATOMBottomCommonButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _extralWidth = 24 + kPadding5;
        self.selected = NO;
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

- (void)setNumber:(NSString *)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (!_selected) {
        _currentColor = [UIColor colorWithHex:0xcdcdcd];
        NSLog(@"toggle color 1");
    } else {
        _currentColor = [UIColor colorWithHex:0xfe8282];
        NSLog(@"toggle color 2");
    }
    [self setNeedsDisplay];
    
}

//- (void)toggleLike:(BOOL)selected {
//    //call setSelected and change color
//    self.selected = selected;
//    if (!selected) {
//        [self.delegate untapLikeButton:self];
//    } else {
//        [self.delegate tapLikeButton:self];
//    }
//}
//
- (void)toggleLike:(NSInteger)id{
    
    //call setSelected() and change color
    self.selected = !self.selected;
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSInteger status = !_selected? 0:1;
    NSInteger one = !_selected? -1:1;
    [param setValue:@(status) forKey:@"status"];
    ATOMShowHomepage * showHomepage = [ATOMShowHomepage new];
    [showHomepage toggleLike:param withID:id withBlock:^(NSString *msg, NSError *error) {
            if (!error) {
                NSLog(@"Server成功toggle like");
                NSInteger number = [_number integerValue]+one;
                [self setNumber:[NSString stringWithFormat:@"%ld",(long)number]];
            } else {
                NSLog(@"Server失败 toggle like");
            }
        }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor whiteColor] set];
    [rectPath fill];
    if (_selected) {
        [[UIImage imageNamed:@"btn_comment_like_pressed"] drawInRect:CGRectMake(0, 0, kBottomCommonButtonWidth, kBottomCommonButtonWidth)];
    } else {
        [_image drawInRect:CGRectMake(0, 0, kBottomCommonButtonWidth, kBottomCommonButtonWidth)];
    }
    [_number drawInRect:CGRectMake(kBottomCommonButtonWidth + kPadding5, (CGHeight(rect) - kFont10) / 2, CGWidth(rect) - _extralWidth, kFont10) withAttributes:self.attributeDict];
}






































@end
