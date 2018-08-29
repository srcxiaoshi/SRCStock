//
//  ViewController.m
//  Stock
//
//  Created by 史瑞昌 on 2018/7/16.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//
//https://hq1.itiger.com/astock/chart/realtime/600570?device=iPhone10%2C3&deviceId=8d5d6679cb8978905ce693848768749a479f512d&appVer=6.3.3.0&vendor=AppStore&platform=iOS&channel=AppStore&lang=zh_CN&screenW=375&keyfrom=TigerBrokers.6.3.3.0.iPhone&screenH=812&osVer=11.4.1&beginTime=-1&period=day

//https://hq1.itiger.com/astock/chart/realtime/600570?appVer=6.3.3.0&beginTime=-1&channel=AppStore&device=iPhone10%252C3&deviceId=8d5d6679cb8978905ce693848768749a479f512d&keyfrom=TigerBrokers.6.3.3.0.iPhone&lang=zh_CN&osVer=11.4.1&period=day&platform=iOS&screenH=812&screenW=375&vendor=AppStore
//主要的接口，数据来源



#import "ViewController.h"

//公共
#import "SrcNetWorkingWithAF.h"
#import "ChartView.h"
#import "Utility.h"

//model
#import "ChartWithKLineModel.h"
#import "ChartWithBargainModel.h"
#import "ChartWithRealTimeModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ChartView * chartview=[[ChartView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [self.view addSubview:chartview];

}

-(void)loadData
{
    //这里测试网络
    SrcNetWorkingWithAF * network=[SrcNetWorkingWithAF getNetWorkingUtil];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSString *str=[NSString stringWithFormat:@"%@%%%@",@"iPhone10",@"2C3"];
    
    [dict setValue:str forKey:@"device"];
    [dict setValue:@"8d5d6679cb8978905ce693848768749a479f512d" forKey:@"deviceId"];
    [dict setValue:@"6.3.3.0" forKey:@"appVer"];
    [dict setValue:@"AppStore" forKey:@"vendor"];
    [dict setValue:@"iOS" forKey:@"platform"];
    [dict setValue:@"AppStore" forKey:@"channel"];
    [dict setValue:@"zh_CN" forKey:@"lang"];
    [dict setValue:@"375" forKey:@"screenW"];
    [dict setValue:@"TigerBrokers.6.3.3.0.iPhone" forKey:@"keyfrom"];
    [dict setValue:@"812" forKey:@"screenH"];
    [dict setValue:@"11.4.1" forKey:@"osVer"];
    [dict setValue:@"-1" forKey:@"beginTime"];
    [dict setValue:@"day" forKey:@"period"];
    [dict setValue:@"br" forKey:@"right"];
    
    //candle k线
    //realtime 分时
    //bargain 交易量
    [network sessionRequestGetMethodHeader:@"/astock/chart/candle/600570" port:nil parameters:[dict copy] result:^(NSString *str, NSInteger errcode, NSString *msg) {
        NSError* err = nil;
        
        ChartWithKLineModel *chart=[[ChartWithKLineModel alloc] initWithString:str error:&err];
        
        NSLog(@"%@\n",chart);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
