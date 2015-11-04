//
//  PIEFeedbackViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 11/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFeedbackViewController.h"
#import "SZTextView.h"
@interface PIEFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet SZTextView *textView;

@end

@implementation PIEFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈建议";
    _textView.font = [UIFont systemFontOfSize:13.0];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = [UIColor colorWithHex:0x000000 andAlpha:0.3].CGColor;
    _textView.layer.cornerRadius = 4;
    _textView.clipsToBounds = YES;
    _textView.placeholderTextColor = [UIColor colorWithHex:0x9B9B9B andAlpha:0.9];
//    _textView.textColor = [UIColor colorWithHex:0x9B9B9B andAlpha:0.9];
    _label.textColor = [UIColor colorWithHex:0x4a4a4a andAlpha:1.0];
    _label.font = [UIFont systemFontOfSize:13.0];
    _label.text = @"也可以发送截图到 官方客服 QQ2974252463, 快速解决;\n或加入我们的QQ交流群 511828428";
    _label.numberOfLines = 0;
    
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendFeedback)];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void) sendFeedback {
    if ([self.textView.text isEqualToString:@""]) {
        [Hud text:@"请输入你的反馈建议" inView:self.view];
    } else {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:self.textView.text forKey:@"content"];
        [DDService postFeedBack:param withBlock:^(BOOL success) {
            if (!success) {
            } else {
                [Hud success:@"感谢你的反馈😊"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
