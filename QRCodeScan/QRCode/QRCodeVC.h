//
//  QRCodeVC.h
//  QRCodeScan
//
//  Created by youmy on 2018/11/28.
//  Copyright © 2018 youmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QRCodeVC;
@protocol QRCodeVCDelegate <NSObject>

@optional
- (void)didFinishedScan:(QRCodeVC *)controller result:(NSString *)result;

@end

@interface QRCodeVC : UIViewController

/**
 YES Bar code, NO QR code
 */
@property(nonatomic, assign) BOOL isBarCode;
/**
 类型说明
 */
@property(nonatomic, copy) NSString * des;
@property(nonatomic, weak) id<QRCodeVCDelegate> delegate;

- (void)setScanBorderImage:(UIImage *)borderImage scanLineImage:(UIImage *)lingImage;
@end

NS_ASSUME_NONNULL_END
