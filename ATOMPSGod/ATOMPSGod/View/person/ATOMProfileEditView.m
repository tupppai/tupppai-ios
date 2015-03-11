//
//  ATOMProfileEditView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMProfileEditView.h"

@interface ATOMProfileEditView ()

@property (nonatomic, strong) UIView *nickNameView;
@property (nonatomic, strong) UIView *sexView;
@property (nonatomic, strong) UIView *areaView;

@end

@implementation ATOMProfileEditView

static int padding10 = 10;
static int padding25 = 25;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        self.backgroundColor = [UIColor colorWithHex:0xededed];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    
    _nickNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62.5)];
    _sexView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nickNameView.frame), SCREEN_WIDTH, 62.5)];
    _areaView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_sexView.frame), SCREEN_WIDTH, 62.5)];
    [self setCommenView:_nickNameView];
    [self setCommenView:_sexView];
    [self setCommenView:_areaView];
    
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding25, padding10, 50, 62.5 - padding10 * 2)];
    _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding25, padding10, 50, 62.5 - padding10 * 2)];
    _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding25, padding10, 70, 62.5 - padding10 * 2)];
    
    [self setCommenLabel:_nickNameLabel WithText:@"昵称:"];
    [self setCommenLabel:_sexLabel WithText:@"性别:"];
    [self setCommenLabel:_areaLabel WithText:@"所在地:"];
    [_nickNameView addSubview:_nickNameLabel];
    [_sexView addSubview:_sexLabel];
    [_areaView addSubview:_areaLabel];
    
    
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameLabel.frame), padding10, SCREEN_WIDTH - padding10 - CGRectGetMaxX(_nickNameLabel.frame), 62.5 - padding10 * 2)];
    _nickNameTextField.textColor = [UIColor colorWithHex:0x636363];
//    _nickNameTextField.backgroundColor = [UIColor orangeColor];
    [_nickNameView addSubview:_nickNameTextField];
}

- (void)setCommenView:(UIView *)view {
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [[UIColor colorWithHex:0x000000 andAlpha:0.2] CGColor];
    [self addSubview:view];
}

- (void)setCommenLabel:(UILabel *)label WithText:(NSString *)text{
    label.textColor = [UIColor colorWithHex:0x636363];
    label.text = text;
}

@end
