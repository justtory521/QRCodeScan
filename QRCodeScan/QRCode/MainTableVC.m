//
//  MainTableVC.m
//  QRCodeScan
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018 youmy. All rights reserved.
//

#import "MainTableVC.h"
#import "QRCodeViewController.h"
#import "GenerateQRCVC.h"

@interface MainTableVC ()

@end

@implementation MainTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            QRCodeViewController * qrcVC = [[UIStoryboard storyboardWithName:@"QRCode" bundle:nil] instantiateViewControllerWithIdentifier:@"qrc"];
            qrcVC.title = @"条形码";
            qrcVC.isBarCode = YES;
            qrcVC.angleColor = [UIColor colorWithRed:0.122 green:0.565 blue:0.902 alpha:1.000];
            [self.navigationController pushViewController:qrcVC animated:YES];
        }
        break;
        case 1:
        {
            QRCodeViewController * qrcVC = [[UIStoryboard storyboardWithName:@"QRCode" bundle:nil] instantiateViewControllerWithIdentifier:@"qrc"];
            qrcVC.title = @"二维码";
            qrcVC.angleColor = [UIColor colorWithRed:0.125 green:0.812 blue:0.157 alpha:1.000];
            [self.navigationController pushViewController:qrcVC animated:YES];
        }
        break;
        case 2:
        {
            GenerateQRCVC * generateVC = [[UIStoryboard storyboardWithName:@"QRCode" bundle:nil] instantiateViewControllerWithIdentifier:@"generate"];
            generateVC.title = @"生成二维码/条形码";
            [self.navigationController pushViewController:generateVC animated:YES];
        }
        break;
        
        default:
        break;
    }
}
@end
