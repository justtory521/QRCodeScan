//
//  QRCodeVC.m
//  QRCodeScan
//
//  Created by youmy on 2018/11/28.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "QRCodeVC.h"
#import "ScanView.h"

@interface QRCodeVC ()<ScanViewDelegate>
/**  容器视图*/
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**  扫描容器高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightCons;
/**  冲击波边框视图*/
@property (weak, nonatomic) IBOutlet UIImageView *scanBorderView;
/**  冲击波视图*/
@property (weak, nonatomic) IBOutlet UIImageView *scanLineIV;
/**  冲击波视图顶部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineViewTopCons;

@property (weak, nonatomic) IBOutlet UILabel *desLb;

@property (strong, nonatomic) ScanView * scanView;

@property (assign, nonatomic) QRCodeType qrcodeType;

@property (strong, nonatomic) UIImage * borderImage;

@property (strong, nonatomic) UIImage * lineImage;

@end

@implementation QRCodeVC
#pragma mark - 懒加载

- (ScanView *)scanView{
    if (!_scanView) {
        _scanView = [[ScanView alloc] init];
        _scanView.delegate = self;
        _scanView.frame = [UIScreen mainScreen].bounds;
        [self.view insertSubview:_scanView atIndex:0];
    }
    return _scanView;
}
#pragma mark - Custorm

- (void)setScanBorderImage:(UIImage *)borderImage scanLineImage:(UIImage *)lingImage{
    _borderImage = borderImage;
    _lineImage = lingImage;
}

- (void)setIsBarCode:(BOOL)isBarCode{
    _isBarCode = isBarCode;
}

- (void)setDes:(NSString *)des{
    _desLb.text = des;
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.qrcodeType = _isBarCode ? QRCode : BarCode;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSLog(@"动态库获取bundle路径：%@",bundle.bundlePath);
    
//    NSString * scanBorderImagePath = [bundle pathForResource:@"扫描框" ofType:@".png"];
//    NSString * scanLineImagePath = [bundle pathForResource:@"扫描框" ofType:@".png"];
    
    [_scanBorderView setImage:_borderImage];
    [_scanLineIV setImage:_lineImage];
    
    if (_isBarCode) {
        _qrcodeType = BarCode;
        self.containerHeightCons.constant = ([UIScreen mainScreen].bounds.size.width - 83*2)/2.0;
        _desLb.text = @"将条形码放置在框内，即开始扫描";
    }else{
        _qrcodeType = QRCode;
        self.containerHeightCons.constant = [UIScreen mainScreen].bounds.size.width - 83*2;
        _desLb.text = @"将二维码放置在框内，即开始扫描";
    }
    
    [self scan];
}

- (void)scan{
    // 1.开始冲击波动画
    [self startAnimation];
    
    // 2.设置扫码类型
    self.scanView.qrcode = _qrcodeType;
    
    // 3.开始扫描
    [self.scanView startScan];
}

/** 开始冲击波动画 */
- (void)startAnimation{
    // 1.停止冲击波图层动画
    [self.scanBorderView.layer removeAllAnimations];
    
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

#pragma mark - ScanViewDelegate
- (void)didFinishScan:(ScanView *)scanView result:(NSString *)result{
    scanView.delegate = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(didFinishedScan:result:)]) {
        [_delegate didFinishedScan:self result:result];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)typeDidChange:(ScanView *)scanView rect:(CGRect)rect{
    self.containerHeightCons.constant = rect.size.height;
}
@end
