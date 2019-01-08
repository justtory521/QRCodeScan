![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg) ![Platform](https://img.shields.io/badge/Platform-iOS-red.svg) [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# QRCodeScan

## 主要内容的介绍

* 二维码、条形码的生成 <br>
* 二维码、条形码的扫描 <br>
* 自定义扫描页面

## Requirements

- Object-tive C、 Swift 4.2
- iOS 9.0+
- Xcode 9.x

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate **QRCodeScan** into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "youmyc/QRCodeScan"
```

Run `carthage update --platform iOS` to build the framework and drag the built `ScanQRCode.framework` into your Xcode project.

### Manually

Just download the project, and drag and drop the "QRCode/Common" folder in your project.<br>

## Usage

1、在 info.plist 中添加以下字段（iOS 10 之后需添加的字段）

```plist
<key>NSCameraUsageDescription</key>
<string>二维码扫描，需要您的相机</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>App需要您的同意,才能保存图片到您的相册</string>
```

2、扫描页面调用

* 可自定义扫描页面，详情查看demo

```objc
QRCodeViewController * qrcVC = [[UIStoryboard storyboardWithName:@"QRCode" bundle:nil] instantiateViewControllerWithIdentifier:@"qrc"];
qrcVC.title = @"条形码";
// YES 为条形码，NO 为二维码
qrcVC.isBarCode = YES;
// 边框颜色
qrcVC.angleColor = [UIColor colorWithRed:0.122 green:0.565 blue:0.902 alpha:1.000];
[self.navigationController pushViewController:qrcVC animated:YES];
```

3、根据环境光传感器变化开启与关闭闪光灯

* 需环境光传感器变化回调，实用ScanViewDelegate即可

```objc
/**
 环境光传感器变化

 @param scanView ScanView
 @param flashLamp 是否开启闪光灯
 */
- (void)lightSensorDidChange:(ScanView *)scanView show:(BOOL)flashLamp;
```

* 闪光灯的开启与关闭，用ScanView的实例变量调用以下方法即可

```objc
/**
 开启闪光灯
 */
- (void)open;
    
/**
 关闭闪光灯
 */
- (void)close;
```

3、二维码/条形码的生成

* 调用以下方法生成二维码、条形码

```objc
/**
 生成二维码

 @param content 内容
 @param size 大小
 @return 二维码
 */
+ (UIImage *)generateQRCodeWithContent:(NSString *)content size:(CGSize)size;
    
/**
 生成条形码

 @param content 内容
 @return 条形码
 */
+ (UIImage *)generateBarCodeWithContent:(NSString *)content size:(CGSize)size;
```

* 二维码保存（截取后会自动保存到相册）

```objc
/**
 截图

 @param view 所需截图的View
 @return 截图后的图片
 */
+ (UIImage *)screenShotWithView:(UIView *)view;
```

4、二维码的识别

```objc
/**
 打开相册

 @param controller 当前控制器
 */
- (void)openAlbum:(UIViewController *)controller;
```

```objc
@class QRCdiscern;

@protocol QRCdiscernDelegate <NSObject>

@optional

/**
 识别完成后回调

 @param discern QRCdiscern
 @param result 识别结果
 */
- (void)discernDidFinish:(QRCdiscern *)discern result:(NSString *)result;

@end
```
## 效果

| <img src="https://github.com/youmyc/QRCodeScan/blob/master/Screenshot/Screenshot1.png" width = "320" height = "568" /> | <img src="https://github.com/youmyc/QRCodeScan/blob/master/Screenshot/Screenshot2.png" width = "320" height = "568" /> |
| :-: | :-: | :-: | :-: | :-: |
| <img src="https://github.com/youmyc/QRCodeScan/blob/master/Screenshot/Screenshot3.png" width = "320" height = "568" /> | <img src="https://github.com/youmyc/QRCodeScan/blob/master/Screenshot/Screenshot4.png" width = "320" height = "568" /> 
| <img src="https://github.com/youmyc/QRCodeScan/blob/master/Screenshot/Screenshot5.png" width = "320" height = "568" /> | <img src="https://github.com/youmyc/QRCodeScan/blob/master/Screenshot/Screenshot3.png" width = "320" height = "568" />




## Author

* Email:260903229@qq.com

* Wechat:260903229
