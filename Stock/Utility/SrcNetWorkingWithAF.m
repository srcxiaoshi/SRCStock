//
//  SrcNetWorkingWithAF.m
//  网络连接封装类，借助第三方库AFNetworking
//
//  Created by 史瑞昌 on 2018/7/17.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "SrcNetWorkingWithAF.h"
#import "AFNetworking.h"

//网络失败数组容量
#define CONNECT_FAIL_ARR_COUNT   3

//相对路径
#define BASE_URL1   @"https://hq1.itiger.com"
#define BASE_URL2   @"https://hq2.itiger.com"
#define AUTHENTICATION @"Bearer TjpCv9MTHFjW7Zi067JsnX0Sh6qV7N"
#define Encoding NSUTF8StringEncoding

@interface SrcNetWorkingWithAF()

@property (strong,nonatomic) NSMutableArray *connectFailArr;
@property (strong,nonatomic) AFHTTPSessionManager *manager;


@end

static SrcNetWorkingWithAF *instance = nil;//单例对象


@implementation SrcNetWorkingWithAF

+(instancetype)getNetWorkingUtil
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(instance == nil)
        {
            instance = [[self alloc] init];
            instance.connectFailArr = [[NSMutableArray alloc]initWithCapacity:CONNECT_FAIL_ARR_COUNT];
            [instance chectReachAbility];
            instance.manager=[[AFHTTPSessionManager alloc]initWithBaseURL:[[NSURL alloc] initWithString:BASE_URL1]];
            [instance.manager.requestSerializer setValue:@"hq1.itiger.com" forHTTPHeaderField:@"Host"];
            [instance.manager.requestSerializer setValue:@"v2" forHTTPHeaderField:@"X-API-Version"];
            [instance.manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
            [instance.manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
            [instance.manager.requestSerializer setValue:@"XAUGVl9TGwYCXVFaBAk=" forHTTPHeaderField:@"X-NewRelic-ID"];
            [instance.manager.requestSerializer setValue:@"Stock/6.3.4 (iPhone; iOS 11.4.1; Scale/3.00)" forHTTPHeaderField:@"User-Agent"];
            [instance.manager.requestSerializer setValue:@"zh-Hans-CN;q=1, en-CN;q=0.9" forHTTPHeaderField:@"Accept-Language"];
            [instance.manager.requestSerializer setValue:AUTHENTICATION forHTTPHeaderField:@"Authorization"];
            [instance.manager.requestSerializer setValue:@"br, gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
            [instance.manager.requestSerializer setValue:@"JSESSIONID=DE1EB986168F1DEB9CEEF192061F3DE5; ngxid=fPoiPltiu8ELJylHBB5mAg==" forHTTPHeaderField:@"Cookie"];
            
            
            
            //这里允许不进行证书验证, 来规避 evaluateServerTrust: forDomain:方法的验证不通过的问题。 code=-999
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
            securityPolicy.validatesDomainName = NO;
            securityPolicy.allowInvalidCertificates = YES;
            instance.manager.securityPolicy = securityPolicy;
            
            //这里设置返回的是data类型
            instance.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            //这里设置返回的是xml responseObject的类型是NSXMLParser
            //instance.manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            //responseObject的类型是NSDictionary或者NSArray
            //instance.manager.responseSerializer = [AFJSONResponseSerializer serializer];
            
        }
    });
    return instance;
}

#pragma mark 语法逻辑
/**覆盖该方法主要确保当用户通过[[SrcNetWorkingWithAF alloc] init]创建对象时对象的唯一性，alloc方法会调用该方法，只不过zone参数默认为nil，因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone:zone]
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            instance.connectFailArr = [[NSMutableArray alloc]initWithCapacity:CONNECT_FAIL_ARR_COUNT];
            [instance chectReachAbility];
        }
    });
    return instance;
}

//自定义初始化方法，本例中只有name这一属性
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.connectFailArr = [[NSMutableArray alloc]initWithCapacity:CONNECT_FAIL_ARR_COUNT];
        [self chectReachAbility];
    }
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
- (instancetype)copy
{
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
- (instancetype)mutableCopy
{
    return self;
}

//自定义描述信息，用于log详细打印
- (NSString *)description
{
    return [super description];
}


#pragma mark 业务逻辑
-(void)chectReachAbility
{
    /**
     AFNetworkReachabilityStatusUnknown = -1, // 未知
     AFNetworkReachabilityStatusNotReachable = 0, // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1, // 4G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2, // 局域网络,不花钱
     */
    
    __weak typeof(self) _weakSelf = self;
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        _weakSelf.reachAbility = status;
        
    }];
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

//session作为请求头的post请求(有网络请求错误提示)
-(void)sessionRequestPostMethodHeader:(NSString *)header port:(NSString* )port parameters:(NSDictionary *)parameters result:(void (^)(NSString *str,NSInteger errcode,NSString *msg)) result
{
    NSString * str=BASE_URL1;
    if(port)
    {
        str=[NSString stringWithFormat:@"%@:%@",str,port];//8080
    }
    if(header)
    {
        str=[NSString stringWithFormat:@"%@%@",str,header];//head="/zz" 所以header至少是“/”
    }
    NSURLSessionDataTask *task=[self.manager POST:str parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"%@\n请求成功:%@",str,responseObject);//这里responseObject是dic类型的
        if(result)
        {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:Encoding];
            result(string,200,@"请求成功");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //NSLog(@"%@\n请求失败:%@",str,error);
        if(result)
        {
            result(@"",error.code,@"请求失败");
        }
        
    }];
    [task resume];//重新提交
}

//session作为请求头的GET请求
-(void)sessionRequestGetMethodHeader:(NSString* )header port:(NSString* )port parameters:(NSDictionary *)parameters result:(void (^)(NSString *str,NSInteger errcode,NSString *msg)) result
{
    NSString * str=BASE_URL1;
    if(port)
    {
        str=[NSString stringWithFormat:@"%@:%@",str,port];//8080
    }
    if(header)
    {
        str=[NSString stringWithFormat:@"%@%@",str,header];//head="/zz" 所以header至少是“/”
    }
    

    NSURLSessionDataTask *task=[self.manager GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //NSLog(@"Progress:%@\n",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"%@\n请求成功:%@",str,responseObject);//这里responseObject是dic类型的
        if(result)
        {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:Encoding];
            result(string,200,@"请求成功");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //NSLog(@"%@\n请求失败:%@",str,error);
        if(result)
        {
            result(@"",error.code,@"请求失败");
        }
        
    }];
    [task resume];//重新提交
}















@end
