//
//  PIEButton.h
//  TUPAI
//
//  Created by chenpeiwei on 9/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE
@interface PIEPageButton : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString* numberString;
@end
