//
//  CKHGetInterface.m
//  O2OWebServiceTest
//
//  Created by cenkh on 14-9-27.
//  Copyright (c) 2014年 cenkh. All rights reserved.
//

#import "WebServiceGetInterface.h"
#import "KVNProgress.h"

@interface WebServiceGetInterface ()

@end

@implementation WebServiceGetInterface

/**
 *  返回类对象的单例方法
 *
 *  @return WebServiceGetInterface对象
 */
+ (WebServiceGetInterface *)instance
{
    static WebServiceGetInterface *sharedInstance = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[WebServiceGetInterface alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark -
#pragma mark - Public Methods

/**
 *  获取webService 数据:使用GET方法
 *
 *  @param act  接口中的act参数
 *  @param op   接口中的op参数
 *  @param pars 接口中的除了act、op参数之外的参数，以字典的形式存储，字典的key 作为参数名使用，字典的object作为参数使用
 */
- (void)dataForServiceWithAction:(NSString *)act operation:(NSString *)op par:(NSDictionary *)pars
{
    //接口根地址
    NSString *strHost = kWebServicesHostAddress;
    //根地址+地址默认参数act,op
    NSString *strInterface = [NSString stringWithFormat:@"%@?act=%@&op=%@",strHost,act,op];
    //调用接口参数
    NSString *strPars = @"";
    
    for (NSString *key in [pars allKeys])
    {
        NSString *keyValue = [pars objectForKey:key];
        
        strPars = [strPars stringByAppendingFormat:@"&%@=%@",key,keyValue];
    }
    
    //构造接口地址
    NSString *strURL = [NSString stringWithFormat:@"%@%@",strInterface,strPars];
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    //初始化网络请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:kWebServicesRequestTimeOut];
    
    [KVNProgress showWithStatus:@"Loading..."];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (connectionError == nil)
        {
            //读取数据
            if (data)
            {
                NSError *error = nil;
                
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil && dataDic)
                {
                    if ([self.delegate respondsToSelector:@selector(returnDataFromWebService:)])
                    {
                        [self.delegate returnDataFromWebService:dataDic];
                    }
                    
                    [KVNProgress show];
                }
                else
                {
                    [KVNProgress dismiss];
                }
            }
        }
        else
        {
            [KVNProgress dismiss];
        }
        
    }];
}

/**
 *  获取webService 数据:可指定请求方法POST/GET
 *
 *  @param method 请求方法
 *  @param act    接口中的act参数
 *  @param op     接口中的op参数
 *  @param pars   接口中除了act、op参数之外的参数，以字典的形式存储，字典的key 作为参数名使用，字典的object 作为参数值使用
 */
-(void)dataForserviceWithHTTPMethod:(NSString *)method action:(NSString *)act operation:(NSString *)op par:(NSDictionary *)pars
{
    NSString *strHost = kWebServicesHostAddress;
    NSString *strInterface = [NSString stringWithFormat:@"%@?act=%@&op=%@",strHost,act,op];
    NSString *strPars = @"";
    NSURL *url = nil;
    
    if ([method isEqualToString:@"GET"])
    {
        for (NSString *key in [pars allKeys])
        {
            NSString *parValue = [pars objectForKey:key];
            strPars = [strPars stringByAppendingFormat:@"&%@=%@",key,parValue];
        }
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",strInterface,strPars];
        
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        url = [NSURL URLWithString:strURL];
    }
    else
    {
        url = [NSURL URLWithString:strInterface];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:method];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:kWebServicesRequestTimeOut];
    
    if ([method isEqualToString:@"POST"])
    {
        //post 方法配置请求参数
        NSString *httpBody = @"";
        
        for (NSString *key in [pars allKeys])
        {
            if ([[pars allKeys] indexOfObject:key] == 0)
            {
                //第一个参数没有&
                NSString *firstValue = [pars objectForKey:key];
                httpBody = [httpBody stringByAppendingFormat:@"%@=%@",key,firstValue];
            }
            else
            {
                NSString *value = [pars objectForKey:key];
                httpBody = [httpBody stringByAppendingFormat:@"&%@=%@",key,value];
            }
        }
        
        httpBody = [httpBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [KVNProgress show];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //读取数据
            if (data)
            {
                NSError *error = nil;
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                if (error == nil && dataDic)
                {
                    if ([self.delegate respondsToSelector:@selector(returnDataFromWebService:)])
                    {
                        [self.delegate returnDataFromWebService:dataDic];
                    }
                }
            }
            
            [KVNProgress dismiss];
        }
        else
        {
            [KVNProgress dismiss];
        }
        
    }];
}

/**
 *  此接口与上面的第二个接口相同，只是提供了数据返回时可判断性，第二个接口如果有多几个接口在一个类里调用时，返回的数据无法判断是那个接口的
 * （根据op参数来判断是那个接口），因此补充.
 *  此方法的代理协议是
 *  returnDataFromWebService:(NSDictionary *)dataDic operation:(NSString *)op
 *
 *  @param method HTTP方法：POST/GET
 *  @param act    接口中的act参数
 *  @param op     接口中的op参数
 *  @param pars   接口中除了act、op参数之外的参数，以字典的形式存储，字典的key作为参数名使用，字典的value 作为参数值使用
 */
