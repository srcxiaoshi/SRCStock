//
//  ChartView.h
//  Stock
//
//  Created by 史瑞昌 on 2018/8/5.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "ChartWithKLineModel.h"



@interface ChartView : UIView

/** 数据源数组 **/
@property (nonatomic, strong) ChartWithKLineModel *data;

/** 背景颜色 **/
@property (nonatomic, strong) UIColor *bgColor;

/** 背景线的颜色 **/
@property (nonatomic, strong) UIColor *bgLineColor;

//获取数据以后重绘边框线、背景线、蜡烛、均线、label时间、价格label
-(void)update;

@end
