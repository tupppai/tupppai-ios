//
//  NSInteger+leesinDone.m
//  TUPAI
//
//  Created by chenpeiwei on 1/12/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "NSNumber+leesinDone.h"

@implementation NSNumber(leesinDone)
-(BOOL)isMission_undone {
    return [objc_getAssociatedObject(self, @selector(isMission_undone)) boolValue];;
}
-(void)setIsMission_undone:(BOOL)isMission_undone {
    objc_setAssociatedObject(self, @selector(isMission_undone), @(isMission_undone), OBJC_ASSOCIATION_ASSIGN);
}

@end
