//
//  SJLocationManager.m
//  SJLocation
//
//  Created by shejun.zhou on 15/10/12.
//  Copyright © 2015年 shejun.zhou. All rights reserved.
//

#import "SJLocationManager.h"
#import <UIKit/UIKit.h>

@interface SJLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) LocationCompletionHandlerBlock locationCompletionHandlerBlock;

- (BOOL)locationServicesEnabled;

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
    NSLog(@"%@", locations);
    CLLocation *location = locations[0];
    NSLog(@"altitude:%f", location.altitude);
    NSLog(@"coordinate:%f - %f", location.coordinate.latitude, location.coordinate.longitude);
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSDictionary *addressDictionary = placemark.addressDictionary;
            NSLog(@"addressDic:%@", addressDictionary);
            if (_locationCompletionHandlerBlock) {
                _locationCompletionHandlerBlock(addressDictionary);
                _locationCompletionHandlerBlock = nil;
//                [self stopLocation];//如果不需要实时定位，使用完后立即关闭定位服务
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [_locationManager startUpdatingLocation];
}

#pragma mark - public function

- (void)requestLocationCompleteHandler:(LocationCompletionHandlerBlock)locationCompletionHandlerBlock {
    if (locationCompletionHandlerBlock) {
        _locationCompletionHandlerBlock = locationCompletionHandlerBlock;
    }
    [self startLocation];
}

#pragma mark - private function

- (BOOL)locationServicesEnabled {
    
    return YES;
}

-(void)startLocation {
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if (!IOS_VERSION_7){
            [_locationManager requestWhenInUseAuthorization];
        }
        _locationManager.distanceFilter = 100;
        if (!IOS_VERSION_8) {
            _locationManager.allowsBackgroundLocationUpdates = YES;
        }
    }else {
        if (IOS_VERSION_7){
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示"
                                                              message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles: nil];
            [alvertView show];
           
        }else{
            UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击设置");
                NSLog(@"设置界面");
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            UIAlertAction *cancleAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
            }];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"需要授权本应用程序使用定位服务"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:okAlertAction];
            [alertController addAction:cancleAlertAction];
            UIWindow *win = [UIApplication sharedApplication].keyWindow;
            [win.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stopLocation];
    
}

-(void)stopLocation {
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}


@end
