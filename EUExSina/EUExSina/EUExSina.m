//
//  EUExSina.m
//  EUExSina
//
//  Created by 陈晓明 on 15/9/9.
//  Copyright (c) 2015年 陈晓明. All rights reserved.
//

#import "WBHttpRequest+WeiboUser.h"

#import "EUExSina.h"
#import "EUtility.h"
#import "EUExBaseDefine.h"
#import "JSON.h"
#import "EBrowserView.h"

#define SHARE_TXT 0 //分享文字
#define SHARE_IMAGE 1 //分享图片
#define SHARE_MEDIA 2 //分享视频
#define SHARE_LINK 3 //分享链接

#define CB_REGISTER_APP @"uexSina.cbRegisterApp"
#define CB_login @"uexSina.cbLogin"
#define CB_SHARE @"uexSina.cbShare"
#define CB_USER_INFO @"uexSina.cbGetUserInfo"
#define CB_GENERATE_SHORT_URL @"uexSina.cbGenerateShortUrl"
#define DELAY_TIME 0.5 //调用js延时时间


#define oauth_expires_in @"expires_in"
#define oauth_uid @"uid"
#define oauth_access_token @"access_token"
#define oauth_remind_in @"remind_in"

#define HTTP_TYPE_POST @"POST" //网络请求类型
#define HTTP_TYPE_GET @"GET"

#define REQUEST_TYPE_USER_INFO 1 //返回请求的类型(根据类型判断返回的是什么信息)
#define REQUEST_TYPE_GENERATE 2

@implementation EUExSina{
    NSString *_shareTxtContent;//分享文字
    NSString *_shareImagePath;//分享图片路径
    NSString *_shareImageTxt;//分享图片文字
    
    NSString *_appKey;//应用键值
    NSString *_appSecret;//
    NSString *_registerUrl;//回调页地址
    
    BOOL _isShowDebugInfo;//调试信息输出
    
    NSString *_jsData;
    
    NSInteger _requestType;//请求的类型 1-用户信息 2-长链接转短链接
    
}

@synthesize wbtoken;
@synthesize wbCurrentUserID;//当前用户id



#pragma mark - 初始化
- (id)initWithBrwView:(EBrowserView *)eInBrwView{
    
    self=[super initWithBrwView:eInBrwView];
    if (self) {
        
        _isShowDebugInfo=false;
        _requestType=-1;
//        [WeiboSDK enableDebugMode:NO];//微博调试模式，打印微博sdk的调试信息
        
    }
    return self;
    
}



#pragma mark - 插件接口函数
#pragma mark 登陆接口

-(void)login:(NSMutableArray *)inArguments{
    
    if (inArguments.count!=3) {//如果没有传三个参数
        return;
    }

    
    //传进来的三个参数
    _appKey = [inArguments objectAtIndex:0];
    _appSecret = [inArguments objectAtIndex:1];
    _registerUrl = [inArguments objectAtIndex:2];
    
    //sso授权
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = _registerUrl;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
    
    
    NSLog(@"login rquest is over");
    
}

#pragma mark 注册接口

-(void)registerApp:(NSMutableArray *)inArguments{
    
    if (inArguments.count!=3) {//如果没有传三个参数
        return;
    }
    
    //传进来的三个参数
    _appKey = [inArguments objectAtIndex:0];
    _appSecret = [inArguments objectAtIndex:1];
    _registerUrl = [inArguments objectAtIndex:2];
    
    
    BOOL isRegisterSuccess=[WeiboSDK registerApp:_appKey];//注册应用后状态
    if (isRegisterSuccess) {
        [self jsSuccessWithName:CB_REGISTER_APP opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];
    }else{
        [self jsSuccessWithName:CB_REGISTER_APP opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFAILED];
    }
    
    NSLog(@"registerApp rquest is over");
    
}

#pragma mark 分享文字接口

-(void)sendTextContent:(NSMutableArray *)inArguments{
    
    if (inArguments.count!=1) {//如果没有传一个参数
        return;
    }
    
    NSMutableString *txtContent = [inArguments objectAtIndex:0];//分享文字内容
    
    if (![self isStringHasContent:txtContent]) {//判断字符串长度
        return;
    }
    NSRange range =[txtContent rangeOfString:@"http"];//如果发送的内容有链接地址
    if (range.location==0) {//如果链接前没有字符就加一个空格
        [txtContent insertString:@" " atIndex:0];
    }
    _shareTxtContent = txtContent;//保存共享文字
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];//请求个人信息
    authRequest.redirectURI = _registerUrl;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:SHARE_TXT] authInfo:authRequest access_token:wbtoken];//请求消息内容
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    NSLog(@"sendTextContent rquest is over");
    
}

#pragma mark 分享图片接口

