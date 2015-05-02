//
//  ATOMMyUploadCollectionViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMCollectionViewLabel;

@interface ATOMMyUploadCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *workImageView;
@property (nonatomic, strong) ATOMCollectionViewLabel *psLabel;
@property (nonatomic, copy) NSString *totalPSNumber;
/**
 *  0:灰色 1:蓝色
 */
@property (nonatomic, assign) NSInteger colorType;

@end
