//
//  ATOMCustomCopperView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/13.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

typedef enum {
    ATOMCustomCropperViewRegularType = 0,
    ATOMCustomCropperViewCircleType
}ATOMCustomCropperViewType;

@interface ATOMCustomCropperView : UIView

@property (nonatomic, assign) ATOMCustomCropperViewType customCropperViewType;

@end
