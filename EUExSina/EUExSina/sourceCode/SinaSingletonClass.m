//
//  SinaSingletonController.m
//  EUExSina
//
//  Created by 黄锦 on 15/11/23.
//  Copyright © 2015年 xll. All rights reserved.
//


#import "SinaSingletonClass.h"
#import "EUExSina.h"
#import "JSON.h"

@implementation SinaSingletonClass



#pragma mark Singleton Methods
+ (SinaSingletonClass* )sharedManager {
    static SinaSingletonClass *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager=[[SinaSingletonClass alloc]init];
    });
    return sharedMyManager;
}
-(instancetype)initWithEUExSina:(EUExSina*)EUExSina{
    return self;
}

- (void)dealloc {
    // 永远不要调用这个方法
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if([response isKindOfClass:WBAuthorizeResponse.class]){
        WBAuthorizeResponse* sendMessageToWeiboResponse = (WBAuthorizeResponse*)response;
        //NSLog(@"sendMessageToWeiboResponse.authResponse------%@",response.userInfo);
        NSString* accessToken = sendMessageToWeiboResponse.accessToken;
        NSString* userID = sendMessageToWeiboResponse.userID;
        
       
        if(accessToken){
            self.access_token=accessToken;
        }
        if(userID){
            self.uid=userID;
        }
        if(self.isLogin){
            if([_delegate respondsToSelector:@selector(cbLogin:)]){
                [_delegate cbLogin:[response.userInfo JSONFragment]];
            }
        }
        else{
            if([_delegate respondsToSelector:@selector(cbRegisterApp)]){
                [_delegate cbRegisterApp];
            }
        }
    }
    else  if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {

        //NSLog(@"response.statusCode---------------------------%ld",response.statusCode);
        
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        NSString* userID =[sendMessageToWeiboResponse.authResponse userID];
        
        if(accessToken){
            self.access_token=accessToken;
        }
        if(userID){
            self.uid=userID;
        }
        if([_delegate respondsToSelector:@selector(cbShare:)]){
            [_delegate cbShare:(int)response.statusCode];
        }
    }
}



@end

