//
//  EUExSina.m
//  WBPlam
//
//  Created by AppCan on 13-3-25.
//  Copyright (c) 2013年 AppCan. All rights reserved.
//

#import "EUExSina.h"
#import "EUtility.h"
#import "EUExBaseDefine.h"
#import "JSON.h"
#import "WeiboSDK.h"
#import "SinaSingletonClass.h"
@interface EUExSina()
@property(nonatomic,strong)ACJSFunctionRef*funcRegisterApp;
@property(nonatomic,strong)ACJSFunctionRef*funcLogin;
@property(nonatomic,strong)ACJSFunctionRef*funcLogout;
@property(nonatomic,strong)ACJSFunctionRef*funcShare;
@property(nonatomic,strong)ACJSFunctionRef*funcGetInfo;
@end
@implementation EUExSina

- (instancetype)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine
{
    self = [super initWithWebViewEngine:engine];
    if (self) {
         isResignCallBack = NO;
    }
    return self;
}
//-(void)clean{
//    self.shareContent = nil;
//    self.shareImgDes = nil;
//    self.shareImgPath = nil;
//}
//
//-(void)dealloc{
//    self.shareContent = nil;
//    self.shareImgDes = nil;
//    self.shareImgPath = nil;
//    [super dealloc];
//}
//
//-(void)cleanUserInfo:(NSMutableArray*)inArguments
//{
//    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
//    id userId = [ud objectForKey:oauth2SianUserID];
//    id tokenkey = [ud objectForKey:oauth2SinaTokenKey];
//    if (tokenkey)
//    {
//        [ud removeObjectForKey:oauth2SinaTokenKey];
//    }
//    if (userId)
//    {
//        [ud removeObjectForKey:oauth2SianUserID];
//    }
//}
//#pragma mark
//#pragma mark - 新浪微博登陆,获取access_tocken和uid
//#pragma mark
//
//-(void)login:(NSMutableArray*)inArguments{
//    
//    NSString *appKey = [inArguments objectAtIndex:0];
//    NSString *appSecret = [inArguments objectAtIndex:1];
//    NSString *registerUrl = [inArguments objectAtIndex:2];
//    
//    if(_ssCtrl) {
//        
//    }else {
//        _ssCtrl =[[SinaShareController alloc] init];
//    }
//    _ssCtrl.loginType = @"login";
//    _ssCtrl.delegate = self;
//    _ssCtrl.appSecret = appSecret;
//    _ssCtrl.appKey = appKey;
//    _ssCtrl.registerUrl = registerUrl;
//    if (_ssCtrl.appKey && _ssCtrl.appSecret && _ssCtrl.registerUrl)
//    {
//        [_ssCtrl logIn];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ssCtrl];
//        [EUtility brwView:meBrwView presentModalViewController:nav animated:YES];
//        [nav release];
//    }
//}
//-(void)registerApp:(NSMutableArray*)inArguments{
//    isResignCallBack = YES;
//    NSString *appKey = [inArguments objectAtIndex:0];
//    NSString *appSecret = [inArguments objectAtIndex:1];
//    NSString *registerUrl = [inArguments objectAtIndex:2];
//    /*if ([EUtility appCanDev]) {
//     appKey =@"3845409824";
//     appSecret = @"6baa661d49374c9da3ea9cab1c406ab6";
//     registerUrl = @"http://www.3g2win.com/tiaozhuan/index.html";
//     }*/
//    if (!_ssCtrl) {
//        _ssCtrl =[[SinaShareController alloc] init];
//        _ssCtrl.delegate = self;
//        _ssCtrl.appSecret = appSecret;
//        _ssCtrl.appKey = appKey;
//        _ssCtrl.registerUrl = registerUrl;
//        if (_ssCtrl.appKey && _ssCtrl.appSecret && _ssCtrl.registerUrl)
//        {
//            if ([SinaShareController isValid])
//            {
//                NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
//                id userId = [ud objectForKey:oauth2SianUserID];
//                id tokenkey = [ud objectForKey:oauth2SinaTokenKey];
//                self.uid=userId;
//                self.access_token=tokenkey;
//                //回调callback
//               // NSString *jsString = [NSString stringWithFormat:@"uexSina.registerCallBack('%@','%@',%d);",userId,tokenkey,UEX_CSUCCESS];
//                //20140901xrg增加uexSina.cbRegister回调方法
//                NSString *jsStringCB = [NSString stringWithFormat:@"uexSina.cbRegisterApp('%@','%@',%d);",userId,tokenkey,UEX_CSUCCESS];
//                //[self.meBrwView stringByEvaluatingJavaScriptFromString:jsString];
//                [self.meBrwView stringByEvaluatingJavaScriptFromString:jsStringCB];
//            }else
//            {
//                [_ssCtrl logIn];
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ssCtrl];
//                [EUtility brwView:meBrwView presentModalViewController:nav animated:YES];
//                [nav release];
//            }
//        }
//        else
//        {
//            //回调callback
//            //[self jsSuccessWithName:@"uexSina.registerCallBack" opId:0 dataType:1 intData:UEX_CFALSE];
//            [self jsSuccessWithName:@"uexSina.cbRegisterApp" opId:0 dataType:1 intData:UEX_CFALSE];
//        }
//    }else
//    {
//        if ([SinaShareController isValid])
//        {
//            NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
//            id userId = [ud objectForKey:oauth2SianUserID];
//            id tokenkey = [ud objectForKey:oauth2SinaTokenKey];
//            self.uid=userId;
//            self.access_token=tokenkey;
//            //回调callback
//            //NSString *jsString = [NSString stringWithFormat:@"uexSina.registerCallBack('%@','%@',%d);",userId,tokenkey,UEX_CSUCCESS];
//            NSString *jsString = [NSString stringWithFormat:@"uexSina.cbRegisterApp('%@','%@',%d);",userId,tokenkey,UEX_CSUCCESS];
//            [self.meBrwView stringByEvaluatingJavaScriptFromString:jsString];
//        }else
//        {
//            [_ssCtrl logIn];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ssCtrl];
//            [EUtility brwView:meBrwView presentModalViewController:nav animated:YES];
//            [nav release];
//        }
//    }
//}
//
//-(void)sendTextContent:(NSMutableArray*)inArguments{
//    currentStatus =1;
//    NSString *content = [inArguments objectAtIndex:0];
//    self.shareContent = content;
//    
//    if ([SinaShareController isValid]) {
//        [_ssCtrl shareWithContent:self.shareContent];
//    }else {
//        if (!_ssCtrl) {
//            return;
//        }
//        
//        [_ssCtrl logIn];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ssCtrl];
//        [EUtility brwView:meBrwView presentModalViewController:nav animated:YES];
//        [nav release];
//    }
//}
//
//-(void)sendImageContent:(NSMutableArray*)inArguments{
//    if ([inArguments isKindOfClass:[NSMutableArray class]] && [inArguments count]>0) {
//        currentStatus = 2;
//        NSLog(@"hui-->uexSina-->sendImageContent");
//        NSString *realImgPath = [self absPath:[inArguments objectAtIndex:0]];
//        NSLog(@"hui-->uexSina-->sendImageContent realImgPath is %@",realImgPath);
//        self.shareImgPath = realImgPath;
//        if ([inArguments count]>1) {
//            self.shareImgDes = [inArguments objectAtIndex:1];
//        }else{
//            self.shareImgDes = @"";
//        }
//        if ([SinaShareController isValid]) {
//            if ([self.shareImgPath hasPrefix:@"http"]) {
//                [_ssCtrl shareWithImgUrl:self.shareImgPath andContent:self.shareImgDes];
//            }else{
//                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.shareImgPath];
//                if (!fileExists) {
//                    [self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:@"图片不存在"];
//                    return;
//                }
//                [_ssCtrl shareWithImage:self.shareImgPath andContent:self.shareImgDes];
//            }
//        }else {
//            if (!_ssCtrl) {
//                return;
//            }
//            [_ssCtrl logIn];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ssCtrl];
//            UIViewController *vc = [EUtility brwCtrl:meBrwView];
//            [vc presentModalViewController:nav animated:YES];
//            //[_ssCtrl release];
//            [nav release];
//            //_ssCtrl = nil;
//        }
//    }
//}
//
//#pragma mark - private
//
//-(void)doSendContent{
//    [_ssCtrl shareWithContent:self.shareContent];
//}
//
//-(void)doSendImg{
//    if ([self.shareImgPath hasPrefix:@"http"]) {
//        [_ssCtrl shareWithImgUrl:self.shareImgPath andContent:self.shareImgDes];
//    }else{
//        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.shareImgPath];
//        if (!fileExists) {
//            [self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:@"图片不存在"];
//            return;
//        }
//        [_ssCtrl shareWithImage:self.shareImgPath andContent:self.shareImgDes];
//    }
//}
//
//#pragma mark for delegate
//#pragma mark -
//#pragma mark SinaShareDelegate
//
//-(void)requestDidSucceedWithResult:(id)result{
//    [_ssCtrl release];
//    _ssCtrl = nil;
//    [self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];
//}
//
//-(void)requestDidFailedWithResult:(id)result{
//    [_ssCtrl release];
//    _ssCtrl = nil;
//    [self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFAILED];
//}
//- (void)sinaLogin {
//    
//    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
//    id userId = [ud objectForKey:oauth2SianUserID];
//    id tokenkey = [ud objectForKey:oauth2SinaTokenKey];
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:[ud objectForKey:@"expires_in"] forKey:@"expires_in"];
//    [dict setObject:userId forKey:oauth2SianUserID];
//    [dict setObject:tokenkey forKey:oauth2SinaTokenKey];
//    
//    [dict setObject:[ud objectForKey:@"remind_in"] forKey:@"remind_in"];
//    NSString *jsData = [dict JSONFragment];
//    //回调callback
//    [self jsSuccessWithName:@"uexSina.cbLogin" opId:0 dataType:UEX_CALLBACK_DATATYPE_JSON strData:jsData];
//}
//
//-(void)SinaLoginSuccess{
//    //授权关注
//    ///  [NSThread detachNewThreadSelector:@selector(attendAppCan) toTarget:self withObject:nil];
//    if (currentStatus==1) {
//        [self doSendContent];
//    }else if (currentStatus==2){
//        [self doSendImg];
//    }
//    if (isResignCallBack)
//    {
//        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
//        id userId = [ud objectForKey:oauth2SianUserID];
//        id tokenkey = [ud objectForKey:oauth2SinaTokenKey];
//        //回调callback
//        //NSString *jsString = [NSString stringWithFormat:@"uexSina.registerCallBack('%@','%@',%d);",userId,tokenkey,UEX_CSUCCESS];
//        NSString *jsString = [NSString stringWithFormat:@"uexSina.cbRegisterApp('%@','%@',%d);",userId,tokenkey,UEX_CSUCCESS];
//        [self.meBrwView stringByEvaluatingJavaScriptFromString:jsString];
//        isResignCallBack = NO;
//    }
//}
//
//-(void)attendAppCan{
//    @autoreleasepool {
//        NSString *attendUrl = @"https://api.weibo.com/2/friendships/create.json";
//        NSMutableString *paramsStr =[[[NSMutableString alloc] initWithString:@""] autorelease];
//        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
//        id tokenkey = [ud objectForKey:oauth2SinaTokenKey];
//        if (!tokenkey) {
//            return;
//        }
//        [paramsStr appendFormat:@"access_token=%@",tokenkey];
//        [paramsStr appendFormat:@"&uid=2549872882"];
//        NSError *error;
//        NSURLResponse *theResponse;
//        NSMutableURLRequest *request =[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:attendUrl]] autorelease];
//        [request setHTTPMethod:@"POST"];
//        [request setHTTPBody:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
//        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&error];
//    }
//}

