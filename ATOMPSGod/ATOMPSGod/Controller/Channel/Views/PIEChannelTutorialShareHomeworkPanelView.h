//
//  PIEChannelTutorialShareHomeworkPanelView.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/28/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIEChannelTutorialShareHomeworkPanelView;

@protocol PIEChannelTutorialShareHomeworkPanelViewDelegate <NSObject>

@required
- (void)shareHomeworkPanelView:(PIEChannelTutorialShareHomeworkPanelView *)panelView didShareHomeworkWithType:(ATOMShareType)shareType;

@end

@interface PIEChannelTutorialShareHomeworkPanelView : UIView

@property (nonatomic, weak) id<PIEChannelTutorialShareHomeworkPanelViewDelegate>delegate;

- (void)show;

- (void)dismiss;


@end
