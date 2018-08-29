//
//  ChartWithKLineModel.h
//  Stock
//
//  Created by 史瑞昌 on 2018/8/3.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "ChartModel.h"
#import "KLineModel.h"


@interface ChartWithKLineModel : ChartModel

@property(nonatomic,strong) NSString* symbol;
@property(nonatomic,strong) NSString* period;
@property(nonatomic,copy) NSArray<KLineModel *> *items;
//__kindof 使用可以在数组中加BaseObject的子类，不加__kindof的话，就严格限定BaseObject，子类编译器会报叹号

@end
