//
//  LeesinPreviewToolBar.h
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/7/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  PHAsset;
@class LeesinPreviewBar;

typedef NS_ENUM(NSUInteger, LeesinPreviewBarType) {
    LeesinPreviewBarTypeAsk,
    LeesinPreviewBarTypeReply,
};

@protocol LeesinPreviewBarDelegate <NSObject>
@optional
- (void)leesinPreviewBar:(LeesinPreviewBar *)leesinPreviewBar didTapImage1:(BOOL)didTapImage1 didTapImage2:(BOOL)didTapImage2;
@end

@interface LeesinPreviewBar : UIView

@property (nonatomic, weak) id<LeesinPreviewBarDelegate> delegate;

@property (nonatomic, assign) LeesinPreviewBarType type;

@property (nonatomic, copy) NSMutableOrderedSet    *source;

- (void)clear;
- (void)clearReplyImage ;
- (void)clearReplyUrl ;
- (BOOL)isSourceEmpty ;

- (BOOL)hasSourcePHAsset;
- (BOOL)hasSourceMission;
@end

