//
//  NetWorking.m
//  ShuiTuBaoChi
//
//  Created by 史瑞昌 on 2016/12/22.
//  Copyright © 2016年 史瑞昌. All rights reserved.
//

#import "NetWorking.h"


@interface NetWorking()<NSURLConnectionDelegate>
{
    void(^SuccessBlock)(NSString *);
    void(^ErrorBlock)(NSString *);
}
@property (nonatomic, copy)void (^scuccessBlock)(NSString *);
@property (nonatomic, copy)void (^errorBlock)(NSString *);

@end

@implementation NetWorking
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.isUTF8=NO;
    }
    return self;
}
-(void)startRequest:(NSString *)urlStr SuccessBlock:(void (^)(NSString * success))success ErrorBlock:(void (^)(NSString * err))error
{
    self.scuccessBlock=success;
    self.errorBlock=error;
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    //创建请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //连接服务器
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

    [connection start];
}

#pragma delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    //收到相应header filed
    
    self.myResult=[[NSMutableData alloc]init];
    self.myResult = [NSMutableData data];
    self.returnStr=[[NSString alloc]init];
}

////接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.myResult appendData:data];
    
}

//数据传输完成之后执行方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    NSString *str;
//    if (self.isUTF8) {
        str=[[NSString alloc]initWithData:self.myResult encoding:NSUTF8StringEncoding];
    //}
//    else
//    {
//        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//         str= [[NSString alloc]initWithData:[self.myResult copy] encoding:enc];
//    }
    if(self.scuccessBlock)
    {
        self.scuccessBlock(str);
    }
//    if ([self.delegate respondsToSelector:@selector(successDelegate:)]) {
//        [self.delegate successDelegate:self.returnStr];
//    }
}

//网络请求时出现错误（断网，连接超时)执行方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

{
//    if ([self.delegate respondsToSelector:@selector(errDelegate:)]) {
//        [self.delegate errDelegate:self.returnStr];
//    }
    if (self.errorBlock) {
        self.errorBlock(@"请求出错了\n");
    }
    //NSLog(@"出错了=%@",[error localizedDescription]);
}

@end
