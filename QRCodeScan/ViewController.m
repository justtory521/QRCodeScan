//
//  ViewController.m
//  QRCodeScan
//
//  Created by youmy on 16/3/6.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import "ViewController.h"
#import "BorderView.h"
#import "AmbientLightSensor.h"
#import "QRCode/QRCodeViewController.h"
@interface ViewController ()<AmbientLightSensorDelegate>
@property(nonatomic, strong) UIButton * lamp;
@property(nonatomic, strong) AmbientLightSensor * lightSensor;
@property(nonatomic, assign) BOOL isOpen;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isOpen = NO;
    [self creatScanBtn];
//
//    BorderView * borderV = [[BorderView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
//    borderV.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:borderV];
    
//    _lightSensor = [[AmbientLightSensor alloc] initWithViewController:self];
//    _lightSensor.frame = CGRectMake(50, 150, 100, 100);
//    _lightSensor.backgroundColor = [UIColor grayColor];
//    _lightSensor.delegate = self;
//    [self.view addSubview:_lightSensor];
//
//    _lamp = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 100, 50)];
//    _lamp.backgroundColor = [UIColor lightGrayColor];
//    _lamp.hidden = YES;
//    [_lamp setTitle:@"轻点照亮" forState:UIControlStateNormal];
//    [_lamp addTarget:self action:@selector(openLamp:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_lamp];
    
}

- (void)openLamp:(UIButton *)sender{
    sender.selected = !sender.selected;
    sender.backgroundColor = sender.isSelected ? [UIColor redColor] : [UIColor lightGrayColor];
    sender.hidden = !sender.selected;
    _isOpen = sender.isSelected;
    [sender setTitle:sender.isSelected ? @"轻点关闭" : @"轻点照亮" forState:UIControlStateNormal];
    if (sender.isSelected) {
        [_lightSensor open];
    }else{
        [_lightSensor close];
    }
}

/**
 *  创建扫描按钮
 */
- (void)creatScanBtn{
    UIButton * scanBtn = [[UIButton alloc] init];
    [scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [scanBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [scanBtn sizeToFit];
    scanBtn.center = self.view.center;
    [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
}

/**
 *  打开扫描界面
 */
- (void)scanBtnClick {
    
    UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"QRCode" bundle:nil];
    UIViewController * vc = mainStoryBoard.instantiateInitialViewController;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - AmbientLightSensorDelegate
- (void)ambientLightSensor:(AmbientLightSensor *)sensor show:(BOOL)flashLamp{
    
    if (!_isOpen) {
        _lamp.hidden = !flashLamp;
    }
}
@end
