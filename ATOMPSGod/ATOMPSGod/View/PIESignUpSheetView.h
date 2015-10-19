//
//  PIESignUpSheetView.h
//  TUPAI
//
//  Created by chenpeiwei on 10/19/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEShareIcon.h"
@interface PIESignUpSheetView : UIView
@property (strong, nonatomic) PIEShareIcon *icon1;
@property (strong, nonatomic) PIEShareIcon *icon2;
@property (strong, nonatomic) PIEShareIcon *icon3;

@property (strong, nonatomic) UIImageView *closeView;

@property (strong, nonatomic) NSMutableArray *iconArray;
@property (strong, nonatomic) NSArray *infoArray;
@end
