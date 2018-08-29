//
//  ChartWithBargainModel.h
//  Stock
//  这里是五档类，交易的
//  Created by 史瑞昌 on 2018/8/3.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "ChartModel.h"


//内部类，两个
@interface AskModel:BaseObject

@property(nonatomic,assign) long volume;
@property(nonatomic,assign) double price;

@end



@interface ChartWithBargainModel : ChartModel

@property(nonatomic,assign) double preClose;
@property(nonatomic,copy) NSArray<__kindof AskModel *> *ask;//要价
@property(nonatomic,copy) NSArray<__kindof AskModel *> *bid;//出价
@end
