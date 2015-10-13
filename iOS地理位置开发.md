iOS 地理位置开发
============

一、手机基站
------------

参考资料：

获取CELLID,LAC等信息方法：

<http://www.devdiv.com/forum.php?mod=viewthread&tid=182592>

<http://www.cocoachina.com/bbs/read.php?tid=70132&page=1>

<http://blog.csdn.net/hengshujiyi/article/details/9145593>


二、WIFI方式
------------

参考资料：

xxxxxxxxxxxx


三、CoreLocation
------------
####前言
**CLLocationManager**：定位管理器类。

**CLLocationManagerdelegate**：该协议代表定位管理器的delegate协议。实现该协议的对象可负责处理CLLocationManager的定位事件。

**CLLocation**：该类的对象代表位置。包含了当前设备的经度、纬度、高度、速度、路线等信息，还包含了该定位信息的水平精确度、垂直精确度以及时间戳信息。

**CLHeading**：该类的对象代表设备的移动方向。

**CLRegion**：该类的对象代表一个区域。一般程序不会直接使用该类，而是使用它的两个子类，即CLCircularRegion（圆形区域）和CLBeaconRegion（蓝牙信号区）。

除此之外，CoreLocation框架还涉及一个**CLLocationCoordinate2D**结构体变量，该结构体变量包含 **经度**、**纬度** 两个值。其中CLLocation的对象的coordinate属性就是一个CLLocationCoordinate2D结构体变量。

------------

1.新建工程，并整理工程目录
------------

2.添加定位服务选项
------------
在plist中添加以下两项属性：
 
 NSLocationAlwaysUsageDescription ＝ YES
 
 NSLocationWhenInUseUsageDescription ＝ YES

	注意：在iOS7及以前的版本，如果在应用程序中使用定位服务只要在程序中调用startUpdatingLocation方法应用就会询问用户是否允许此应用是否允许使用定位服务，同时在提示过程中可以通过在info.plist中配置通过配置Privacy - Location Usage Description告诉用户使用的目的，同时这个配置是可选的。但是在iOS8中配置配置项发生了变化，可以通过配置NSLocationAlwaysUsageDescription或者NSLocationWhenInUseUsageDescription来告诉用户使用定位服务的目的，并且注意这个配置是必须的，如果不进行配置则默认情况下应用无法使用定位服务，打开应用不会给出打开定位服务的提示，除非安装后自己设置此应用的定位服务。同时，在应用程序中需要根据配置对requestAlwaysAuthorization或locationServicesEnabled方法进行请求。

3.添加SJLocationManager类，并实现CLLocationManagerDelegate的相关代理方法
------------
通过下面一行导入系统自带地图API：
##### import \<CoreLocation/CoreLocation.h>

参考资料：

iOS开发系列--地图与定位: <http://www.cnblogs.com/kenshincui/p/4125570.html>

Core Location Framework学习:<http://blog.csdn.net/meegomeego/article/details/18711931>

疯狂ios讲义之使用CoreLocation定位(2):<http://www.oschina.net/question/262659_149771?sort=time>



