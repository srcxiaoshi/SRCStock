//
//  UIColor+UIColorExt.h
//  AppIphone
//
//  Created by 史瑞昌 on 2016/10/12.
//  Copyright © 2016年 史瑞昌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorExt)
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
