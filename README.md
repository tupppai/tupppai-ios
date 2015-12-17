#图派iOS客户端
###Dev-Log: huangwei, 15-12-17
#### shareView代理的重构思路：

```objc
// in protocol <PIEShareViewDelegate>
@protocol PIEShareViewDelegate <NSObject>
@required
- (void)shareViewDidShare:(PIEShareView *)shareView;
- (void)shareViewDidCancel:(PIEShareView *)shareView;
```

在shareView的public方法中，在show的时候就传入viewModel参数：

```objc
- (void)showInView:(UIView *)view animated:(BOOL)animated pageViewModel:(PIEPageVM *)pageVM;
- (void)show:(PIEPageVM *)pageVM;
-(void)dismiss;
```

所以，一个shareView在一打开的时候就由传入的viewModel决定了里面需要分享的是哪一张求P，而到了网络请求没问题受到回复之后，再修改shareView里面的icon的selected状态：

```objc
- (void)tapGes8:(UIGestureRecognizer*)gesture {
    
    // Collect this PageVM
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(shareViewDidCollect:)]) {
        [_delegate shareViewDidCollect:self];
        
        if (_weakVM != nil) {
            NSMutableDictionary *param = [NSMutableDictionary new];
            
            if (_weakVM.collected) {
                //如果之前已经收藏，那么就取消收藏
                [param setObject:@(0) forKey:@"status"];
            } else {
                //反之，收藏
                [param setObject:@(1) forKey:@"status"];
            }
            [DDCollectManager toggleCollect:param
                               withPageType:_weakVM.type
                                     withID:_weakVM.ID withBlock:^(NSError *error) {
                if (error == nil) {
                    // 成功返回数据，代表切换收藏这个状态已经被服务器承认，这个时候再切换状态
                    _weakVM.collected = !_weakVM.collected;
                    if (  _weakVM.collected) {
                        [Hud textWithLightBackground:@"收藏成功"];
                    } else {
                        [Hud textWithLightBackground:@"取消收藏成功"];
                    }
                    [self toggleCollectIconStatus:_weakVM.collected];
                    
                }   else {
                    // error occur on networking
//                    [Hud textWithLightBackground:@"服务器不鸟你"];
                }
                                         
            }];
        }
    }
}

```

在两个代理方法中，shareViewDidShare回调到控制器让它更新本页面的点赞数；cancel则让控制器dismiss shareView。其他操作一概与控制器***无关***。

###Dev-Log: huangwei, 15-12-16
- (需求)举报弹窗，应该是在替换分享浮窗显示，而不是在分享浮窗之上显示。详如内。
- (需求)【搜索页界面问题】“取消”两个字下泛白块，详如内。加黑白的位置不对，向安卓看齐。
- (需求)【单图详情页】分享和评论按钮的位置不对，分享在内，评论在外。详如内。
- (需求)【其他作品】赞icon显示模糊且样式不一样，详如内。
- (需求）分享浮窗，收藏按钮不对。详如内。
- BUG FIX: 分享页的收藏现在显示正常 (有部分地方，carousel等用的分享逻辑不同所以没有办法再showShareView的时候传递。为了编译通过只能注释掉相应代码导致shareView在某些页面不能显示；在代码的注释上打桩“BIG_REFACTOR”，按照这个关键字搜索即可定位到具体代码)
###Dev-Log: huangwei, 15-12-15
- 优化ShareView的重构代码
- (需求)频道名称不对。 ( huangwei 昨天 )
- (需求)分享浮窗，收藏按钮不对。详如内。  ( huangwei 昨天 )
-  (需求)【频道-单个频道】当往下滑时，发布按钮被隐藏，停顿时，发布按钮在出现。 ( huangwei 昨天 )

###Dev-Log: huangwei, 15-12-14:
- 部分UI的细调（按照Tower.im上的需求）
- "进行中"tab中，在PIEProceedingViewController中抽离出 PIEProceedingDoneVIewController以备用，并且将后者从前者之中删除。
- 重构shareview， 其中：

```objc
// in protocol <PIEShareViewDelegate>
@protocol PIEShareViewDelegate <NSObject>
@required
- (void)shareViewDidShare:(PIEShareView *)shareView
          socialShareType:(ATOMShareType)shareType;
/* !!! 循环引用的隐忧？我主动把PIEPageVM的prperty设置为weak*/
- (void)shareViewDidPaste:(PIEShareView *)shareView;
- (void)shareViewDidReportUnusualUsage:(PIEShareView *)shareView;
- (void)shareViewDidCollect:(PIEShareView *)shareView;
- (void)shareViewDidCancel:(PIEShareView *)shareView;
```

在shareView内部封装了分享、复制链接、举报和收藏的功能。后三者的代理方法仅需传递一个selectedVM即可。

```objc
// in PIENewReplyViewController
#pragma mark - ATOMShareViewDelegate

- (void)shareViewDidShare:(PIEShareView *)shareView socialShareType:(ATOMShareType)shareType
{
    [DDShareManager postSocialShare2:_selectedVM
                 withSocialShareType:shareType
                               block:^(BOOL success) {
                               	// 分享之后，更新本页面的UI元素（分享数+1）
                                   [self updateShareStatus];
                               }];
}

- (void)shareViewDidPaste:(PIEShareView *)shareView
{
    shareView.weakVM = _selectedVM;
}

- (void)shareViewDidReportUnusualUsage:(PIEShareView *)shareView
{
    shareView.weakVM = _selectedVM;
}

- (void)shareViewDidCollect:(PIEShareView *)shareView
{
    shareView.weakVM = _selectedVM;
}

- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}
```

- 封装shareView并且应用在了以下类, 同时删除了他们内部的collect（收藏）的方法：
	- PIENewReplyViewController
	- PIENewAskMakeUpViewController
	- PIECommentViewController
	- PIECommentViewController2
	- PIEEliteViewController
	- PIEChannelDetailViewController
	- PIEChannelActivityViewController
	- PIECarousel-ItemView
- 删除了PIEPaveVM里面的collect（收藏）方法，因为一个view不应该做这种事。

----

###频道
####/thread/home, 频道首页
```json
data{
	categories(
		{...}
		{...}
		{...}
		{...}
	)
}
```
1. categories数组中的每一个字典，都对应着PIEChannelViewController中的一个Cell(Activity or Channel Detail)。其中：\n
```json
{
	category_type: activity or channel (控制点击Cell之后会跳转到哪个VC，activityVC or channelDetailVC)；
	banner_pic: channelDetailVC中的bannerView的图片；
	post_btn: channelDetailVC中的goPsButton显示的图片；
	threads: 数组，里面是装载着PiePageVM的字典数据；
}
```