-(void)dataForserviceCanConcomitantWithHTTPMethod:(NSString *)method action:(NSString *)act operation:(NSString *)op pars:(NSDictionary *)pars
{
    NSString *strHost = kWebServicesHostAddress;
    NSString *strInterface = [NSString stringWithFormat:@"%@?act=%@&op=%@",strHost,act,op];
    NSString *strPars = @"";
    NSURL *url = nil;
    
    if ([method isEqualToString:@"GET"])
    {
        for (NSString *key in [pars allKeys])
        {
            NSString *parValue = [pars objectForKey:key];
            
            strPars = [strPars stringByAppendingFormat:@"&%@=%@",key,parValue];
        }
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",strInterface,strPars];
        
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        url = [NSURL URLWithString:strURL];
    }
    else
    {
        url = [NSURL URLWithString:strInterface];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:method];
    [request setTimeoutInterval:kWebServicesRequestTimeOut];
    
    if ([method isEqualToString:@"POST"])
    {
        //post 方法配置请求参数
        NSString *httpBody = @"";
        for (NSString *key in [pars allKeys])
        {
            if ([[pars allKeys]indexOfObject:key] == 0)
            {
                //第一个参数没有&
                NSString *firstValue = [pars objectForKey:key];
                httpBody = [httpBody stringByAppendingFormat:@"%@=%@",key,firstValue];
            }
            else
            {
                NSString *value = [pars objectForKey:key];
                httpBody = [httpBody stringByAppendingFormat:@"&%@=%@",key,value];
            }
        }
        
        httpBody = [httpBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [KVNProgress show];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //读取数据
            if (data)
            {
                NSError *error = nil;
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil && dataDic)
                {
                    if ([self.delegate respondsToSelector:@selector(returnDataFromWebService:operation:)])
                    {
                        [self.delegate returnDataFromWebService:dataDic operation:op];
                    }
                }
                
                [KVNProgress dismiss];
            }
        }
        else
        {
            [KVNProgress dismiss];
        }
        
    }];
}

/**
 *  此接口与上面的第二个接口相同，只是提供了数据返回时可判断性，第二个接口如果有多几个接口在一个类里调用时，返回的数据无法判断是那个接口的
 * （根据用户第一个参数来判断是那个接口），因此补充.
 *  此方法的代理协议是
 *  returnDataFromWebService:(NSDictionary *)dataDic identifier:(NSString *)identifier
 *
 *  @param method HTTP方法：POST/GET
 *  @param act    接口中的act参数
 *  @param op     接口中的op参数
 *  @param pars   接口中除了act、op参数之外的参数，以字典的形式存储，字典的key作为参数名使用，字典的value 作为参数值使用
 */
-(void)dataForServiceApartWithFirstParValueWithHTTPMethod:(NSString *)method action:(NSString *)act opertion:(NSString *)op pars:(NSDictionary *)pars
{
    NSString *strHost = kWebServicesHostAddress;
    NSString *strInterface = [NSString stringWithFormat:@"%@?act=%@&op=%@",strHost,act,op];
    NSString *strPars = @"";
    NSURL *url = nil;
    
    if ([method isEqualToString:@"GET"])
    {
        for (NSString *key in [pars allKeys])
        {
            NSString *parValue = [pars objectForKey:key];
            
            strPars = [strPars stringByAppendingFormat:@"&%@=%@",key,parValue];
        }
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",strInterface,strPars];
        
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        url = [NSURL URLWithString:strURL];
    }
    else
    {
        url = [NSURL URLWithString:strInterface];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:method];
    [request setTimeoutInterval:kWebServicesRequestTimeOut];
    
    if ([method isEqualToString:@"POST"])
    {
        //post 方法配置请求参数
        NSString *httpBody = @"";
        for (NSString *key in [pars allKeys])
        {
            if ([[pars allKeys]indexOfObject:key] == 0)
            {
                //第一个参数没有&
                NSString *firstValue = [pars objectForKey:key];
                
                httpBody = [httpBody stringByAppendingFormat:@"%@=%@",key,firstValue];
            }
            else
            {
                NSString *value = [pars objectForKey:key];
                
                httpBody = [httpBody stringByAppendingFormat:@"&%@=%@",key,value];
            }
        }
        
        httpBody = [httpBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [KVNProgress show];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //读取数据
            if (data)
            {
                NSError *error = nil;
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

                if (error == nil && dataDic)
                {
                    if ([self.delegate respondsToSelector:@selector(returnDataFromWebService:indentifier:)])
                    {
                        [self.delegate returnDataFromWebService:dataDic indentifier:[pars objectForKey:[[[pars allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                            
                            NSComparisonResult result = [obj1 compare:obj2];
                            
                            return result == NSOrderedDescending;
                        }] firstObject]]];
                    }
                }
            }
            
            [KVNProgress dismiss];
        }
        else
        {
            [KVNProgress dismiss];
        }
    }];
}

@end
