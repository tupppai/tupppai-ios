//
//  ATOMDetailImageDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class ATOMDetailPage;

@interface ATOMDetailImageDAO : ATOMBaseDAO

- (void)insertDetailImage:(ATOMDetailPage *)detailImage;
- (void)updateDetailImage:(ATOMDetailPage *)detailImage;
- (NSArray *)selectDetailImagesByImageID:(NSInteger)imageID;
- (NSArray *)selectHomeImageIDOrderByClickTime;
- (BOOL)isExistDetailImage:(ATOMDetailPage *)detailImage;
- (void)clearDetailImagsByImageID:(NSInteger)imageID;
- (NSArray *)selectDetailImages;

@end
