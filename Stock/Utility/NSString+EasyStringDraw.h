//
//  NSString+EasyStringDraw.h
//  AppIphone
//
//  Created by 史瑞昌 on 2016/10/12.
//  Copyright © 2016年 史瑞昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (EasyStringDraw)
- (CGSize)easy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
