//
//  RealTimeDate.h
//  Stock
//
//  Created by 史瑞昌 on 2018/8/2.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "BaseObject.h"

@interface RealTimeModel : BaseObject

@property(nonatomic,assign) long volume; //量
@property(nonatomic,assign) double price;//价格
@property(nonatomic,assign) double avgPrice;//均价线
@property(nonatomic,assign) long time;//时间

@end
