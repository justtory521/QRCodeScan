//
//  QRCodeViewController.h
//  QRCodeScan
//
//  Created by youmy on 2018/11/28.
//  Copyright © 2018 youmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QRCodeViewController;

@protocol QRCodeViewControllerDelegate <NSObject>

@optional
- (void)didFinishedScan:(QRCodeViewController *)controller result:(NSString *)result;

@end

@interface QRCodeViewController : UIViewController

/**
 YES Bar code, NO QR code
 */
@property(nonatomic, assign) BOOL isBarCode;

@property(nonatomic, strong) UIColor * angleColor;

/**
 类型说明
 */
@property(nonatomic, copy) NSString * des;
@property(nonatomic, weak) id<QRCodeViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
