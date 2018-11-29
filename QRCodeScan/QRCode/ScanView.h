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
- (void)typeDidChange:(ScanView *)scanView rect:(CGRect)rect;
@optional
- (void)didFinishScan:(ScanView *)scanView result:(NSString *)result;

@end

@interface ScanView : UIView
@property(nonatomic, assign) QRCodeType qrcode;
@property(nonatomic, weak) id<ScanViewDelegate> delegate;
- (void)startScan;
@end

NS_ASSUME_NONNULL_END
