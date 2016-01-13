//
//  LeesinSwipeView.h
//  TUPAI
//
//  Created by chenpeiwei on 1/9/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwipeView.h"

typedef NS_ENUM(NSUInteger, LeesinSwipeViewType) {
    LeesinSwipeViewTypeMission,
    LeesinSwipeViewTypePHAsset
};
@interface LeesinSwipeView : SwipeView
@property (nonatomic,assign)LeesinSwipeViewType type;
@property (nonatomic,assign)BOOL emptyDataSetShouldDisplay;
@property (nonatomic,strong)UILabel *emptyDisplayLabel;

@end
