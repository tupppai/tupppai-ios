#图派iOS客户端

----
Dev-Log: huangwei, 15-12-13:
1. 部分UI的细调（按照Tower.im上的需求）
2. "进行中"tab中，在PIEProceedingViewController中抽离出 PIEProceedingDoneVIewController以备用，并且将后者从前者之中删除。
3. 重构shareview， 其中：
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




