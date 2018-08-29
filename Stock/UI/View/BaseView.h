//
//  BaseView.h
//  Stock
//
//  Created by 史瑞昌 on 2018/8/3.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

@property (nonatomic,assign) CGFloat maxY;
@property (nonatomic,assign) CGFloat minY;
@property (nonatomic,assign) CGFloat maxX;
@property (nonatomic,assign) CGFloat minX;
@property (nonatomic,assign) CGFloat scaleY;
@property (nonatomic,assign) CGFloat scaleX;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,assign) CGFloat leftMargin;
@property (nonatomic,assign) CGFloat rightMargin;
@property (nonatomic,assign) CGFloat topMargin;
@property (nonatomic,assign) CGFloat bottomMargin;
@property (nonatomic,strong) UIColor *lineColor;

@end
