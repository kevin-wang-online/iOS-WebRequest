//
//  WebServiceGetInterface.h
//  ASIAWebServiceClass
//
//  Created by Kevin on 15-4-10.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDefinition.h"

@protocol WebServiceGetInterfaceDelegate <NSObject>

@optional

/**
 *  接口数据返回结果
 *
 *  @param dataDic 返回的接口数据，以字典形式存储，具体字典内是什么请移步接口文档或浏览器求真相
 */
-(void)returnDataFromWebService:(NSDictionary *)dataDic;

/**
 *  可判断的接口数据返回结果
 *
 *  @param dataDic 返回的接口数据
 *  @param op      接口的op参数，此参数用以判断得到的数据是那个接口返回的
 */
-(void)returnDataFromWebService:(NSDictionary *)dataDic
                      operation:(NSString *)op;

/**
 *  可判断的接口数据结果
 *
 *  @param dataDic     返回的接口数据
 *  @param indentifier 根据传值的其余参数的第一个参数判断
 */
-(void)returnDataFromWebService:(NSDictionary *)dataDic
                    indentifier:(NSString *)indentifier;


@end

@interface WebServiceGetInterface : NSObject


@property (strong, nonatomic)id<WebServiceGetInterfaceDelegate> delegate;


+(WebServiceGetInterface *)instance;

/**
 *  获取webService 数据:使用GET方法
 *
 *  @param act  接口中的act参数
 *  @param op   接口中的op参数
 *  @param pars 接口中的除了act、op参数之外的参数，以字典的形式存储，字典的key 作为参数名使用，字典的object作为参数使用
 */
-(void)dataForServiceWithAction:(NSString *)act
                      operation:(NSString *)op
                            par:(NSDictionary *)pars;

/**
 *  获取webService 数据:可指定请求方法POST/GET
 *
 *  @param method 请求方法
 *  @param act    接口中的act参数
 *  @param op     接口中的op参数
 *  @param pars   接口中除了act、op参数之外的参数，以字典的形式存储，字典的key 作为参数名使用，字典的object 作为参数值使用
 */
-(void)dataForserviceWithHTTPMethod:(NSString *)method
                             action:(NSString *)act
                          operation:(NSString *)op
                                par:(NSDictionary *)pars;

/**
 *  此接口与上面的第二个接口相同，只是提供了数据返回时可判断性，第二个接口如果有多几个接口在一个类里调用时，返回的数据无法判断是那个接口的
 * （根据op参数来判断是那个接口），因此补充.
 *  此方法的代理协议是returnDataFromWebService:(NSDictionary *)dataDic operation:(NSString *)op
 *
 *  @param method HTTP方法：POST/GET
 *  @param act    接口中的act参数
 *  @param op     接口中的op参数
 *  @param pars   接口中除了act、op参数之外的参数，以字典的形式存储，字典的key作为参数名使用，字典的value 作为参数值使用
 */
-(void)dataForserviceCanConcomitantWithHTTPMethod:(NSString *)method
                                           action:(NSString *)act
                                        operation:(NSString *)op
                                             pars:(NSDictionary *)pars;


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
-(void)dataForServiceApartWithFirstParValueWithHTTPMethod:(NSString *)method
                                                   action:(NSString *)act
                                                 opertion:(NSString *)op
                                                     pars:(NSDictionary *)pars;

@end



