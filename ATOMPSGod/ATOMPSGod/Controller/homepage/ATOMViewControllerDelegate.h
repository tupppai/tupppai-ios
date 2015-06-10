//
//  ATOMVCDelegate.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/10/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATOMViewControllerDelegate <NSObject>
@optional
- (void)ATOMViewControllerDismissWithLiked:(BOOL)liked;
@end
