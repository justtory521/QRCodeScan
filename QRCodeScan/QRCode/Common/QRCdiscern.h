//
//  QRCdiscern.h
//  QRCodeScan
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019 youmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

@interface QRCdiscern : NSObject
@property(weak, nonatomic) id<QRCdiscernDelegate> delegate;

/**
 打开相册

 @param controller 当前控制器
 */
- (void)openAlbum:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
