//
//  BorderView.h
//  QRCodeScan
//
//  Created by youmy on 2018/12/5.
//  Copyright © 2018 youmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BorderView : UIView

/**
 line length
 */
@property(nonatomic, assign) CGFloat lineLength;

/**
 line width
 */
@property(nonatomic, assign) CGFloat lineWidth;

/**
 Corner's color
 */
@property(nonatomic, strong) UIColor * anglecolor;
@end

NS_ASSUME_NONNULL_END
