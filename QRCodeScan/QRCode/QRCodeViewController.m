//
//  QRCodeViewController.m
//  QRCodeScan
//
//  Created by youmy on 2018/11/28.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UIView+Extension.h"
#import "ScanView.h"
#import "BorderView.h"
#import "AmbientLightSensor.h"

@interface QRCodeViewController ()<ScanViewDelegate>
/**  容器视图*/
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet BorderView *borderView;

/**  扫描容器高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightCons;
/**  冲击波视图顶部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineViewTopCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineHconstraint;

@property (weak, nonatomic) IBOutlet UILabel *desLb;

@property (weak, nonatomic) IBOutlet UIButton *lampBtn;
    
@property (weak, nonatomic) IBOutlet UIImageView *shockIV;
    
@property (strong, nonatomic) ScanView * scanView;

@property (assign, nonatomic) QRCodeType qrcodeType;

@property (strong, nonatomic) UIImage * borderImage;

@property (strong, nonatomic) UIImage * lineImage;

@property(nonatomic, assign) BOOL isOpen;

@end

@implementation QRCodeViewController
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

- (void)setIsBarCode:(BOOL)isBarCode{
    _isBarCode = isBarCode;
}

- (void)setDes:(NSString *)des{
    _desLb.text = des;
}

- (IBAction)backBtnAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isOpen = NO;
    self.qrcodeType = _isBarCode ? QRCode : BarCode;
    
    _borderView.anglecolor = _angleColor;
    _shockIV.image = [[UIImage imageNamed:@"alipay_scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _shockIV.tintColor = _angleColor;
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(startAnimation) name:@"qrcStartAnimation" object:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self settingScanType];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startAnimation];
}
    
- (void)setAngleColor:(UIColor *)angleColor{
    _angleColor = angleColor;
}

- (void)settingScanType{
    if (_isBarCode) {
        _qrcodeType = BarCode;
        self.containerHeightCons.constant = ([UIScreen mainScreen].bounds.size.width - 83*2)/2.0;
        self.scanLineHconstraint.constant = ([UIScreen mainScreen].bounds.size.width - 83*2)/2.0;
        _desLb.text = @"将条形码放置在框内，即开始扫描";
    }else{
        _qrcodeType = QRCode;
        self.containerHeightCons.constant = [UIScreen mainScreen].bounds.size.width - 83*2;
        self.scanLineHconstraint.constant = [UIScreen mainScreen].bounds.size.width - 83*2;
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

- (IBAction)lampBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIColor * color = sender.isSelected ? _angleColor : [UIColor whiteColor];
    [sender setTitleColor:color forState:UIControlStateNormal];
    sender.hidden = !sender.selected;
    _isOpen = sender.isSelected;
    [sender setTitle:sender.isSelected ? @"轻点关闭" : @"轻点照亮" forState:UIControlStateNormal];
    if (sender.isSelected) {
        [_scanView open];
    }else{
        [_scanView close];
    }
}

/** 开始冲击波动画 */
- (void)startAnimation{
    
    // 1.停止冲击波图层动画
    [self.view.layer removeAllAnimations];

    // 2.让约束从顶部开始
    self.scanLineViewTopCons.constant = -self.containerHeightCons.constant;
    
    // 3.更新视图布局
    [self.view layoutIfNeeded];

    // 4.执行冲击波动画
    [UIView animateWithDuration:2.0 animations:^{
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

- (void)lightSensorDidChange:(ScanView *)scanView show:(BOOL)flashLamp{
    if (!_isOpen) {
        _lampBtn.hidden = !flashLamp;
    }
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    self.isBarCode = item.tag == 1 ? YES : NO;
    [self settingScanType];
    [_containerView setNeedsLayout];
    [_borderView setNeedsDisplay];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
