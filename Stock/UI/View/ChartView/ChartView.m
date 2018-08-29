//
//  ChartView.m
//  Stock
//  使用CAShapeLayer和UIBezierPath来绘制，性能比较好
//  Created by 史瑞昌 on 2018/8/5.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//




#import "ChartView.h"
#import "ChartWithKLineModel.h"
#import "UIColor+UIColorExt.h"
#import "ChartWithKLineModel.h"



#define RoseColor  [UIColor colorWithHexString:@"f05b72"]
#define DropColor  [UIColor colorWithHexString:@"7fb80e"]

#define DEFAULT_COUNT  60
#define DEFAULT_WIDTH  3
#define MAX_PRICE  -1
#define MIN_PRICE  2000
#define PRICE_TEXT_HEIGHT 15
#define PRICE_TEXT_WIDTH 45

@interface ChartView()

//最大和最小价钱
@property(nonatomic,assign)double min_price;
@property(nonatomic,assign)double max_price;
//默认显示的宽度
@property(nonatomic,assign)double defaultWidth;


//绘制开始和结束的索引，在items中
@property(nonatomic,assign)int startIndex;
@property(nonatomic,assign)int endIndex;

//红色，空心
@property(nonatomic,strong) CAShapeLayer* redLayer;
//绿色，实心
@property(nonatomic,strong) CAShapeLayer* greenLayer;
//背景线，包括实线和虚线
@property(nonatomic,strong) CAShapeLayer* bgLineLayer;



//两个path
@property(nonatomic,assign) CGMutablePathRef redPath;
@property(nonatomic,assign) CGMutablePathRef greenPath;

@end




@implementation ChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //这里初始化cashapelayer
        [self initLayers];
        //添加手势事件
        [self initGestureRecongnizer];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //在这里初始化cashapelayer
        [self initLayers];
        //添加手势事件
        [self initGestureRecongnizer];
        
    }
    return self;
}


#pragma initCAShapeLayers
- (void)initLayers
{
    if(!_redLayer)
    {
        _redLayer=[[CAShapeLayer alloc]init];
        _redLayer.lineWidth = (1 / [UIScreen mainScreen].scale) *1.5f;
        _redLayer.fillColor = RoseColor.CGColor;//空心 这里没有写的话，默认是黑色
        _redLayer.strokeColor = RoseColor.CGColor;
        [self.layer addSublayer:_redLayer];
    }
    if(!_greenLayer)
    {
        _greenLayer=[[CAShapeLayer alloc]init];
        _greenLayer.lineWidth = (1 / [UIScreen mainScreen].scale) *1.5f;
        _greenLayer.fillColor = DropColor.CGColor;//实心
        _greenLayer.strokeColor = DropColor.CGColor;
        [self.layer addSublayer:_greenLayer];
    }
    if(!_bgLineLayer)
    {
        _bgLineLayer=[CAShapeLayer new];
        _bgLineLayer.lineWidth=0.5f;//暂时写死了
        _bgLineLayer.strokeColor = [self bgLineColor].CGColor;
        _bgLineLayer.fillColor = [[UIColor clearColor] CGColor];
        _bgLineLayer.lineDashPattern = @[@1, @2];//画虚线;两个参数是：线宽，线间距
        [self.layer addSublayer:_bgLineLayer];
    }

}

#pragma initGestureRecongnizer
-(void)initGestureRecongnizer
{
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];

    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:longPress];
}

#pragma GestureRecognizer 处理手势事件
//轻拍
-(void)tapGestureRecognizerAction:(UITapGestureRecognizer *)sender
{
    //CGPoint point = [sender locationInView:self];
    //NSLog(@"%f,%f",point.x,point.y);
}

