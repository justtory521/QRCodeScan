//
//  AmbientLightSensor.h
//  QRCodeScan
//
//  Created by mac on 2018/12/24.
//  Copyright © 2018 youmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AmbientLightSensor;
@protocol AmbientLightSensorDelegate <NSObject>

- (void)ambientLightSensor:(AmbientLightSensor *)sensor show:(BOOL)flashLamp;

@end

@interface AmbientLightSensor : UIView
@property(nonatomic, weak) id<AmbientLightSensorDelegate> delegate;
- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)startRunning;
- (void)open;
- (void)close;
@end

NS_ASSUME_NONNULL_END
