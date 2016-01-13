//
//  PHAsset+Addition.m
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/5/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "PHAsset+Addition.h"
#import <objc/runtime.h>
@implementation PHAsset(Addition)

-(BOOL)selected {
    return [objc_getAssociatedObject(self, @selector(selected)) boolValue];;
}
-(void)setSelected:(BOOL)selected {
    objc_setAssociatedObject(self, @selector(selected), @(selected), OBJC_ASSOCIATION_ASSIGN);
}
@end
