//
//  PIETagsView.m
//  TUPAI
//
//  Created by chenpeiwei on 12/2/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIETagsView.h"
#import "PIETagModel.h"
#import "PIEButton_Tag.h"
@interface PIETagsView()
@property (nonatomic,assign) CGPoint lastPosition;

@end
@implementation PIETagsView

-(instancetype)init {
    self = [super init];
    if (self) {
        _lastPosition = CGPointZero;
        _array_selectedId = [NSMutableArray new];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _lastPosition = CGPointZero;
        _array_selectedId = [NSMutableArray new];
    }
    return self;
}

-(void)setArray_tagModel:(NSArray *)array_tagModel {
    _array_tagModel = array_tagModel;
    for (PIETagModel* model in _array_tagModel) {
        PIEButton_Tag* button = [[PIEButton_Tag alloc]initWithText:model.text];
        button.tag = model.ID;
        [self autoPositionButton:button];
        [self addSubview:button];
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void) tapButton:(PIEButton_Tag*)button {
    //to unselected
    if (button.selected) {
        button.selected = !button.selected;
        [_array_selectedId removeObjectIdenticalTo:@(button.tag)];
    }
    //to selected
    else {
        if (_array_selectedId.count < 1) {
            button.selected = !button.selected;
            [_array_selectedId addObject:@(button.tag)];
        } else {
            [Hud text:@"只能选一个标签哦"];
        }
    }
}

- (void)autoPositionButton:(UIButton*)button {
    CGRect buttonFrame = button.frame;
    CGFloat newX = _lastPosition.x + buttonFrame.size.width;
    if (newX > self.frame.size.width) {
        //换行
        _lastPosition.y += buttonFrame.size.height + 10;
        _lastPosition.x = 0;
    }
    
    button.frame = CGRectMake(_lastPosition.x, _lastPosition.y, buttonFrame.size.width, buttonFrame.size.height);
    _lastPosition = CGPointMake(button.frame.origin.x+button.frame.size.width+10, button.frame.origin.y);
}


@end
