//
//  QBAssetCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/06.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetCell.h"

@interface QBAssetCell ()

@property (weak, nonatomic) IBOutlet UIView *overlayView;

@end

@implementation QBAssetCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.overlayView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.overlayView.layer.borderWidth = 1.0;
    self.overlayView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    self.overlayView.hidden = !(selected && self.showsOverlayViewWhenSelected);
}

@end
