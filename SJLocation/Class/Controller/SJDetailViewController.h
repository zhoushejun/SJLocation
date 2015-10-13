//
//  SJDetailViewController.h
//  SJLocation
//
//  Created by shejun.zhou on 15/10/12.
//  Copyright © 2015年 shejun.zhou. All rights reserved.
//

/**
 @header    SJDetailViewController.h
 @abstract  显示详细信息界面
 @author    shejun.zhou
 @version   1.0 15/10/12 Creation
 */
#import <UIKit/UIKit.h>

/**
 @class     SJDetailViewController
 @abstract  显示详细信息界面
 */
@interface SJDetailViewController : UIViewController

@property (nonatomic, copy, nonnull) NSString *fileName;
@property (nonatomic, copy, nullable) NSString *locationText;

@end
