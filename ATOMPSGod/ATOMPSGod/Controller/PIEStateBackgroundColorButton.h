//
//  PIEStateBackgroundColorButton.h
//  TUPAI
//
//  Created by chenpeiwei on 2/2/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEStateBackgroundColorButton : UIButton
@property (nonatomic,assign) UIColor *highlightedBackgroundColor;
@property (nonatomic,assign) UIColor *defaultBackgroundColor;
@property (nonatomic,assign) UIColor *selectedBackgroundColor;

-(void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
@end
