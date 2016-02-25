//
//  PIEEliteHotReplyViewController.h
//  TUPAI
//
//  Created by huangwei on 15/12/17.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDBaseVC.h"

@interface PIEEliteHotViewController : DDBaseVC<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>


- (void)getSourceIfEmpty_banner;
- (void)getSourceIfEmpty_hot:(void (^)(BOOL finished))block;

@end
