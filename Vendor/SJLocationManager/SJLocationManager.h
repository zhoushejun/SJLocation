//
//  SJLocationManager.h
//  SJLocation
//
//  Created by shejun.zhou on 15/10/12.
//  Copyright © 2015年 shejun.zhou. All rights reserved.
//

/**
 @header    SJLocationManager.h
 @abstract  地理位置管理者
 @author    shejun.zhou
 @version   1.0 15/10/12 Creation
 */
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/** 接收回调 block */
typedef void(^LocationCompletionHandlerBlock)(NSDictionary *addressDictionary);

/**
 @class     SJLocationManager
 @abstract  地理位置管理者
 */
@interface SJLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, assign) BOOL autoStopLocation; ///< 定位到地理位置后立即关闭定位服务

/**
 @method    sharedLocationManager
 @abstract  获取地理位置管理者单例方法
 */
+ (SJLocationManager *)sharedLocationManager;

/**
 @method    requestLocationCompleteHandler:
 @abstract  请求地理位置信息方法
 @param     locationCompleteHandlerBlock 回调block
 */
- (void)requestLocationCompleteHandler:(LocationCompletionHandlerBlock)locationCompleteHandlerBlock;

@end
