//
//  EUExSina.h
//  EUExSina
//
//  Created by 陈晓明 on 15/9/9.
//  Copyright (c) 2015年 陈晓明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUExBase.h"
#import "WeiboSDK.h"


@interface EUExSina : EUExBase<WeiboSDKDelegate,WBHttpRequestDelegate>{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
    
}

@property (strong, nonatomic) NSString *wbtoken;//当前的token(可以和新的token对比)
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *wbRefreshToken;//最新的token(用来和原来的token进行对比)


@end
