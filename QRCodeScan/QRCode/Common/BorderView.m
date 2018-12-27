//
//  BorderView.m
//  QRCodeScan
//
//  Created by youmy on 2018/12/5.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "BorderView.h"

@implementation BorderView

- (void)setLineLength:(CGFloat)lineLength{
    _lineLength = lineLength;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
}

- (void)setAnglecolor:(UIColor *)anglecolor{
    _anglecolor = anglecolor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.layer.borderColor = _anglecolor.CGColor;
    self.layer.borderWidth = 1;
    
    [self drawBorder];
}

- (void)drawBorder{
    
    CGFloat space = _lineLength == 0 ? 19 : _lineLength;
    
    // 1. 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, _lineWidth == 0 ? 8 : _lineWidth);
    
    // 2. 设置当前上下文的路径
    // 1) 设置起始点
    CGContextMoveToPoint(context, 0, space);
    // 2) 增加点
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, space, 0);
    
    CGContextMoveToPoint(context, self.bounds.size.width - space, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, space);
    
    CGContextMoveToPoint(context, self.bounds.size.width, self.bounds.size.height - space);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width - space, self.bounds.size.height);
    
    CGContextMoveToPoint(context, space, self.bounds.size.height);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height - space);
    
    // 3) 关闭路径
//    CGContextClosePath(context);
    
    // 3 设置属性
    /*
     UIKit默认会导入Core Graphics框架，UIKit对常用的很多CG方法做了封装
     
     UIColor setStroke  设置边线颜色
     UIColor setFill    设置填充颜色
     UIColor set        设置边线和填充颜色
     */
    // 设置边线
    [_anglecolor setStroke];
    // 设置填充
    [[UIColor clearColor] setFill];
    // 设置边线和填充
//    [[UIColor greenColor]set];
    
    // 4 绘制路径，虽然没有直接定义路径，但是第2步操作，就是为上下文指定路径
    CGContextDrawPath(context, kCGPathFillStroke);
        
}

@end
