//
//  PIEToHelpTableViewCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingToHelpTableViewCell.h"
#import "PIECategoryModel.h"
@implementation PIEProceedingToHelpTableViewCell

- (void)awakeFromNib {
    // Initialization code

    _theImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.separator mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];
    
    self.separator.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
    
    [self configureColorAndFont];
}


- (void)configureColorAndFont
{
    self.nameLabel.font              = [UIFont lightTupaiFontOfSize:13];
    self.nameLabel.textColor         = [UIColor blackColor];

    self.contentTextView.font        = [UIFont lightTupaiFontOfSize:14];
    self.contentTextView.textColor   = [UIColor blackColor];

    self.categoryNameLabel.font      = [UIFont lightTupaiFontOfSize:11];
    self.categoryNameLabel.textColor = [UIColor blackColor];
    self.updateTimeLabel.font        = [UIFont lightTupaiFontOfSize:10];
    self.updateTimeLabel.textColor   = [UIColor colorWithHex:0x50484B];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//put a needle injecting into cell's ass.
- (void)injectSource:(PIEPageVM*)vm {
    
    [_avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];

    _avatarView.isV = vm.isV;
    
    NSString* imageUrl = [vm.imageURL trimToImageWidth:SCREEN_WIDTH];
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    
    _nameLabel.text = vm.username;
    
    _nameLabel.font = [UIFont lightTupaiFontOfSize:11];
    _nameLabel.textColor = [UIColor colorWithHex:0x4a4a4a andAlpha:1.0];

    
    NSString * htmlString = vm.content;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont lightTupaiFontOfSize:13] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000 andAlpha:0.9] range:NSMakeRange(0, attrStr.length)];
    
    _contentTextView.attributedText = attrStr;
    
    _updateTimeLabel.text = vm.publishTime;

    if (vm.models_catogory.count>0) {
        PIECategoryModel* category = [vm.models_catogory objectAtIndex:0];
        _categoryNameLabel.text = category.title;
    } else {
        _categoryNameLabel.text = @"随意求p区";
    }
    
}



@end
