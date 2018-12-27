//
//  GenerateQRCodeBar.h
//  QRCodeScan
//
//  Created by mac on 2018/12/27.
//  Copyright © 2018 youmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GenerateQRCodeBar : NSObject

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
    
@end

NS_ASSUME_NONNULL_END
