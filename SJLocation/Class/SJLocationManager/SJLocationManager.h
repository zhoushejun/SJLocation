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

typedef void(^LocationCompletionHandlerBlock)(NSDictionary *addressDictionary);

/**
 @class     SJLocationManager
 @abstract  地理位置管理者
 */
@interface SJLocationManager : NSObject <CLLocationManagerDelegate>


+ (SJLocationManager *)sharedLocationManager;


- (void)requestLocationCompleteHandler:(LocationCompletionHandlerBlock)locationCompleteHandlerBlock;

@end
