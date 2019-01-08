//
//  QRCdiscern.m
//  QRCodeScan
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019 youmy. All rights reserved.
//

#import "QRCdiscern.h"

@interface QRCdiscern ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong, nonatomic) UIViewController * viewController;
@end

@implementation QRCdiscern

- (void)openAlbum:(UIViewController *)controller{
    _viewController = controller;
    NSLog(@"我的相册");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        //1.初始化相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //2.设置代理
        controller.delegate = self;
        //3.设置资源：
        /**
         UIImagePickerControllerSourceTypePhotoLibrary,相册
         UIImagePickerControllerSourceTypeCamera,相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库
         */
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //4.随便给他一个转场动画
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [_viewController presentViewController:controller animated:YES completion:NULL];
        
    }else{
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action];
        
        [_viewController presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark-> imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        NSString * title = @"";
        NSString * msg = @"";
        NSString * cancel = @"确定";
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            
            title = @"扫描结果";
            msg = scannedResult;
        }
        else{
            title = @"提示";
            msg = @"该图片没有包含一个二维码！";
        }
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action];
        
        [_viewController presentViewController:alertVC animated:YES completion:nil];
        
    }];
    
    
}

@end
