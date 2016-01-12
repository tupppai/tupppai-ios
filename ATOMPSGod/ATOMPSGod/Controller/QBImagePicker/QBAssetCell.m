//
//  QBAssetCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetCell.h"
#import "QBCheckmarkView.h"
@interface QBAssetCell ()

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet QBCheckmarkView *checkmark;

@end

@implementation QBAssetCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3.0;
    _overlayView.layer.borderColor = [UIColor yellowColor].CGColor;
    _overlayView.layer.borderWidth = 1.0;
    _overlayView.layer.cornerRadius = 3.0;
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];


    self.overlayView.hidden = selected ? NO:YES;
    self.checkmark.selected = selected;
    
    // Show/hide overlay view
    
}

@end
