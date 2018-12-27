//
//  AmbientLightSensor.m
//  QRCodeScan
//
//  Created by mac on 2018/12/24.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "AmbientLightSensor.h"
#import <AVFoundation/AVFoundation.h>

@interface AmbientLightSensor ()<AVCaptureVideoDataOutputSampleBufferDelegate>
/**  会话*/
@property (strong, nonatomic) AVCaptureSession * session;

@property (strong, nonatomic) UIViewController * controller;

@end

@implementation AmbientLightSensor

- (void)startRunning{
    [self start];
}

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    _controller = viewController;
    self = [super init];
    if (self) {
        [self start];
    }
    return self;
}

- (void)start{
    // 1.获取硬件设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        NSLog(@"该换肾了");
        return;
    }
    
    // 2.创建输入流
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    // 3.创建设备输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    // AVCaptureSession属性
    _session = [[AVCaptureSession alloc]init];
    // 设置为高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加会话输入和输出
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }
    // 9.启动会话
    [_session startRunning];
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"环境光感 ： %f",brightnessValue);
    
    
    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL result = [device hasTorch];// 判断设备是否有闪光灯
    if ((brightnessValue < 0) && result) {// 打开闪光灯
        
        if (_delegate && [_delegate respondsToSelector:@selector(ambientLightSensor:show:)]) {
            [_delegate ambientLightSensor:self show:YES];
        }
        
    }else if((brightnessValue > 0) && result) {// 关闭闪光灯
        
        if (_delegate && [_delegate respondsToSelector:@selector(ambientLightSensor:show:)]) {
            [_delegate ambientLightSensor:self show:NO];
        }
    }
}

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
