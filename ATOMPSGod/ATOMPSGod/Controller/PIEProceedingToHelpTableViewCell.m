//
//  PIEToHelpTableViewCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingToHelpTableViewCell.h"

@implementation PIEProceedingToHelpTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _theImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//put a needle injecting into cell's ass.
- (void)injectSource:(PIEPageVM*)vm {
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    
    _nameLabel.text = vm.username;
    _timeLabel.text = vm.publishTime;
    
    _nameLabel.font = [UIFont lightTupaiFontOfSize:11];
    _timeLabel.font = [UIFont lightTupaiFontOfSize:10];
    _nameLabel.textColor = [UIColor colorWithHex:0x4a4a4a andAlpha:1.0];
    _timeLabel.textColor = [UIColor colorWithHex:0x4a4a4a andAlpha:1.0];

    NSString * htmlString = vm.content;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont lightTupaiFontOfSize:13] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000 andAlpha:0.9] range:NSMakeRange(0, attrStr.length)];
    
    _contentTextView.attributedText = attrStr;
}



@end
