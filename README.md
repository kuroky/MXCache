## 基于[YYCache](https://github.com/ibireme/YYCache)缓存封装
### 安装
#### 1.CocoaPod安装

```
pod 'MXCaches', '1.0.0'
```
#### 2.手动安装
- 在项目中添加`YYCache`，`pod 'YYCache', ' 1.0.4'`
- 把`MXCache`拖入项目

### 使用说明
![提示](https://github.com/kuroky/MXCache/blob/master/2018-10-09.png)

```Swift
[[MXCache sharedCache] mx_mCacheCount:20 mExpirytime:300 dExpirytime:12000];
[[MXCache sharedCache] mx_setCachePath:@""]; // 缓存路径
```

