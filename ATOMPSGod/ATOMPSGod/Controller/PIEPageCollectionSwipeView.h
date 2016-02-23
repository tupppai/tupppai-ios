//
//  PIEPageCollectionSwipeView.h
//  TUPAI
//
//  Created by chenpeiwei on 2/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface PIEPageCollectionSwipeView : UIView
@property (nonatomic,strong)PIEPageVM *pageViewModel;
@property (nonatomic,strong) SwipeView *swipeView;
@end