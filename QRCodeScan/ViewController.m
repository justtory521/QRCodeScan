//
//  ViewController.m
//  QRCodeScan
//
//  Created by youmy on 16/3/6.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import "ViewController.h"
#import "QRCode/QRCodeVC.h"
@interface ViewController ()<QRCodeVCDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatScanBtn];
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
    
    QRCodeVC * vc = [[QRCodeVC alloc] init];
    vc.delegate = self;
    vc.isBarCode = YES;
    [vc setScanBorderImage:[UIImage imageNamed:@"扫描框"] scanLineImage:[UIImage imageNamed:@"扫描线"]];
    [self.navigationController pushViewController:vc animated:YES];
    
//    UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"QRCode" bundle:nil];
//    UIViewController * vc = mainStoryBoard.instantiateInitialViewController;
//    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - QRCodeVCDelegate
- (void)didFinishedScan:(QRCodeVC *)controller result:(NSString *)result{
    NSLog(@"---->:%@", result);
}
@end
