//
//  UIColor+PSGod.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/14/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "UIColor+PSGod.h"

@implementation UIColor (PSGod)

//kfc means page which consists of topview,imageviewMain,bottomview,additionview,blablaaaa....
+  (UIColor *)kfcUsername {
    return [UIColor colorWithHex:0x000000 andAlpha:0.6];
}
+  (UIColor *)kfcPublishTime {
    return [UIColor colorWithHex:0x000000 andAlpha:0.4];
}
+  (UIColor *)kfcButton {
    return [UIColor colorWithHex:0x000000 andAlpha:0.4];
}
+  (UIColor *)kfcButtonSelected {
    return [UIColor colorWithHex:0xFe8282];
}
+  (UIColor *)kfcPublishType {
    return [UIColor colorWithHex:0x74c3ff];
}
+  (UIColor *)kTitleForEmptySource {
    return [UIColor lightGrayColor];
}

@end
@implementation UIFont (PSGod)

+  (UIFont *)kfcButton {
    return [UIFont fontWithName:kFontNameDefault size:12];
}
+  (UIFont *)kfcPublishTime {
    return [UIFont fontWithName:kFontNameDefault size:13];
}
+  (UIFont *)kfcPublishType {
    return [UIFont fontWithName:@"HelveticaNeue" size:14];
}
+  (UIFont *)kfcPublishTimeSmall {
    return [UIFont fontWithName:kFontNameDefault size:11];
}

+  (UIFont *)kfcCommentUserName {
    return [UIFont fontWithName:kFontNameDefault size:16];
}
+  (UIFont *)kfcComment {
    return [UIFont fontWithName:kFontNameDefault size:14];
}

@end
