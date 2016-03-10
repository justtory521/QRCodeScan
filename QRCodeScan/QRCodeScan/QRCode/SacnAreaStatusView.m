//
//  SacnAreaStatusView.m
//  QRCodeScan
//
//  Created by youmy on 16/3/10.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import "SacnAreaStatusView.h"

@implementation SacnAreaStatusView

- (instancetype)init{
    if (self = [super init]) {
        [self bgColorAnimation];
    }
    return self;
}

- (void)bgColorAnimation{
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
        self.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.2];
    } completion:nil];
}

- (void)setCenterRect:(CGRect)centerRect{
    _centerRect = centerRect;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addPreviewRect:ctx rect:self.bounds];
    [self addScanAreaHighlightedRect:ctx rect:_centerRect];
}

- (void)addPreviewRect:(CGContextRef)ctx rect:(CGRect)rect{
    CGContextSetRGBFillColor(ctx, 0.0,0.0,0.0,0.2);
    CGContextFillRect(ctx, rect);
}

- (void)addScanAreaHighlightedRect:(CGContextRef)ctx rect:(CGRect)rect{
    CGContextClearRect(ctx, rect);
}
@end
