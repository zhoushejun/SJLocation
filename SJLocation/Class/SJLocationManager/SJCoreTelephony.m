//
//  SJCoreTelephony.m
//  SJLocation
//
//  Created by shejun.zhou on 15/10/13.
//  Copyright © 2015年 shejun.zhou. All rights reserved.
//

#import "SJCoreTelephony.h"
#include <dlfcn.h>

CFMachPortRef port;
struct SJServerConnection *sc = NULL;
struct SJServerConnection scc;
struct SJCellInfo cellinfo;
int b;
int t1;

@implementation SJCoreTelephony


int callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    printf("Callback called\n");
    
    return 0;
}

- (void)requestCellInfo {
    int cellcount = 0;
    
    char* sdk_path = "/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony";
    int* handle =dlopen(sdk_path, RTLD_LAZY);
    void (*CTServerConnectionCellMonitorGetCellInfo)() = dlsym(handle, "_CTServerConnectionCellMonitorGetCellInfo");
    int* (*CTServerConnectionCellMonitorGetCellCount)() = dlsym(handle, "_CTServerConnectionCellMonitorGetCellCount");
    void (*CTServerConnectionCellMonitorStart)() = dlsym(handle, "_CTServerConnectionCellMonitorStart");
    struct CTServerConnection * (*CTServerConnectionCreate)() = dlsym(handle, "_CTServerConnectionCreate");
    int (*CTServerConnectionGetPort)() = dlsym(handle, "_CTServerConnectionGetPort");
    
    sc=CTServerConnectionCreate(kCFAllocatorDefault, callback, &t1);
    
    for(b = 0; b < cellcount; b++)
    {
        
        memset(&cellinfo, 0, sizeof(struct SJCellInfo));
        int ts = 0;
        
        /** 这个方法的问题出现在这里，3.0以前的版本是４个参数，运行后会崩溃，这个我花了很长时间发现是５个参数，不过获取的结果不理想，只获取了５个结果，其他４个是错误的，如果有人知道请，跟贴，或告诉我下，谢谢了*/
        CTServerConnectionCellMonitorGetCellInfo(&t1, sc, b, &ts, &cellinfo);
        
        printf("Cell Site: %d, MNC: %d, ",b,cellinfo.servingmnc);
        printf("LAC: %d, Cell ID: %d, Station: %d, ",cellinfo.location, cellinfo.cellid, cellinfo.station);
        printf("Freq: %d, RxLevel: %d, ", cellinfo.freq, cellinfo.rxlevel);
        printf("C1: %d, C2: %d\n", cellinfo.c1, cellinfo.c2);
        
    }
    
    dlclose(handle);
}

@end
