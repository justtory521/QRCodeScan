//
//  ScreenshotTool.h
//  QRCodeScan
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019 youmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenshotTool : UIView

/**
 截图

 @param view 所需截图的View
 @return 截图后的图片
 */
+ (UIImage *)screenShotWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
