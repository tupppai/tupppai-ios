//
//  PIEActionSheet_UserAbuse.h
//  TUPAI
//
//  Created by chenpeiwei on 12/19/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "JGActionSheet.h"
#import "SIAlertView.h"
@interface PIEActionSheet_UserAbuse : JGActionSheet<JGActionSheetDelegate>
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,strong) SIAlertView *alertView;
@property (nonatomic,strong) PIEEntityUser *user;
-(instancetype)initWithUser:(PIEEntityUser*) user ;
@end
