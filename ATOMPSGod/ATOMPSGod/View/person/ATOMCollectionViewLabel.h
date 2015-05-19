//
//  ATOMCollectionViewLabel.h
//  ATOMPSGod
//
//  Created by atom on 15/5/1.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMCollectionViewLabel : UIImageView

@property (nonatomic, copy) NSString *number;
/**
 *  0:灰色 1:蓝色
 */
@property (nonatomic, assign) NSInteger colorType;

@end
