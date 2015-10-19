//
//  PIESignUpView.h
//  TUPAI
//
//  Created by chenpeiwei on 10/19/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIESignUpSheetView.h"

@protocol PIESignUpViewDelegate <NSObject>
@optional
- (void)tapSignUp1;
- (void)tapSignUp2;
- (void)tapSignUp3;
- (void)tapSignUpClose;
@end


@interface PIESignUpView : UIView

@property (strong, nonatomic) PIESignUpSheetView *sheetView;

@property (nonatomic, weak) id<PIESignUpViewDelegate> delegate;
- (void)show ;
-(void)dismiss;
@end

