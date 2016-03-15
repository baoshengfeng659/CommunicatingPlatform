//
//  HTTPRequestForFourth.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/5.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPRequestForFourthDelegate <NSObject>
@optional
-(void)createKYTeamSuccessfully;

@end

@interface HTTPRequestForFourth : NSObject

@property (assign, nonatomic) id<HTTPRequestForFourthDelegate> fourthWebDelegate;

//登录帐号
-(void)loginAccountWithUsername:(NSString *)name andPassword:(NSString *)password;

-(void)createKYTeam:(NSArray *)infoArray;

@end
