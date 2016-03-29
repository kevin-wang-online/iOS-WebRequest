# iOS-WebRequest

基于iOS原生网络请求NSURLConnection类进行的进一步的抽象，采用线程安全的单例设计模式，方便网络请求时调用。

使用方式：


//获取网络请求单例

+ (WebServiceGetInterface *)instance 


//获取webService 数据:使用GET方法

//@param act  接口中的act参数

//@param op   接口中的op参数

//@param pars 接口中的除了act、op参数之外的参数，以字典的形式存储，字典的key 作为参数名使用，字典的object作为参数使用

- (void)dataForServiceWithAction:(NSString *)act operation:(NSString *)op par:(NSDictionary *)pars;


//获取webService 数据:可指定请求方法POST/GET

//@param method 请求方法

//@param act    接口中的act参数

//@param op     接口中的op参数

//@param pars   接口中除了act、op参数之外的参数，以字典的形式存储，字典的key 作为参数名使用，字典的object 作为参数值使用

//-(void)dataForserviceWithHTTPMethod:(NSString *)method action:(NSString *)act operation:(NSString *)op par:(NSDictionary *)pars;


//此接口与上面的第二个接口相同，只是提供了数据返回时可判断性，第二个接口如果有多几个接口在一个类里调用时，返回的数据无法判断是那个接口的
 * （根据op参数来判断是那个接口），因此补充.
 *  此方法的代理协议是
 *  returnDataFromWebService:(NSDictionary *)dataDic operation:(NSString *)op
 *  
 
//@param method HTTP方法：POST/GET

//@param act    接口中的act参数

//@param op     接口中的op参数

//@param pars   接口中除了act、op参数之外的参数，以字典的形式存储，字典的key作为参数名使用，字典的value 作为参数值使用

-(void)dataForserviceCanConcomitantWithHTTPMethod:(NSString *)method action:(NSString *)act operation:(NSString *)op pars:(NSDictionary *)pars;


//此接口与上面的第二个接口相同，只是提供了数据返回时可判断性，第二个接口如果有多几个接口在一个类里调用时，返回的数据无法判断是那个接口的
 * （根据用户第一个参数来判断是那个接口），因此补充.
 *  此方法的代理协议是
 *  returnDataFromWebService:(NSDictionary *)dataDic identifier:(NSString *)identifier
 *  
 
//@param method HTTP方法：POST/GET

//@param act    接口中的act参数

//@param op     接口中的op参数

//@param pars   接口中除了act、op参数之外的参数，以字典的形式存储，字典的key作为参数名使用，字典的value 作为参数值使用

-(void)dataForServiceApartWithFirstParValueWithHTTPMethod:(NSString *)method action:(NSString *)act opertion:(NSString *)op pars:(NSDictionary *)pars;








