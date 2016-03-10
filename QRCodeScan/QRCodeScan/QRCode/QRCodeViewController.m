//
//  QRCodeViewController.m
//  QRCodeScan
//
//  Created by youmy on 16/3/6.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Extension.h"
#import "SacnAreaStatusView.h"

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UITabBarDelegate>
/**  容器视图*/
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**  扫描容器高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightCons;
/**  冲击波视图*/
@property (weak, nonatomic) IBOutlet UIImageView *scanLineView;
/**  冲击波视图顶部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineViewTopCons;
/**  底部视图*/
@property (weak, nonatomic) IBOutlet UITabBar *customTabBar;
/**  会话*/
@property (strong, nonatomic) AVCaptureSession * session;
/**  输入设备*/
@property (strong, nonatomic) AVCaptureDeviceInput * deviceInput;
/**  输出对象*/
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
/**  预览图层*/
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;
/**  二维码绘制图层*/
@property (strong, nonatomic) CALayer * drawLayer;

@property (strong, nonatomic) SacnAreaStatusView * scanAreaView;
@end

@implementation QRCodeViewController

#pragma mark - 懒加载
- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureDeviceInput *)deviceInput{
    if (!_deviceInput) {
        NSError * error;
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    }
    return _deviceInput;
}

- (AVCaptureMetadataOutput *)output{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
    }
    return _output;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _previewLayer;
}

- (CALayer *)drawLayer{
    if (!_drawLayer) {
        _drawLayer = [CALayer layer];
        _drawLayer.frame = [UIScreen mainScreen].bounds;
        [self.view.layer addSublayer:_drawLayer];
    }
    return _drawLayer;
}

- (SacnAreaStatusView *)scanAreaView{
    if (!_scanAreaView) {
        _scanAreaView = [[SacnAreaStatusView alloc] init];
        _scanAreaView.frame = self.view.bounds;
        [self.view insertSubview:_scanAreaView atIndex:1];
    }
    return _scanAreaView;
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置底部视图默认选中第0个item
    self.customTabBar.selectedItem = self.customTabBar.items[0];
    // 设置TabBar代理
    self.customTabBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 1.开始冲击波动画
    [self startAnimation];
    
    // 2.开始扫描
    [self startScan];
    
    // 3.扫描区域高度
    [self setScanAreaHighlighted:false];
}

#pragma mark - Private Methods
/** 返回按钮*/
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 开始冲击波动画 */
- (void)startAnimation{
    // 1.停止冲击波图层动画
    [self.scanLineView.layer removeAllAnimations];
    
    // 2.让约束从顶部开始
    self.scanLineViewTopCons.constant = -self.containerHeightCons.constant;
    
    // 3.更新视图布局
    [self.view layoutIfNeeded];
    
    // 4.执行冲击波动画
    [UIView animateWithDuration:1.5 animations:^{
        // 5.修改约束
        self.scanLineViewTopCons.constant = self.containerHeightCons.constant;
        // 6.设置动画次数
        [UIView setAnimationRepeatCount:MAXFLOAT];
        // 7.更新视图布局
        [self.view layoutIfNeeded];
    }];
}

/** 开始扫描 */
- (void)startScan{
    // 1.判断是否能够将输入设备添加到会话中
    if (![self.session canAddInput:self.deviceInput]) {
        return;
    }
    
    // 2.判断是否能够将输出对象添加到会话中
    if (![self.session canAddOutput:self.output]) {
        return;
    }
    
    // 3.将输入设备和输出对象添加到会话中
    [self.session addInput:self.deviceInput];
    [self.session addOutput:self.output];
    
    // 4.设置输出能够解析的数据类型
    // 注意：设置能够解析的数据类型，一定要在输出对象添加到会话之后设置，否则会报错
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    
    // 5.设置输出对象代理，只要解析成功就会通知代理
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 6.设置预览图层
    [self setupPreviewLayer:1.0];
    
    // 6.1将预览图层插入到最底层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 7.告诉session开始扫描
    [self.session startRunning];
}

/** 设置预览图层 */
- (void)setupPreviewLayer:(CGFloat)i{
    // 限制扫描区域(原点位于右上角，默认值是(0,0,1,1)，x,y是反的)
    CGFloat x = (self.view.height - self.containerView.width * i) / 2 / self.view.height;
    CGFloat y = (self.view.width - self.containerView.width) / 2 / self.view.width;
    CGFloat width = self.containerView.width * i / self.view.height;
    CGFloat height = self.containerView.width / self.view.width;
    self.output.rectOfInterest = CGRectMake(x, y, width, height);
}

/** 扫描区域高亮 */
- (void)setScanAreaHighlighted:(BOOL)type{
    CGPoint center = self.view.center;
    CGFloat width = self.containerView.width - 10;
    CGFloat x = center.x - width / 2.0;
    
    if (type) {
        CGFloat y = center.y - width / 4.0;
        self.scanAreaView.centerRect = CGRectMake(x, y, width, width / 2.0);
    }else{
        CGFloat y = center.y - width / 2.0;
        self.scanAreaView.centerRect = CGRectMake(x, y, width, width);
    }
}


/** 绘制图层 */
- (void)drawCorners:(AVMetadataMachineReadableCodeObject *)codeObject{
    // 0.判断codeObject.corners是否为空
    if (!codeObject.corners) {
        return;
    }
    
    // 1.创建一个图层
    CAShapeLayer * layer = [CAShapeLayer layer];
    // 1.1设置线条宽度
    layer.lineWidth = 4.0;
    // 1.2设置画笔颜色
    layer.strokeColor = [UIColor greenColor].CGColor;
    // 1.3设置填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 2.创建路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    // 2.1设置起点
    CGPoint point = CGPointZero;
    NSInteger index = 0;
    
    // 2.2移动到第一个点
    // 从corners数组中取出第0个元素，将这个字典中x/y赋值给point
    CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)codeObject.corners[index++], &point);
    [path moveToPoint:point];
    // 2.3 移动到其他的点
    while (index < codeObject.corners.count) {
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)codeObject.corners[index++], &point);
        [path addLineToPoint:point];
    }
    // 2.4 关闭路径连接首尾结点
    [path closePath];
    
    // 2.5 绘制路径
    layer.path = path.CGPath;
    
    // 3.将绘制好的图层添加到drawLayer上
    [self.drawLayer addSublayer:layer];
}

/** 清除边线 */
- (void)clearCorners{
    // 1.判断图层是否为空
    if (self.drawLayer.sublayers == nil || self.drawLayer.sublayers.count == 0) {
        return;
    }
    
    // 2.移除所有子图层
    for (CALayer * layer in self.drawLayer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // 1.清空边线
    [self clearCorners];
    
    // 2.获取扫描到的二维码的位置
    // 转换坐标
    for (id object in metadataObjects) {
        // 3.判断当前获取的数据，是否是机器可识别的
        if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            id codeObject = [self.previewLayer transformedMetadataObjectForMetadataObject:object];
            // 4.绘制边线
            [self drawCorners:codeObject];
        }
    }
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    self.containerHeightCons.constant = self.scanLineView.width * (item.tag == 1 ? 0.5 : 1);
    [self setupPreviewLayer:item.tag == 1 ? 0.5 : 1.0];
    [self setScanAreaHighlighted:item.tag];
    [self startAnimation];
}
@end
