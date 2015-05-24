//
//  ATOMPersonTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMPersonTableViewCell : UITableViewCell

- (void)addTopLine:(BOOL)flag;
- (void)addBottomLine:(BOOL)flag;
- (void)configThemeLabelWith:(NSString *)str;
- (void)configThemeImageWith:(UIImage *)image;

@end
