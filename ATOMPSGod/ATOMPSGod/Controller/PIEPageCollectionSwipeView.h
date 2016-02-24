//
//  PIEPageCollectionSwipeView.h
//  TUPAI
//
//  Created by chenpeiwei on 2/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "PIEPageCollectionImageView.h"
@interface PIEPageCollectionSwipeView : UIView
@property (nonatomic,strong)PIEPageVM *pageViewModel;
@property (nonatomic,strong) SwipeView *swipeView;
@property (nonatomic,strong) PIEPageCollectionImageView *askImageView;
@property (nonatomic,strong) UIImageView *askImageView2;
@property (nonatomic,strong) NSArray *askSourceArray;

@end
