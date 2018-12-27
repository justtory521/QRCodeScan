//
//  ScanView.m
//  QRCodeScan
//
//  Created by youmy on 2018/11/28.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "ScanView.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanAreaStatusView.h"
#import "UIView+Extension.h"

@interface ScanView()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
/**  会话*/
@property (strong, nonatomic) AVCaptureSession * session;
/**  输入设备*/
@property (strong, nonatomic) AVCaptureDeviceInput * deviceInput;
/**  输出对象*/
@property (strong, nonatomic) AVCaptureMetadataOutput * output;

@property (strong, nonatomic) AVCaptureVideoDataOutput * videoDataOutput;
/**  预览图层*/
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;
/**  二维码绘制图层*/
@property (strong, nonatomic) CALayer * drawLayer;

@property (strong, nonatomic) ScanAreaStatusView * scanAreaView;

@end

@implementation ScanView

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - Lazy

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

- (AVCaptureVideoDataOutput *)videoDataOutput{
    if (!_videoDataOutput) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        // 设置代理AVCaptureVideoDataOutputSampleBufferDelegate用于捕获环境光的变化
        [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    return _videoDataOutput;
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
        [self.layer addSublayer:_drawLayer];
    }
    return _drawLayer;
}

- (ScanAreaStatusView *)scanAreaView{
    if (!_scanAreaView) {
        _scanAreaView = [[ScanAreaStatusView alloc] init];
        _scanAreaView.frame = self.bounds;
        [self insertSubview:_scanAreaView atIndex:1];
    }
    return _scanAreaView;
}

#pragma mark -
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
    
    // 2.1 同2用于光传感器
    if ([self.session canAddOutput:self.videoDataOutput]) {
        [self.session addOutput:self.videoDataOutput];
        // 设置为高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
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
    [self setupPreviewLayer:self.qrcode];
    
    // 6.1将预览图层插入到最底层
    [self.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 7.告诉session开始扫描
    [self.session startRunning];
}

/** 设置预览图层 */
- (void)setupPreviewLayer:(QRCodeType)type{
    // 限制扫描区域(原点位于右上角，默认值是(0,0,1,1)，x,y是反的)
    
    CGSize size = self.bounds.size;
    CGFloat width = size.width - 83*2;
    CGFloat x = 83;
    CGFloat y = (size.height - width)/2.0;
    
    CGRect cropRect = CGRectMake(x,y,width,width);
    
    switch (type) {
        case QRCode:
            break;
        case BarCode:
        {
            y = (size.height - width/2.0)/2.0;
            cropRect = CGRectMake(x,y,width,width/2.0);
        }
            break;
            
        default:
            break;
    }
    
    CGRect rect = CGRectMake(cropRect.origin.y/size.height,
                             cropRect.origin.x/size.width,
                             cropRect.size.height/size.height,
                             cropRect.size.width/size.width);
    
    if (_delegate && [_delegate respondsToSelector:@selector(typeDidChange:rect:)]) {
        [_delegate typeDidChange:self rect:cropRect];
    }
    
    self.output.rectOfInterest = rect;
}

/** 扫描区域高亮 */
- (void)setScanAreaHighlighted:(QRCodeType)type{
    CGSize size = self.bounds.size;
    CGFloat width = size.width - 83*2;
    CGFloat x = 83;
    
    switch (type) {
        case QRCode:
        {
            CGFloat y = (size.height - width)/2.0;
            CGRect cropRect = CGRectMake(x,y,width,width);
            self.scanAreaView.centerRect = cropRect;
        }
            break;
        case BarCode:
        {
            CGFloat y = (size.height - width/2.0)/2.0;
            CGRect cropRect = CGRectMake(x,y,width,width/2.0);
            self.scanAreaView.centerRect = cropRect;
        }
            break;
        default:
            break;
    }
}

- (void)setQrcode:(QRCodeType)qrcode{
    _qrcode = qrcode;
    [self setupPreviewLayer:qrcode];
    [self setScanAreaHighlighted:qrcode];
}

#pragma mark -
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
    CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)codeObject.corners[index], &point);
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
            AVMetadataMachineReadableCodeObject * obj = metadataObjects.firstObject;
            if (_delegate && [_delegate respondsToSelector:@selector(didFinishScan:result:)]) {
                [_delegate didFinishScan:self result:obj.stringValue];
            }
        }
    }
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
//    NSLog(@"环境光感 ： %f",brightnessValue);
    
    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL result = [device hasTorch];// 判断设备是否有闪光灯
    if ((brightnessValue < 0) && result) {// 打开闪光灯
        
        if (_delegate && [_delegate respondsToSelector:@selector(lightSensorDidChange:show:)]) {
            [_delegate lightSensorDidChange:self show:YES];
        }
        
    }else if((brightnessValue > 0) && result) {// 关闭闪光灯
        
        if (_delegate && [_delegate respondsToSelector:@selector(lightSensorDidChange:show:)]) {
            [_delegate lightSensorDidChange:self show:NO];
        }
    }
}

#pragma mark - Ambient Light Sensor
- (void)open{
    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOn];//开
    [device unlockForConfiguration];
}

- (void)close{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];//关
    [device unlockForConfiguration];
}
@end