#pragma mark -
#pragma mark 新浪微博登陆、登出,获取access_tocken、uid和用户信息++++++++++++++
-(void)getUserInfo:(NSMutableArray*)inArguments{
     ACJSFunctionRef *func = JSFunctionArg(inArguments.lastObject);
    self.funcGetInfo = func;
    SinaSingletonClass *sinaInfo=[SinaSingletonClass sharedManager];
    if(!sinaInfo.appKey||!sinaInfo.access_token||!sinaInfo.uid){
        //[self jsSuccessWithName:@"uexSina.cbGetUserInfo"opId:0 dataType:UEX_CALLBACK_DATATYPE_JSON strData:@"未登录授权获取uid、access_token，获取用户信息失败"];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbGetUserInfo" arguments:ACArgsPack(@0,@1,@"未登录授权获取uid、access_token，获取用户信息失败")];
        [self.funcGetInfo executeWithArguments:ACArgsPack(@"未登录授权获取uid、access_token，获取用户信息失败")];
        self.funcGetInfo = nil;
        return;
    }
    NSString *source=sinaInfo.appKey;
    NSString *access_token=sinaInfo.access_token;
    NSString *uid=sinaInfo.uid;
    NSString *url =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?source=%@&access_token=%@&uid=%@",source,access_token,uid];
    NSURL *zoneUrl = [NSURL URLWithString:url];
    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSMutableDictionary *userInfoDict=[NSMutableDictionary alloc];
        userInfoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"userInfoDict------>>>>%@",userInfoDict);
        [self cbGetUserInfo:[userInfoDict JSONFragment]];
    }
    
}

