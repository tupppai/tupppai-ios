//
//  PIEProceedingToHelpViewController.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 12/23/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDBaseVC.h"

@interface PIEProceedingToHelpViewController : DDBaseVC<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>


- (void)getSourceIfEmpty_toHelp;

- (void)refreshViewControllerWhileNotReloading;

@end
