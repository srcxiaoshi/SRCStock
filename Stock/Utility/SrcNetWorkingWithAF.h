//
//  SrcNetWorkingWithAF.h
//  Stock
//
//  Created by 史瑞昌 on 2018/7/17.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface SrcNetWorkingWithAF : NSObject

@property (assign,nonatomic) AFNetworkReachabilityStatus reachAbility;

+(SrcNetWorkingWithAF *)getNetWorkingUtil;

//session作为请求头的post请求(有网络请求错误提示)
-(void)sessionRequestPostMethodHeader:(NSString *)header port:(NSString* )port parameters:(NSDictionary *)parameters result:(void (^)(NSString *str,NSInteger errcode,NSString *msg)) result;

//session作为请求头的GET请求
-(void)sessionRequestGetMethodHeader:(NSString* )header port:(NSString* )port parameters:(NSDictionary *)parameters result:(void (^)(NSString *str,NSInteger errcode,NSString *msg)) result;

@end