- (void)cbGetUserInfo:userInfo{
    userInfo=[userInfo JSONFragment];
    //NSString *cbStr=[NSString stringWithFormat:@"if(uexSina.cbGetUserInfo != null){uexSina.cbGetUserInfo('%d','%d',%@);}",0,UEX_CALLBACK_DATATYPE_JSON,userInfo];
    //[EUtility brwView:meBrwView evaluateScript:cbStr];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbGetUserInfo" arguments:ACArgsPack(@0,@1,userInfo)];
    [self.funcGetInfo executeWithArguments:ACArgsPack(userInfo)];
    self.funcGetInfo = nil;
}

-(void)registerApp:(NSMutableArray*)inArguments{
     ACJSFunctionRef *func = JSFunctionArg(inArguments.lastObject);
    self.funcRegisterApp = func;
    if(inArguments.count<3){
        return;
    }
    SinaSingletonClass *sinaInfo=[SinaSingletonClass sharedManager];
    sinaInfo.isLogin=NO;
    NSString *kAppKey = [inArguments objectAtIndex:0];
    sinaInfo.appKey=kAppKey;
    NSString *redirectURI = [inArguments objectAtIndex:2];
    //[WeiboSDK enableDebugMode:YES];   //打印日志
    
    if(!self.RegisterAppResult){
        self.RegisterAppResult =[WeiboSDK registerApp:kAppKey];
        NSLog(@"SDKVersion:%@",[WeiboSDK getSDKVersion]);
    }
    if(self.RegisterAppResult){
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        self.redirectURI=redirectURI;
        request.redirectURI = redirectURI;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"EUExSina",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [SinaSingletonClass sharedManager].delegate=self;
        [WeiboSDK sendRequest:request];
    }
    else{
        [self cbRegisterApp];
    }
}

