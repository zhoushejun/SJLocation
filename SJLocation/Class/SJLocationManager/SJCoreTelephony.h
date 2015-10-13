//
//  SJCoreTelephony.h
//  SJLocation
//
//  Created by shejun.zhou on 15/10/13.
//  Copyright © 2015年 shejun.zhou. All rights reserved.
//

/**
 @header    SJCoreTelephony.h
 @abstract  通过手机基站获取地理位置
 @author    shejun.zhou
 @version   1.0 15/10/13 Creation
 */
#import <Foundation/Foundation.h>

struct SJServerConnection
{
    int a;
    int b;
    CFMachPortRef myport;
    int c;
    int d;
    int e;
    int f;
    int g;
    int h;
    int i;
};

struct SJCellInfo
{
    int servingmnc;
    int network;
    int location;
    int cellid;
    int station;
    int freq;
    int rxlevel;
    // int freq;
    int c1;
    int c2;
};

/**
 @class     SJCoreTelephony
 @abstract  通过手机基站获取地理位置
 */
@interface SJCoreTelephony : NSObject

- (void)requestCellInfo;

@end
