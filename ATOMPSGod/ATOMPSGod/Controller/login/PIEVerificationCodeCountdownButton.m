//
//  PIEVerificationCodeCountdownButton.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/9/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEVerificationCodeCountdownButton.h"



@implementation PIEVerificationCodeCountdownButton

#pragma mark - initial setup
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customViewSetup];
        [self setupRacBinding];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self customViewSetup];
        [self setupRacBinding];
    }
    
    return self;
}

- (void)customViewSetup
{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self setTitle:@" 获取验证码" forState:UIControlStateNormal];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    
    // 自动设置size，并且textField的rightView会自动设置好frame
    [self sizeToFit];
}

- (void)setupRacBinding
{
    // ## Step 1:倒计时button的制作， 获取验证码->倒计时 + 发网络请求，一系列的信号处理
    
    // RAC-signal binding
    const NSInteger numberLimit   = 60;
    __block NSInteger numberCount = numberLimit;
    
    /*
     weak-strong dance!
     */
    @weakify(self);
    RACSignal *countdownSignal =
    [[[[RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]]
       startWith:@"Let's GO!"]
      take:numberLimit + 1]
     doNext:^(id x) {
         @strongify(self);
         
         /*
          WARNING: 第一个信号是@“Let's GO!”，接下来的信号才是NSDate
          */
         
         /*
          Side-effects warning!
          每次send 'Next'， 就果断地就地修改状态，即使不惜在信号中`掺杂`了副作用！
          */
         if (numberCount == 0) {
             [self setTitle:@"重新发送" forState:UIControlStateNormal];
             self.enabled = YES;
             [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             
             // set to default value
             numberCount = numberLimit;
         }else{
             
             NSString *countdownString =
             [NSString stringWithFormat:@"%ld秒后重发", (long)numberCount];
             
             [self setTitle:countdownString
                                   forState:UIControlStateNormal];
             [self setTitleColor:[UIColor lightGrayColor]
                                        forState:UIControlStateNormal];
             numberCount --;
             
             self.enabled = NO;
         }}];
    
    /*
     别忘了Weak-Strong dance!
     */
    
    self.rac_command =
    [[RACCommand alloc]
     initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self);
         // send network request here.
         
         if (self.fetchVerificationCodeBlock != nil) {
             self.fetchVerificationCodeBlock();
         }
         
         return countdownSignal;
     }];
    
    [[self.rac_command executing] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}


- (void)dealloc
{
    self.fetchVerificationCodeBlock = nil;
}

@end