- (void)cbRegisterApp{
    SinaSingletonClass *sinaInfo=[SinaSingletonClass sharedManager];
    if(sinaInfo.uid && sinaInfo.access_token){
        //NSString *cbStr=[NSString stringWithFormat:@"if(uexSina.cbRegisterApp != null){uexSina.cbRegisterApp('%@','%@',%d);}",sinaInfo.uid,sinaInfo.access_token,UEX_CSUCCESS];
        //[EUtility brwView:meBrwView evaluateScript:cbStr];
         [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbRegisterApp" arguments:ACArgsPack(sinaInfo.uid,sinaInfo.access_token,@0)];
        NSDictionary *dic = @{@"openId":sinaInfo.uid,@"token":sinaInfo.access_token,@"code":@0};
         [self.funcRegisterApp executeWithArguments:ACArgsPack(dic)];
    }
    else{
        //NSString *cbStr=[NSString stringWithFormat:@"if(uexSina.cbRegisterApp != null){uexSina.cbRegisterApp('%d','%d',%d);}",0,UEX_CALLBACK_DATATYPE_INT,UEX_CFAILED];
        //[EUtility brwView:meBrwView evaluateScript:cbStr];
         NSDictionary *dic = @{@"code":@1};
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbRegisterApp" arguments:ACArgsPack(@0,@2,@1)];
        [self.funcRegisterApp executeWithArguments:ACArgsPack(dic)];
    }
    self.funcRegisterApp = nil;
}
-(void)login:(NSMutableArray*)inArguments{
    if(inArguments.count<2){
        return;
    }
     ACJSFunctionRef *func = JSFunctionArg(inArguments.lastObject);
    self.funcLogin = func;
    SinaSingletonClass *sinaInfo=[SinaSingletonClass sharedManager];
    sinaInfo.isLogin=YES;
    NSString *kAppKey = [inArguments objectAtIndex:0];
    sinaInfo.appKey=kAppKey;
    NSString *redirectURI = [inArguments objectAtIndex:1];
    //[WeiboSDK enableDebugMode:YES];   //打印日志
    
    if(!self.RegisterAppResult){
        //NSLog(@"---------registerApp----------");
        self.RegisterAppResult=[WeiboSDK registerApp:kAppKey];
    }
    if(self.RegisterAppResult){
        //NSLog(@"---------registerAppOK----------");
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        self.redirectURI=redirectURI;
        request.redirectURI = redirectURI;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"EUExSina",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [SinaSingletonClass sharedManager].delegate=self;
        [WeiboSDK sendRequest:request];
    }else{
        //NSLog(@"---------RegisterAppResult==NO----------");
        [self cbLogin:nil];
    }
}

- (void)cbLogin:(NSString*)result{
    result = [result JSONFragment];
    //NSString *cbStr=[NSString stringWithFormat:@"if(uexSina.cbLogin != null){uexSina.cbLogin('%d','%d',%@);}",0,UEX_CALLBACK_DATATYPE_JSON,result];
    //[EUtility brwView:meBrwView evaluateScript:cbStr];
     [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbLogin" arguments:ACArgsPack(@0,@1,result)];
    [self.funcLogin executeWithArguments:ACArgsPack(result)];
     self.funcLogin = nil;
}
-(void)logout:(NSMutableArray*)inArguments{
     ACJSFunctionRef *func = JSFunctionArg(inArguments.lastObject);
    self.funcLogout = func;
    SinaSingletonClass *sinaInfo=[SinaSingletonClass sharedManager];
    [WeiboSDK logOutWithToken:sinaInfo.access_token delegate:self withTag:@"user1"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSMutableArray *resultVal=[NSMutableArray alloc];
    resultVal = [result JSONFragmentValue];
    //NSLog(@"------------%@",[resultVal valueForKey:@"result"]);
    if([[resultVal valueForKey:@"result"] isEqualToString:@"true"]){
        self.RegisterAppResult=NO;
        SinaSingletonClass *sinaInfo=[SinaSingletonClass sharedManager];
        sinaInfo.appKey=nil;
        sinaInfo.access_token=nil;
        sinaInfo.uid=nil;
        //NSString *cbStr=[NSString stringWithFormat:@"if(uexSina.cbLogout != null){uexSina.cbLogout('%d','%d',%d);}",0,UEX_CALLBACK_DATATYPE_INT,0];
        //[EUtility brwView:meBrwView evaluateScript:cbStr];
         [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbLogout" arguments:ACArgsPack(@0,@2,@0)];
        [self.funcLogout executeWithArguments:ACArgsPack(@0)];
    }
    else{
        //NSString *cbStr=[NSString stringWithFormat:@"if(uexSina.cbLogout != null){uexSina.cbLogout('%d','%d',%d);}",0,UEX_CALLBACK_DATATYPE_INT,1];
        //[EUtility brwView:meBrwView evaluateScript:cbStr];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbLogout" arguments:ACArgsPack(@0,@2,@1)];
        [self.funcLogout executeWithArguments:ACArgsPack(@1)];
    }
    self.funcLogout = nil;
}
-(void)sendTextContent:(NSMutableArray*)inArguments{
    if(inArguments.count<1){
        return;
    }
    ACJSFunctionRef *func = JSFunctionArg(inArguments.lastObject);
    self.funcShare = func;
    SinaSingletonClass *sinaInfo=[SinaSingletonClass sharedManager];
    if(!sinaInfo.access_token || !self.redirectURI){
        //[self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT intData:1];
         [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbShare" arguments:ACArgsPack(@0,@0,@1)];
        [self.funcShare executeWithArguments:ACArgsPack(@1)];
        self.funcShare = nil;
        return;
    }
    WBMessageObject *message = [WBMessageObject message];
    message.text=[inArguments objectAtIndex:0];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = self.redirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage: message authInfo:authRequest access_token:sinaInfo.access_token];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [SinaSingletonClass sharedManager].delegate=self;
    [WeiboSDK sendRequest:request];
}
-(void)sendImageContent:(NSMutableArray*)inArguments{
    if(inArguments.count<2){
        return;
    }
    ACJSFunctionRef *func = JSFunctionArg(inArguments.lastObject);
    self.funcShare = func;
    SinaSingletonClass *sinaInfo=[SinaSingletonClass sharedManager];
    if(!sinaInfo.access_token || !self.redirectURI){
        //[self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT intData:1];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbShare" arguments:ACArgsPack(@0,@0,@1)];
        [self.funcShare executeWithArguments:ACArgsPack(@1)];
        self.funcShare = nil;
        return;
    }
    WBMessageObject *message = [WBMessageObject message];
    message.text=[inArguments objectAtIndex:1];
    
    WBImageObject *image = [WBImageObject object];
    NSString *imgPath=[[inArguments objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSURL *url;
    if ([imgPath hasPrefix:@"http"]) {
        url = [NSURL URLWithString:imgPath];
    }else{
        url = [NSURL fileURLWithPath:[self absPath:imgPath]];
    }
    image.imageData = [NSData dataWithContentsOfURL:url];
    if (!image.imageData) {
        //[self jsSuccessWithName:@"uexSina.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:@"图片不存在"];
         [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbShare" arguments:ACArgsPack(@0,@0,@"图片不存在")];
        [self.funcShare executeWithArguments:ACArgsPack(@"图片不存在")];
        self.funcShare = nil;
        return;
    }
    message.imageObject = image;
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = self.redirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage: message authInfo:authRequest access_token:sinaInfo.access_token];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [SinaSingletonClass sharedManager].delegate=self;
    [WeiboSDK sendRequest:request];
}

-(void)cbShare:(int)statusCode{
    //NSString *cbStr=[NSString stringWithFormat:@"if(uexSina.cbShare != null){uexSina.cbShare('%d','%d',%d);}",0,UEX_CALLBACK_DATATYPE_INT,statusCode];
    //[EUtility brwView:meBrwView evaluateScript:cbStr];
     [self.webViewEngine callbackWithFunctionKeyPath:@"uexSina.cbShare" arguments:ACArgsPack(@0,@2,@(statusCode))];
     [self.funcShare executeWithArguments:ACArgsPack(@(statusCode))];
    self.funcShare = nil;
}

+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return [WeiboSDK handleOpenURL:url delegate:[SinaSingletonClass sharedManager]];
}

//+(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [WeiboSDK handleOpenURL:url delegate:[SinaSingletonClass sharedManager] ];
//}


@end