-(void)sendImageContent:(NSMutableArray *)inArguments{
    
    if (inArguments.count!=2) {//如果没有传两个参数
        return;
    }
    
    _shareImagePath = [self absPath:[inArguments objectAtIndex:0]];//取得图片路径
    _shareImageTxt = [inArguments objectAtIndex:1];//取得图片文字
    
    if (![self isStringHasContent:_shareImagePath] || ![self isStringHasContent:_shareImageTxt] ) {//判断传进来字符串长度
        return;
    }
    
    if (![_shareImagePath hasPrefix:@"http"]) {//如果不是http开头
        
        _shareImagePath = [self absPath:[inArguments objectAtIndex:0]];//取得图片路径
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:_shareImagePath];//返回图片是否存在
        if (!fileExists) {
            [self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:@"图片不存在"];
            return;
        }
        
    }
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];//请求个人信息对象
    authRequest.redirectURI = _registerUrl;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:SHARE_IMAGE] authInfo:authRequest access_token:wbtoken];//请求内容对象
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    
    NSLog(@"sendImageContent rquest is over");
    
}

#pragma mark 得到用户信息

-(void)getUserInfo:(NSMutableArray *)inArguments{
    NSDictionary * argDic = [[inArguments objectAtIndex:0] JSONValue];//传入的参数字典
    //    NSLog(@"%@",[argDic objectForKey:@"uid"]);
    //    NSLog(@"%@",[argDic objectForKey:@"access_token"]);
    NSString *userUid = [argDic objectForKey:oauth_uid];
    NSString *userToken = [argDic objectForKey:oauth_access_token];
    if (userUid == nil || userUid.length < 1) {//判断传入参数
        return;
    }
    if (userToken == nil || userToken.length < 1) {//判断传入参数
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];//创建请求参数字典
    [dic setObject:userToken forKey:oauth_access_token];
    [dic setObject:userUid forKey:oauth_uid];
    NSString *path = @"https://api.weibo.com/2/users/show.json";
    
    [WBHttpRequest requestWithURL:path httpMethod:HTTP_TYPE_GET params:dic delegate:self withTag:nil];//发出用户请求
    _requestType = REQUEST_TYPE_USER_INFO;
}

#pragma mark 转换链接地址为短地址接口

-(void)generateShortUrl:(NSMutableArray *)inArguments{
    
    if (inArguments.count != 1) {
        return;
    }
    
    NSDictionary *dic = [[inArguments objectAtIndex:0] JSONValue];
    if (dic == nil || dic.count < 1) {
        return;
    }
    NSString *path = @"https://api.weibo.com/2/short_url/shorten.json";//api的地址
    NSString *_token = [dic objectForKey:oauth_access_token];//外部传入的token
    NSString *data = [dic objectForKey:@"url_longs"];//取得地址数组
    NSArray *arr = [[data JSONFragment]JSONValue];//解析参数传来的地址数组
    
    NSMutableString *address = [NSMutableString string];
    for (NSInteger i = 0; i < arr.count; i++) {
        [address appendFormat:@"&url_long=%@",arr[i]];//添加到字符串
    }
    
    NSString *urlContent = [NSString stringWithFormat:@"%@?access_token=%@%@",path,_token,address];//请求json字符串
    [WBHttpRequest requestWithURL:urlContent httpMethod:HTTP_TYPE_GET params:nil delegate:self withTag:nil];//请求链接转换
    
    _requestType = REQUEST_TYPE_GENERATE;
    
}

#pragma mark 注销接口

-(void)cleanUserInfo:(NSMutableArray *)inArguments{
    
    [WeiboSDK logOutWithToken:wbtoken delegate:self withTag:@"user1"];
    
    NSLog(@"cleanUserInfo rquest is over");
    
}

#pragma mark -
#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
    NSLog(@"request:return result is %@", result);
    
    [self showAlertWin:NSLocalizedString(@"收到网络回调", nil) content:[NSString stringWithFormat:@"%@",result] cancelButtonTitle:NSLocalizedString(@"确定", nil)];

    switch (_requestType) {
        case REQUEST_TYPE_USER_INFO:
        {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:result,@"keys", nil];//将结果字符串包装成一个对象
            [meBrwView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"uexSina.cbUserInfo(0,0,%@)",[dict JSONFragment]]];//请求用户信息（绕过转换字符串，直接调用浏览器的方法，避免因为浏览器对象检查字符出现非法字符）
        }
            break;
        case REQUEST_TYPE_GENERATE:
            [self jsSuccessWithName:CB_GENERATE_SHORT_URL opId:0 dataType:UEX_CALLBACK_DATATYPE_JSON strData:[result JSONFragment]];//请求长链接转短链接
            break;
            
        default:
            break;
    }
 
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    
    NSLog(@"request:err error is %@", error);
    
    [self showAlertWin:NSLocalizedString(@"请求异常", nil) content:[NSString stringWithFormat:@"%@",error] cancelButtonTitle:NSLocalizedString(@"确定", nil)];
    
    switch (_requestType) {
        case REQUEST_TYPE_USER_INFO:
            [self jsSuccessWithName:CB_USER_INFO opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFAILED];//请求用户信息
            break;
        case REQUEST_TYPE_GENERATE:
            [self jsSuccessWithName:CB_GENERATE_SHORT_URL opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFAILED];//请求长链接转短链接
            break;
            
        default:
            break;
    }
    
}

