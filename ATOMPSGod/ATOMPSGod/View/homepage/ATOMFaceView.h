//
//  ATOMFaceView.h
//  ATOMPSGod
//
//  Created by atom on 15/4/13.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATOMFaceViewDelegate <NSObject>

- (void)selectFace:(NSString *)str;

@end

@interface ATOMFaceView : UIView

@property (nonatomic, weak) id<ATOMFaceViewDelegate>delegate;

- (void)loadFaceView:(NSInteger)page Size:(CGSize)size Faces:(NSMutableArray *)arr;

@end
