//
//  ViewController.m
//  QRCodeScan
//
//  Created by youmy on 16/3/6.
//  Copyright © 2016年 youmy. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

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
    UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"QRCode" bundle:nil];
    UIViewController * vc = mainStoryBoard.instantiateInitialViewController;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
