//
//  Utility.m
//  AppIphone
//
//  Created by 史瑞昌 on 2016/10/22.
//  Copyright © 2016年 史瑞昌. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>
iPhoneDeviceType global_deviceType;
@implementation Utility

+(void)load
{
    [self getDeviceType];
}

//获取设备尺寸信息
+(void)getDeviceType
{
    iPhoneDeviceType type=iPhoneDeviceTypeIPhone4;
    CGRect bounds=[[UIScreen mainScreen] bounds];
    CGFloat height=bounds.size.height;
    CGFloat width=bounds.size.width;
    if (height<568) {
        type=iPhoneDeviceTypeIPhone4S;
    }
    else if(height<667)
    {
        type=iPhoneDeviceTypeIPhone5S;
    }
    else if(height<736)
    {
        type=iPhoneDeviceTypeIPhone6;
    }
    else if(width>=414)
    {
        type=iPhoneDeviceTypeIPhone6P;
    }
    global_deviceType=type;
}

+ (float)iosVersion
{
    return [[self systemVersionString] floatValue];
}

+ (NSString *)systemVersionString
{
    static NSString *version = nil;
    if (version == nil) {
        version = [[UIDevice currentDevice] systemVersion];
    }
    return version;
}

@end
