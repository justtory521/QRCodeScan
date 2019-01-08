//
//  GenerateQRCVC.m
//  QRCodeScan
//
//  Created by mac on 2018/12/27.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "GenerateQRCVC.h"
#import "GenerateQRCodeBar.h"
#import "ScreenshotTool.h"

@interface GenerateQRCVC ()
    @property (weak, nonatomic) IBOutlet UIImageView *qrcIV;
    @property (weak, nonatomic) IBOutlet UIImageView *barIV;
    
@end

@implementation GenerateQRCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage * image = [GenerateQRCodeBar generateQRCodeWithContent:@"https://www.woaizuji.com/#footer" size:_qrcIV.frame.size];
    _qrcIV.image = image;
    [self drawBoder:_qrcIV];
    
    _barIV.image = [GenerateQRCodeBar generateBarCodeWithContent:@"75564454384589" size:_barIV.bounds.size];
    [self drawBoder:_barIV];
    
}
    
- (void)drawBoder:(UIView *)view{
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0;
}

- (IBAction)save:(UIBarButtonItem *)sender {
    [ScreenshotTool screenShotWithView:self.qrcIV];
}

@end
