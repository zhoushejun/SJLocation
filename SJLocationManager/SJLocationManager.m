//
//  SJLocationManager.m
//  SJLocation
//
//  Created by shejun.zhou on 15/10/12.
//  Copyright © 2015年 shejun.zhou. All rights reserved.
//

#import "SJLocationManager.h"
#import <UIKit/UIKit.h>

/** @name DEBUG 模式下打印日志和当前行数 */
// @{
#if DEBUG
#define SJLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content--->>> \n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define SJLogCurrentFunction fprintf(stderr,"\nfuction:%s", __FUNCTION__);
#else
#define SJLog(FORMAT, ...) nil
#endif
// @}end of DEBUG 模式下打印日志和当前行数


/** @name version */
// @{
#define kSJ_currentDevice        [UIDevice currentDevice]
#define kSJ_currentSystemVersion [kSJ_currentDevice systemVersion]
#define kSJ_iOS_VERSION          [kSJ_currentSystemVersion floatValue]
// @}end of version

/** @name 获取屏幕 宽度、高度 及 状态栏 高度 */
// @{
#define kSJ_SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define kSJ_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// @}end of 获取屏幕 宽度、高度 及 状态栏 高度

@interface SJLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager; ///< 系统地理位置管理者
@property (nonatomic, strong) LocationCompletionHandlerBlock locationCompletionHandlerBlock; ///< 回调block

/** 
 @method    showAuthorizationAlertAction
 @abstract  显示授权窗口 
 */
- (void)showAuthorizationAlertAction;

/**
 @method    startLocation
 @abstract  开始定位 
 */
-(void)startLocation;

/**
 @method    stopLocation
 @abstract  停止定位 
 */
-(void)stopLocation;

@end

@implementation SJLocationManager

+ (SJLocationManager *)sharedLocationManager {
    static SJLocationManager *locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[[self class] alloc] init];
    });
    return locationManager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    SJLog(@"%@", locations);
    CLLocation *location = locations[0];
    SJLog(@"altitude:%f", location.altitude);
    SJLog(@"coordinate:%f - %f", location.coordinate.latitude, location.coordinate.longitude);
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSDictionary *addressDictionary = placemark.addressDictionary;
            SJLog(@"addressDic:%@", addressDictionary);
            if (_locationCompletionHandlerBlock) {
                _locationCompletionHandlerBlock(addressDictionary);
                _locationCompletionHandlerBlock = nil;
                if (_autoStopLocation) {
                    [self stopLocation]; ///< 如果不需要实时定位，使用完后立即关闭定位服务
                }
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stopLocation];
    
}

#pragma mark - public function

- (void)requestLocationCompleteHandler:(LocationCompletionHandlerBlock)locationCompletionHandlerBlock {
    if (locationCompletionHandlerBlock) {
        _locationCompletionHandlerBlock = locationCompletionHandlerBlock;
    }
    [self startLocation];
}

#pragma mark - private function

- (void)showAuthorizationAlertAction {
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"去设置授权" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SJLog(@"点击去设置授权");
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    UIAlertAction *cancleAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SJLog(@"点击取消");
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"使用定位服务需要得到您的授权"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancleAlertAction];
    [alertController addAction:okAlertAction];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)startLocation {
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if (kSJ_iOS_VERSION >= 8.0){
            [_locationManager requestWhenInUseAuthorization]; ///< 运行期间允许访问位置信息，当APP退到后台时在状态栏处会显示《"SJLocation"正在使用您的位置信息》提示框
            [_locationManager requestAlwaysAuthorization]; ///< 始终允许访问位置信息
        }
        _locationManager.distanceFilter = 100;
        if (kSJ_iOS_VERSION >= 9.0) {
            _locationManager.allowsBackgroundLocationUpdates = YES;
        }
    }
    else {
        [self showAuthorizationAlertAction];
    }
}

-(void)stopLocation {
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

@end
