//
//  ViewController.m
//  QRCodeScanDemo
//
//  Created by youmy on 2018/11/28.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "ViewController.h"
#import <ScanQRCode/ScanQRCode.h>

@interface ViewController ()<QRCodeVCDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}

- (IBAction)scanBtn:(UIButton *)sender {
    NSBundle * b = [NSBundle bundleForClass:[QRCodeVC class]];
    QRCodeVC * vc = [[QRCodeVC alloc] init];
    vc.delegate = self;
    
    UIImage * borderImage = [UIImage imageNamed:@"扫描框" inBundle:b compatibleWithTraitCollection:nil];
    UIImage * lineImage = [UIImage imageNamed:@"扫描线" inBundle:b compatibleWithTraitCollection:nil];
    
    [vc setScanBorderImage:borderImage scanLineImage:lineImage];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    iv.image = borderImage;
    [self.view addSubview:iv];
}

#pragma mark - QRCodeVCDelegate
- (void)didFinishedScan:(QRCodeVC *)controller result:(NSString *)result{
    NSLog(@"---->:%@", result);
}
@end
