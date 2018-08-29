//
//  KLineModel.h
//  Stock
//
//  Created by 史瑞昌 on 2018/8/3.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "BaseObject.h"

@interface KLineModel : BaseObject

@property(nonatomic,assign) long volume; //量
@property(nonatomic,assign) double high;//价格
@property(nonatomic,assign) double low;//均价线
@property(nonatomic,assign) long time;//时间
@property(nonatomic,assign) double open;//开盘 价钱
@property(nonatomic,assign) double close;//闭盘 价钱

@end
