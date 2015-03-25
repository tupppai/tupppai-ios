//
//  ATOMDetailImageDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class ATOMDetailImage;

@interface ATOMDetailImageDAO : ATOMBaseDAO

- (void)insertDetailImage:(ATOMDetailImage *)detailImage;
- (void)updateDetailImage:(ATOMDetailImage *)detailImage;
- (NSArray *)selectDetailImagesByImageID:(NSInteger)imageID;
- (NSArray *)selectHomeImageIDOrderByClickTime;
- (BOOL)isExistDetailImage:(ATOMDetailImage *)detailImage;
- (void)clearDetailImagsByImageID:(NSInteger)imageID;
- (NSArray *)selectDetailImages;

@end
