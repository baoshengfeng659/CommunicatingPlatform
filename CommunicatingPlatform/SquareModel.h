//
//  SquareModel.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/12/29.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquareModel : NSObject
@property (strong, nonatomic) NSString *confid;                 //车队编号

@property (strong, nonatomic) NSString *uid;                    //车队创建者uid

@property (strong, nonatomic) NSString *user;                   //车队创建者用户名

@property (strong, nonatomic) NSString *headPortrait;           //创建者头像
@property (strong, nonatomic) NSString *headPortraitURL;          //创建者头像下载地址

@property (strong, nonatomic) NSString *confName;               //车队名字，即活动主题

@property (strong, nonatomic) NSString *pictorial;              //车队海报
@property (strong, nonatomic) NSString *pictorialURL;           //车队海报下载地址

@property (strong, nonatomic) NSString *activityInfo;           //车队活动的详情介绍

//@property (strong, nonatomic) NSString *time;                   //指向车队里最新发布的分享时间(初始时间是车队创建的时间)

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
