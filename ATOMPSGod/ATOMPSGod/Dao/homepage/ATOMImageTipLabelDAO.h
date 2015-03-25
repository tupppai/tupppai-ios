//
//  ATOMImageTipLabelDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class ATOMImageTipLabel;

@interface ATOMImageTipLabelDAO : ATOMBaseDAO

- (void)insertTipLabel:(ATOMImageTipLabel *)tipLabel;
- (void)updateTipLabel:(ATOMImageTipLabel *)tipLabel;
- (ATOMImageTipLabel *)selectTipLabelByLabelID:(NSInteger)labelID;
- (NSMutableArray *)selectTipLabelsByImageID:(NSInteger)imageID;
- (BOOL)isExistTipLabel:(ATOMImageTipLabel *)tipLabel;
- (void)clearTipLabels;

@end
