#图派iOS客户端
##频道
###/thread/home, 频道首页
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




