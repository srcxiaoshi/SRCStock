//
//  Utility.h
//  AppIphone
//
//  Created by 史瑞昌 on 2016/10/22.
//  Copyright © 2016年 史瑞昌. All rights reserved.
//

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

typedef enum
{
    iPhoneDeviceTypeIPhone4,
    iPhoneDeviceTypeIPhone4S=iPhoneDeviceTypeIPhone4,
    iPhoneDeviceTypeIPhone5,
    iPhoneDeviceTypeIPhone5S=iPhoneDeviceTypeIPhone5,
    iPhoneDeviceTypeIPhone6,
    iPhoneDeviceTypeIPhone6P
    
}iPhoneDeviceType;

extern iPhoneDeviceType global_deviceType;

//机型
#define IS_IPHONE_5OR_ABOVE   (global_deviceType>=iPhoneDeviceTypeIPhone5S)
#define IS_IPHONE_6P  (global_deviceType==iPhoneDeviceTypeIPhone6P)
#define IS_IPHONE_6OR_ABOVE   (global_deviceType>=iPhoneDeviceTypeIPhone6)
#define IS_IPHONE_6           (global_deviceType==iPhoneDeviceTypeIPhone6)
#define IS_IPHONE4_OR_4S          (global_deviceType==iPhoneDeviceTypeIPhone4)

//适配
#define VALUE_FOR_UNIVERSE_DEVICE(a,b,c)   ((IS_IPHONE_6P)?(a):((IS_IPHONE_6)?(b):(c)))
#define VALUE_FOR_IPHONE_6(a,b)            ((IS_IPHONE_6)?(a):(b))
#define VALUE_FOR_IPHONE_6P(a,b)           ((IS_IPHONE_6P)?(a):(b))
#define VALUE_FOR_IPHONE4_OR_4S(a,b)           ((IS_IPHONE4_OR_4S)?(a):(b))

#define VIEW_WIDTH   MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define VIEW_HEIGHT  MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)

#define NavHeight               (64)
#define ECFilterHeight               (36)
#define IP               [NSURL URLWithString:@"http://www.swcc.org.cn"]
#define TabbarHeight            0
#import <Foundation/Foundation.h>
#import "UIColor+UIColorExt.h"
@interface Utility : NSObject
+ (float)iosVersion;

@end
