//
//  MainViewController.m
//  Stock
//
//  Created by 史瑞昌 on 2018/8/14.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "MainViewController.h"

//公共
#import "SrcNetWorkingWithAF.h"
#import "ChartView.h"
#import "Utility.h"

//model
#import "ChartWithKLineModel.h"
#import "ChartWithBargainModel.h"
#import "ChartWithRealTimeModel.h"
#import <SRCFoundation/SRCFoundation.h>

@interface MainViewController ()

@property(nonatomic,strong)ChartView *chartview;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title=@"测试标题";
    self.chartview=[[ChartView alloc]initWithFrame:CGRectMake(0, NavHeight, VIEW_WIDTH, VIEW_HEIGHT/2)];
    [self.view addSubview:self.chartview];
    [self loadData];

    
    //这里测试foundation
    NSMutableString *str=[NSMutableString stringWithFormat:@"00"];
    
    NSLog(@"nsarr = %@",str);
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
    __weak typeof(self) weakSelf=self;
    [network sessionRequestGetMethodHeader:@"/astock/chart/candle/600570" port:nil parameters:[dict copy] result:^(NSString *str, NSInteger errcode, NSString *msg) {
        __strong typeof(weakSelf) strongSelf=weakSelf;
        NSError* err = nil;
        ChartWithKLineModel *chart=[[ChartWithKLineModel alloc] initWithString:str error:&err];
        if(!err)
        {
            strongSelf.chartview.data=chart;
            [strongSelf.chartview update];
        }
        //NSLog(@"%@\n",chart);
        
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
