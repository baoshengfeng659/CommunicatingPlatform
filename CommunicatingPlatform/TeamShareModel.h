//
//  TeamShareModel.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/12.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamShareModel : NSObject

@property (strong, nonatomic) NSString *confid;

@property (strong, nonatomic) NSString *content;                            //分享的文字

@property (strong, nonatomic) NSString *headPortraitName;                   //分享者头像名字
@property (strong, nonatomic) NSString *headPortraitURL;

@property (strong, nonatomic) NSString *imageFileName;                      //分享的图片名字
@property (strong, nonatomic) NSString *imageFileURL;

@property (strong, nonatomic) NSString *user;                               //分享者用户名

@property (strong, nonatomic) NSString *uid;

@property (strong, nonatomic) NSString *time;                               //分享发布的时间

@property (strong, nonatomic) NSString *postId;                             //分享键

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
