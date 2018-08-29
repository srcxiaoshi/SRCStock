//
//  RootViewController.m
//  Stock
//
//  Created by 史瑞昌 on 2018/8/13.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor=[UIColor clearColor];
    
    MainViewController *mainvc=[[MainViewController alloc]init];
    
    [self pushViewController:mainvc animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
