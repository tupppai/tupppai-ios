//
//  ATOMTextViewComment.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/12/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMTextViewComment.h"
#import "ATOMFaceView.h"
#import "ATOMFaceCollectionView.h"
@interface ATOMTextViewComment()<ATOMFaceViewDelegate,UIScrollViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) ATOMFaceCollectionView *faceCollectionView;
@end

@implementation ATOMTextViewComment
//static const CGFloat textviewHeight = 46;
//static const CGFloat faceViewHeight = 200;
//static CGFloat pageControlWidth = 150;

 NSString *placeholderString = @"发表你的神回复..";

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.backgroundColor = [UIColor whiteColor];
    if (self ) {
        [self createSubviews];
        [self layoutSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 1);
    topBorder.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2].CGColor;
    [self.layer addSublayer:topBorder];
    
    //发送按钮
    _sendCommentButton = [UIButton new];
    _sendCommentButton.titleLabel.font = [UIFont systemFontOfSize:kFont15];
    [_sendCommentButton setBackgroundImage:[UIImage imageNamed:@"btn_comment_send"] forState:UIControlStateNormal];
    _sendCommentButton.alpha = 0.5;
    _sendCommentButton.enabled = NO;

//    [_sendCommentButton setTitle:@"发送" forState:UIControlStateNormal];
//    [_sendCommentButton setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
    
    [self addSubview:_sendCommentButton];

    //表情按钮
    _faceButton = [UIButton new];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"comment_write"] forState:UIControlStateNormal];
    _faceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [_faceButton addTarget:self action:@selector(showFaceView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_faceButton];
    
    //输入框
    _commentTextView = [UITextView new];
    _commentTextView.delegate = self;
    _commentTextView.textColor = [UIColor blackColor];
    _commentTextView.font = [UIFont systemFontOfSize:15];
    _commentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _commentTextView.backgroundColor = [UIColor colorWithHex:0xf7f7f7 andAlpha:1];
    _commentTextView.textAlignment = NSTextAlignmentCenter;
//    _commentTextView.contentSize = CGSizeMake(SCREEN_WIDTH, 30);
//    UITapGestureRecognizer* tapToEditGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToEdit)];
//    [_commentTextView addGestureRecognizer:tapToEditGes];
    [self addSubview:_commentTextView];
    
    _placeHolderLabel = [UILabel new];
    _placeHolderLabel.userInteractionEnabled = NO;
    _placeHolderLabel.text = placeholderString;
    _placeHolderLabel.textColor = [UIColor colorWithHex:0xcbcbcb];
    _placeHolderLabel.font = [UIFont systemFontOfSize:15];
    [_commentTextView addSubview:_placeHolderLabel];
    
    _faceCollectionView = [ATOMFaceCollectionView new];
    [self addSubview:_faceCollectionView];
}

//-(void)tapToEdit {
//    [_commentTextView becomeFirstResponder];
//}

-(void)layoutSubviews {
    
//    _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding15, 9.5, 21, 27)];

    [_faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(kPadding15);
        make.top.equalTo(self).with.offset(7);
        make.width.equalTo(@28);
        make.height.equalTo(@30);
    }];
    
    [_sendCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_faceButton);
        make.trailing.equalTo(self).with.offset(-kPadding15);
        make.width.equalTo(@32);
        make.height.equalTo(@24);
    }];

//    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_faceButton.frame) + 26, 8, CGRectGetMinX(_sendCommentButton.frame) - 26 * 2 - CGRectGetMaxX(_faceButton.frame), 30)];

    [_commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_faceButton.mas_right).with.offset(kPadding15);
        make.trailing.equalTo(_sendCommentButton.mas_leading).with.offset(-kPadding15);
        make.centerY.equalTo(_faceButton).with.offset(0);
        make.height.equalTo(@30);
    }];
    
//    _sendCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGWidth(self.frame) - kPadding15 - 32, 7, 32, 32)];

    
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_faceButton);
//        make.trailing.equalTo(_commentTextView).with.offset(5);
        make.leading.equalTo(_commentTextView).with.offset(5);
        make.height.equalTo(@15);
        make.width.equalTo(@130);

    }];
//    _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 30)];

    [_faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_faceButton).with.offset(kPadding15);
        make.trailing.equalTo(self);
        make.leading.equalTo(self);
        make.height.equalTo(@240);
    }];
}
-(void)textViewDidChange:(UITextView *)textView {
    [self toggleSendCommentView];
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    [self toggleSendCommentView];
}
-(void)toggleSendCommentView {
    if ([_commentTextView.text isEqualToString:@""]) {
        _sendCommentButton.enabled = NO;
        _placeHolderLabel.hidden = NO;
        _sendCommentButton.alpha = 0.5;
//        [_sendCommentButton setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
    } else {
        _sendCommentButton.enabled = YES;
        _placeHolderLabel.hidden = YES;
        _sendCommentButton.alpha = 1.0;
//        [_sendCommentButton setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    }
}

@end
