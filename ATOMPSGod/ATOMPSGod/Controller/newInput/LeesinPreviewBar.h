//
//  LeesinPreviewToolBar.h
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/7/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  PHAsset;
typedef NS_ENUM(NSUInteger, LeesinPreviewBarType) {
    LeesinPreviewBarTypeAsk,
    LeesinPreviewBarTypeReply,
};

@interface LeesinPreviewBar : UIView

@property (nonatomic, assign) LeesinPreviewBarType type;

@property (nonatomic, copy) NSMutableOrderedSet    *source;

- (void)clear;
- (void)clearReplyImage ;
- (void)clearReplyUrl ;
- (BOOL)isSourceEmpty ;

- (BOOL)hasSourcePHAsset;
- (BOOL)hasSourceMission;
@end