#pragma mark - WeiboSDKDelegate代理方法实现
/**
 收到一个来自微博客户端程序的请求
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

/**
 接受用户响应
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    NSLog(@"didReceiveWeiboResponse");
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {// sharetxt shareImage
        
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        [self showAlertWin:title content:message cancelButtonTitle:NSLocalizedString(@"确定", nil)];//显示警告窗口
        
        
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        
        
        WeiboSDKResponseStatusCode reCode = response.statusCode;//取得回调状态
        if (reCode == WeiboSDKResponseStatusCodeSuccess) {//回调成功
            
            [self performSelector:@selector(sb_share_success) withObject:self afterDelay:DELAY_TIME];
            
        }else{
            
            [self performSelector:@selector(sb_share_fail) withObject:self afterDelay:DELAY_TIME];
            
        }
        NSLog(@"share response is over");
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {//login请求
        
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        [self showAlertWin:title content:message cancelButtonTitle:NSLocalizedString(@"确定", nil)];//显示警告窗口
        
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        
        
        WeiboSDKResponseStatusCode reCode = response.statusCode;//取得回调状态
        if (reCode == WeiboSDKResponseStatusCodeSuccess) {//回调成功
            NSDictionary *userInfoDic = response.userInfo;
//                    NSString *expires = [userInfoDic objectForKey:@"expires_in"];
//                    NSString *uid = [userInfoDic objectForKey:@"uid"];
//                    NSString *token = [userInfoDic objectForKey:@"access_token"];
//                    NSString *remind = [userInfoDic objectForKey:@"remind_in"];
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            NSString *jsData = [userInfoDic JSONFragment];
            _jsData=[NSString stringWithString:jsData];
            NSLog(@"data:%@",jsData);
            [self performSelector:@selector(cb_login_success) withObject:self afterDelay:DELAY_TIME];

            
        }else{//回调失败

            [self performSelector:@selector(cb_login_fail) withObject:self afterDelay:DELAY_TIME];
            
        }
        NSLog(@"login response is over");
    }
}


#pragma mark - 延时回调js
#pragma mark login回调js(私有)

-(void)cb_login_success{
    
    [self jsSuccessWithName:@"uexSina.cbLogin" opId:0 dataType:UEX_CALLBACK_DATATYPE_JSON strData:_jsData];//login
    _jsData=nil;
    
}
-(void)cb_login_fail{
    
    [self jsSuccessWithName:@"uexSina.cbLogin" opId:0 dataType:1 intData:UEX_CFALSE];
    
}

#pragma mark share回调js(私有)

-(void)sb_share_success{
    
    [self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];//分享成功
    
}
-(void)sb_share_fail{
    
    [self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFAILED];//分享失败

}


#pragma mark - 分享消息内容
- (WBMessageObject *)messageToShare:(NSInteger)type
{
    
    WBMessageObject *message = [WBMessageObject message];
    switch (type) {
        case SHARE_TXT://text
            
            message.text = _shareTxtContent;//分享文字内容
            NSLog(@"share message txt is over");
        
            break;
            
        case SHARE_IMAGE:{//image
            
            if (_shareImageTxt!=nil && _shareImageTxt.length>0) {
                message.text= _shareImageTxt;
            }
            
            WBImageObject *image_s = [WBImageObject object];
            if ([_shareImagePath hasPrefix:@"http"]) {
                image_s.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImagePath]];//网络图片
            }else{
                image_s.imageData = [NSData dataWithContentsOfFile:_shareImagePath];//本地图片
            }
            message.imageObject = image_s;
            
            NSLog(@"share message image is over");
            
            break;
        }
            
        case SHARE_MEDIA:{//media
            
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = @"identifier1";
            webpage.title = NSLocalizedString(@"分享网页标题", nil);
            webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
            webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
            webpage.webpageUrl = @"http://sina.cn?a=1";
            message.mediaObject = webpage;
            
            break;
        }
        case SHARE_LINK://link
            
            message.text = [NSString stringWithFormat:@"11111%@",@"http://www.xuebuyuan.com/1586944.html"];
            
            break;
        default:
            break;
    }
    
    return message;
    
}

#pragma mark 系统函数回调url

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
    
    NSLog(@"parseURL");
    
    [WeiboSDK handleOpenURL:url delegate:self];
    
}


- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"openURL");
    
    return [WeiboSDK handleOpenURL:url delegate:self];
    
}

#pragma mark - 自定义警告函数

-(void)showAlertWin:(NSString *)title content:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle{
    
    if (_isShowDebugInfo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelTitle
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark  判断字符串长度函数
-(BOOL)isStringHasContent:(NSString *)inStr{

    if (inStr == nil || inStr.length == 0 || [inStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length ==0) {
        //如果传入文字内容是nil,或者长度为0,或者去掉头尾空格和换行符后是空
        return false;//没有内容
    }
    return true;
    
}

- (void)clean{
    
    self.wbtoken=nil;
    self.wbRefreshToken=nil;
    self.wbCurrentUserID=nil;
    
}
@end
