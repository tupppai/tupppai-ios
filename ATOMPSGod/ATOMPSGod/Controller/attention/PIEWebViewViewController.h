//
//  PIEWebViewViewController.h
//  TUPAI
//
//  Created by chenpeiwei on 11/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDBaseVC.h"
#import "PIEModelBanner.h"
@interface PIEWebViewViewController : DDBaseVC
@property (nonatomic,strong)PIEModelBanner* viewModel;
@property (nonatomic,strong)NSString* url;

@end
