//
//  NetWorking.h
//  ShuiTuBaoChi
//
//  Created by 史瑞昌 on 2016/12/22.
//  Copyright © 2016年 史瑞昌. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface NetWorking : NSObject

@property (strong,nonatomic) NSMutableData *myResult;
@property (strong,nonatomic) NSString *returnStr;
@property (nonatomic,assign)Boolean isUTF8;
-(void)startRequest:(NSString *)urlStr SuccessBlock:(void (^)(NSString * success))success ErrorBlock:(void (^)(NSString * err))error;


@end
