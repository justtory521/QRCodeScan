//
//  ScanView.h
//  QRCodeScan
//
//  Created by youmy on 2018/11/28.
//  Copyright © 2018 youmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BarCode,
    QRCode,
} QRCodeType;

@class ScanView;
@protocol ScanViewDelegate <NSObject>
    
/**
 扫描区域发生改变

 @param scanView ScanView
 @param rect 扫描框大小
 */
- (void)typeDidChange:(ScanView *)scanView rect:(CGRect)rect;
    
/**
 环境光传感器变化

 @param scanView ScanView
 @param flashLamp 是否开启闪光灯
 */
- (void)lightSensorDidChange:(ScanView *)scanView show:(BOOL)flashLamp;
@optional

/**
 完成扫码

 @param scanView ScanView
 @param result 扫码内容
 */
- (void)didFinishScan:(ScanView *)scanView result:(NSString *)result;

@end

@interface ScanView : UIView
@property(nonatomic, assign) QRCodeType qrcode;
@property(nonatomic, weak) id<ScanViewDelegate> delegate;

/**
 开始扫码
 */
- (void)startScan;
    

/**
 开启闪光灯
 */
- (void)open;
    

/**
 关闭闪光灯
 */
- (void)close;
@end

NS_ASSUME_NONNULL_END
