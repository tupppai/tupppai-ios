//
//  PIECashFlowDetailTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/16/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIECashFlowModel;
@interface PIECashFlowDetailTableViewCell : UITableViewCell

- (void)injectModel:(PIECashFlowModel *)model;

@end
