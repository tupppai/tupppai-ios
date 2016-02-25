//
//  PIETextView.h
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeesinTextView : UITextView
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) UIColor *placeholderColor;

@property (nonatomic, readwrite) NSUInteger maxNumberOfLines;

@property (nonatomic, readonly) NSUInteger numberOfLines;

@end
