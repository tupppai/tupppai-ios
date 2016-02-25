//
//  PIEStateBackgroundColorButton.m
//  TUPAI
//
//  Created by chenpeiwei on 2/2/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEStateBackgroundColorButton.h"

@implementation PIEStateBackgroundColorButton

-(instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    self.defaultBackgroundColor = [UIColor clearColor];
    self.highlightedBackgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectedBackgroundColor = [UIColor groupTableViewBackgroundColor];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            self.defaultBackgroundColor = backgroundColor;
            break;
        case UIControlStateHighlighted:
            self.highlightedBackgroundColor = backgroundColor;
            break;
        case UIControlStateSelected:
            self.selectedBackgroundColor = backgroundColor;
            break;
        default:
            self.defaultBackgroundColor = backgroundColor;
            break;
    }
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = _highlightedBackgroundColor;
    } else {
        self.backgroundColor = _defaultBackgroundColor;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = _selectedBackgroundColor;
    } else {
        self.backgroundColor = _defaultBackgroundColor;
    }
}
@end