//长按
-(void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender
{
    
}

-(void)initDataIndex
{
    //从后先前显示，根据时间顺序 默认显示100个 拿到是按照时间从过去到现在排序的，所以需要倒叙来绘制
    if(self.data&&self.data.items.count>=DEFAULT_COUNT)
    {
        self.startIndex=(int)self.data.items.count-DEFAULT_COUNT;
        self.endIndex=(int)self.data.items.count;
    }

    self.min_price=MIN_PRICE;//这里是一个足够大的值
    self.max_price=MAX_PRICE;//一个足够小的值
    self.defaultWidth=DEFAULT_WIDTH;
    
}

#pragma calculte 计算最值
-(void)calculteMinAndMaxPrice
{
    //在之前判断过了数据的nil这里再次判断了
    if(self.data&&self.data.items&&self.data.items.count>0)
    {
        [self initDataIndex];
        int count=(int)self.data.items.count;
        if(self.endIndex>=count)
        {
            self.endIndex=count;
        }
        if(self.startIndex<=0)
        {
            self.startIndex=0;
        }
        for(int i=self.startIndex;i<self.endIndex;i++)
        {
            KLineModel *k=[self.data.items objectAtIndex:i];
            double low=[[k valueForKey:@"low"] doubleValue];
            double high=[[k valueForKey:@"high"] doubleValue];
            if(low<self.min_price)
            {
                self.min_price=low;
            }
            if(high>self.max_price)
            {
                self.max_price=high;
            }
        }
        self.min_price=self.min_price*0.9;
        self.max_price=self.max_price*1.1;
    }
}



#pragma draw
-(void)update
{
    if(self.data&&self.data.items&&self.data.items.count>0)
    {
        [self calculteMinAndMaxPrice];//计算最大值和最小值，更新最大和最小值
        [self drawBgLines];//绘制背景线
        [self drawPriceTextDash];//绘制三个虚线的价格文字
        [self drawTimeText];//绘制左下和右下的日期
        [self drawCandles];//绘制🕯
    }
    else
    {
        [self drawBgLines];//绘制背景线
    }
    [self.layer setNeedsDisplay];//重绘layer
}

-(void)drawTimeText
{
    if(self.data&&self.data.items&&self.data.items.count>0)
    {
        KLineModel *kStart=[self.data.items objectAtIndex:self.startIndex];
        KLineModel *kEnd=[self.data.items objectAtIndex:self.endIndex-1];
        
        NSDate *dateStart=[NSDate dateWithTimeIntervalSince1970:[[kStart valueForKey:@"time"] longLongValue]/1000];
        NSDate *dateEnd=[NSDate dateWithTimeIntervalSince1970:[[kEnd valueForKey:@"time"] longLongValue]/1000];
    
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        //NSDate转NSString
        NSString *startString = [dateFormatter stringFromDate:dateStart];
        NSString *endString = [dateFormatter stringFromDate:dateEnd];
        
        CATextLayer *startTimeLayer=[CATextLayer new];
        startTimeLayer.fontSize = 10.0f;
        startTimeLayer.alignmentMode = kCAAlignmentCenter;
        startTimeLayer.foregroundColor =[UIColor grayColor].CGColor;
        //处理数据和位置
        startTimeLayer.string=[NSString stringWithFormat:@"%@",startString];
        startTimeLayer.frame=CGRectMake(0,self.bounds.size.height+self.bounds.origin.y,PRICE_TEXT_WIDTH+10, PRICE_TEXT_HEIGHT);
        [self.layer addSublayer:startTimeLayer];
        
        CATextLayer *endTimeLayer=[CATextLayer new];
        endTimeLayer.fontSize = 10.0f;
        endTimeLayer.alignmentMode = kCAAlignmentCenter;
        endTimeLayer.foregroundColor =[UIColor grayColor].CGColor;
        //处理数据和位置
        endTimeLayer.string=[NSString stringWithFormat:@"%@",endString];
        endTimeLayer.frame=CGRectMake(self.bounds.size.width-10-PRICE_TEXT_WIDTH,self.bounds.size.height+self.bounds.origin.y,PRICE_TEXT_WIDTH+10, PRICE_TEXT_HEIGHT);
        [self.layer addSublayer:endTimeLayer];
        
    }
}

-(void)drawPriceTextDash
{
    if(self.data&&self.data.items&&self.data.items.count>0)
    {
        if(self.max_price!=MAX_PRICE&&self.min_price!=MIN_PRICE)
        {
            float y=self.bounds.size.height/4;
            double price=(self.max_price-self.min_price)/5;
            //计算三个价格
            for(int i=0;i<3;i++)
            {
                double price1=self.min_price+price*(i+1);
                CATextLayer *layer=[CATextLayer new];
                layer.fontSize = 12.0f;
                layer.alignmentMode = kCAAlignmentCenter;
                layer.foregroundColor =[UIColor grayColor].CGColor;
                //处理数据和位置
                layer.string=[NSString stringWithFormat:@"%.2f",price1];
                layer.frame=CGRectMake(0,5+y*i+y,PRICE_TEXT_WIDTH, PRICE_TEXT_HEIGHT);
                
                [self.layer addSublayer:layer];
            }
            
        }
    }
}

//两个横着的实线，三个横着的虚线，两个竖着的实线
-(void)drawBgLines
{
    self.backgroundColor=[self bgColor];
    
    //绘制实线
    CAShapeLayer *lineLayer=[CAShapeLayer new];
    lineLayer.lineWidth=0.5f;//绘制边框
    lineLayer.strokeColor = [self bgLineColor].CGColor;
    lineLayer.fillColor = [[UIColor clearColor] CGColor];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(5, self.bounds.origin.y+5)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width-5, 5)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width-5, self.bounds.size.height-5)];
    [path addLineToPoint:CGPointMake(5, self.bounds.size.height-5)];
    [path addLineToPoint:CGPointMake(5, 5)];
    lineLayer.path=path.CGPath;
    [self.layer addSublayer:lineLayer];
    
    //这里来绘制虚线Dash
    if(self.bgLineLayer)
    {
        UIBezierPath *path = [UIBezierPath bezierPath];
        float y=self.bounds.size.height/4;
        for(int i=0;i<3;i++)
        {
            [path moveToPoint:CGPointMake(5, 5+y*i+y)];
            [path addLineToPoint:CGPointMake(self.bounds.size.width-5, 5+y*i+y)];
        }
        self.bgLineLayer.path=path.CGPath;
    }
}

