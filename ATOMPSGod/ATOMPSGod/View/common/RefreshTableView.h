//
//  RefreshTableView.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMNoDataView.h"

@interface RefreshTableView : UITableView
@property (nonatomic, weak) id<PWRefreshBaseTableViewDelegate> psDelegate;
@end
