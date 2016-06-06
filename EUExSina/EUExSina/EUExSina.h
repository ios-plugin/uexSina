//
//  EUExSina.h
//  WBPlam
//
//  Created by AppCan on 13-3-25.
//  Copyright (c) 2013年 AppCan. All rights reserved.
//

#import "SinaShareController.h"
#import "WBHttpRequest.h"
#import "WeiboSDK.h"
#import "SinaSingletonClass.h"

@interface EUExSina : EUExBase<WeiboSDKDelegate,SinaShareControllerDelegate,WBHttpRequestDelegate,UIApplicationDelegate,uexSinaCallbackDelegate>{
    SinaShareController *_ssCtrl;
    int currentStatus;
    BOOL isResignCallBack;
}
//- (void)cbRegisterApp:(NSString*)uid accessToken:(NSString*)accessToken;
//- (void)cbLogin:(NSString*)result;

@property(nonatomic,copy)NSString *shareContent;
@property(nonatomic,copy)NSString *shareImgPath;
@property(nonatomic,copy)NSString *shareImgDes;

@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *access_token;
@property(nonatomic,strong)NSString *appKey;
@property(nonatomic,strong)NSString *redirectURI;
@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,assign)BOOL RegisterAppResult;
@end