-(void)drawCandles
{
    if(self.data&&self.data.items&&self.data.items.count>0)
    {
        int count=self.endIndex-self.startIndex;
        
        //x空隙
        double x_edge=(self.bounds.size.width-10-self.defaultWidth*count)/(count+1);
        //价格比例
        double price_scale=self.bounds.size.height/(self.max_price-self.min_price);
        
        
        
        for(int i=self.startIndex;i<self.endIndex;i++)
        {
            KLineModel *k=[self.data.items objectAtIndex:i];
            //根据最大和最小价，还有k线宽， bounds来计算出每个k的坐标
            double high=[[k valueForKey:@"high"] doubleValue];
            double close=[[k valueForKey:@"close"] doubleValue];
            double open=[[k valueForKey:@"open"] doubleValue];
            double low=[[k valueForKey:@"low"] doubleValue];
            //使用high和low计算 两个point
            int num=i-self.startIndex;
            CGPoint highPoint=CGPointMake(5+x_edge+num*x_edge+num*self.defaultWidth+self.defaultWidth/2, price_scale*(self.max_price-high)+self.bounds.origin.y+5);
            CGPoint lowPoint=CGPointMake(5+x_edge+num*x_edge+num*self.defaultWidth+self.defaultWidth/2, price_scale*(self.max_price-low)+self.bounds.origin.y+5);
            CGPoint leftTopPoint;
            CGPoint rightTopPoint;
            CGPoint rightBottomPoint;
            CGPoint leftBottomPoint;
            
            if(open>=close)
            {
                //跌了
                leftTopPoint=CGPointMake(5+x_edge+num*x_edge+num*self.defaultWidth, price_scale*(self.max_price-open)+self.bounds.origin.y+5);
                rightTopPoint=CGPointMake(leftTopPoint.x+self.defaultWidth, leftTopPoint.y);
                rightBottomPoint=CGPointMake(leftTopPoint.x+self.defaultWidth, price_scale*(self.max_price-close)+self.bounds.origin.y+5);
                leftBottomPoint=CGPointMake(leftTopPoint.x, rightBottomPoint.y);
            
                [self drawCandleWithLayer:self.greenLayer Path:self.greenPath LeftTop:leftTopPoint RightTop:rightTopPoint RightBottom:rightBottomPoint LeftBottom:leftBottomPoint HighPoint:highPoint LowPoint:lowPoint];
            
            }
            else
            {
                //涨了
                
                leftTopPoint=CGPointMake(5+x_edge+num*x_edge+num*self.defaultWidth, price_scale*(self.max_price-close)+self.bounds.origin.y+5);
                rightTopPoint=CGPointMake(leftTopPoint.x+self.defaultWidth, leftTopPoint.y);
                rightBottomPoint=CGPointMake(leftTopPoint.x+self.defaultWidth, price_scale*(self.max_price-open)+self.bounds.origin.y+5);
                leftBottomPoint=CGPointMake(leftTopPoint.x, rightBottomPoint.y);
                
                [self drawCandleWithLayer:self.redLayer Path:self.redPath LeftTop:leftTopPoint RightTop:rightTopPoint RightBottom:rightBottomPoint LeftBottom:leftBottomPoint HighPoint:highPoint LowPoint:lowPoint];
            }
            
        }
        self.redLayer.path=self.redPath;
        self.greenLayer.path=self.greenPath;
        
        //释放
        CGPathRelease(self.redPath);
        CGPathRelease(self.greenPath);
    }
}

//构造path,进行绘制
-(void)drawCandleWithLayer:(CAShapeLayer *)layer Path:(CGMutablePathRef )path LeftTop:(CGPoint) lefttop RightTop:(CGPoint) righttop RightBottom:(CGPoint)rightbottom LeftBottom:(CGPoint)leftbottom HighPoint:(CGPoint) high LowPoint:(CGPoint)low
{
    //矩形
    CGPathMoveToPoint(path, NULL, lefttop.x, lefttop.y);
    CGPathAddLineToPoint(path,NULL,righttop.x,righttop.y);
    CGPathAddLineToPoint(path,NULL,rightbottom.x,rightbottom.y);
    CGPathAddLineToPoint(path,NULL,leftbottom.x,leftbottom.y);
    CGPathAddLineToPoint(path,NULL,lefttop.x,lefttop.y);
    //线
    CGPathMoveToPoint(path, NULL, high.x, high.y);
    CGPathAddLineToPoint(path,NULL,low.x,low.y);
}


#pragma set/get
- (CGMutablePathRef)redPath
{
    if(!_redPath)
    {
        _redPath=CGPathCreateMutable();
    }
    return _redPath;
}

- (CGMutablePathRef)greenPath
{
    if(!_greenPath)
    {
        _greenPath=CGPathCreateMutable();
    }
    return _greenPath;
}

-(UIColor *)bgColor
{
    if(!_bgColor)
    {
        //初始值为白色
        _bgColor=[UIColor whiteColor];
    }
    return _bgColor;
}

-(UIColor *)bgLineColor
{
    if(!_bgLineColor)
    {
        //初始化成灰色
        _bgLineColor=[UIColor blackColor];
    }
    return _bgLineColor;
}

@end
