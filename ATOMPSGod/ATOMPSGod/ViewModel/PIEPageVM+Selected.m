//
//  PIEPageVM+Selected.m
//  TUPAI
//
//  Created by chenpeiwei on 1/8/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageVM+Selected.h"
#import <objc/runtime.h>

@implementation PIEPageVM(selected)
-(BOOL)selected {
    return [objc_getAssociatedObject(self, @selector(selected)) boolValue];;
}
-(void)setSelected:(BOOL)selected {
    objc_setAssociatedObject(self, @selector(selected), @(selected), OBJC_ASSOCIATION_ASSIGN);
}
@end
