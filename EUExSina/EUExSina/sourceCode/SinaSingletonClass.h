//
//  SinaSingletonController.h
//  EUExSina
//
//  Created by 黄锦 on 15/11/23.
//  Copyright © 2015年 xll. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@protocol uexSinaCallbackDelegate<NSObject>
-(void)cbLogin:(NSString *)result;
-(void)cbRegisterApp;
-(void)cbShare:(int)statusCode;

@optional
@end

@interface SinaSingletonClass : NSObject<WeiboSDKDelegate>


+ (SinaSingletonClass *)sharedManager;
@property (nonatomic, retain) NSString *someProperty;


//@property (nonatomic,strong)EUExSina *EUExSina;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *access_token;
@property(nonatomic,strong)NSString *appKey;
@property(nonatomic,strong)NSString *redirectURI;
@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,assign)id<uexSinaCallbackDelegate> delegate;


@end

