//
//  NSString+EasyStringDraw.m
//  AppIphone
//
//  Created by 史瑞昌 on 2016/10/12.
//  Copyright © 2016年 史瑞昌. All rights reserved.
//

#import "NSString+EasyStringDraw.h"

@implementation NSString (EasyStringDraw)

- (CGSize)easy_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = lineBreakMode;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[paragraph copy] forKey:NSParagraphStyleAttributeName];
    [attributes setObject:font forKey:NSFontAttributeName];
    CGRect boundingRect = [self boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                          attributes:attributes
                                             context:nil];
    return boundingRect.size;
}

@end
