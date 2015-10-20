//
//  UIViewController+ATOMTracking.m
//  ATOMPSGod
//
//  Created by atom on 15/4/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

//#import "UIViewController+ATOMTracking.h"
//#import <objc/runtime.h>

//@implementation UIViewController (ATOMTracking)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
////        Class class = object_getClass((id)self);
//        SEL originalSelector = @selector(viewWillAppear:);
//        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if (didAddMethod) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}
//- (void)xxx_viewWillAppear:(BOOL)animated {
//    [self xxx_viewWillAppear:animated];
//    NSLog(@"viewWillAppear: %@", self);
//}

//@end
