//
//  HTTPRequest.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/10/29.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataReform.h"

@protocol httpRequestDelegate <NSObject>

@optional

-(void)successedWithResponse:(NSData *)data tag:(NSString *)tag;

-(void)failledWithError:(NSError *)error;

@end


@interface HTTPRequestForFirst : NSObject

@property (nonatomic ,assign) CGFloat timeMin_firstL;  //第一层指向最小（用于获取旧数据）
@property (nonatomic ,assign) CGFloat timeMax_firstL;  //第一层指向最大（用于获取新数据）

@property (nonatomic ,assign) CGFloat timeMin_secondtL;  //第二层指向最小（用于获取旧数据）
@property (nonatomic ,assign) CGFloat timeMax_secondL;  //第二层指向最大（用于获取新数据）

@property (strong, nonatomic) DataReform *reformData;

@property (nonatomic, assign) id<httpRequestDelegate> requestDelegate;

//获取有对外公开分享的群,最后一个参数YES表示下拉刷新，否则代表上拉刷新
-(void)getGroupWhichHasOpenedShares:(CGFloat)time ifPullDown:(BOOL)isPullDown;

//获取某个群的群外公开列表
-(void)getSharesOfOneTeamWithTime:(CGFloat)time confid:(NSString *)confid ifPullDown:(BOOL)isPullDown;

//获取发表的评论
-(void)getCommentOfTheShareWithPostId:(NSString *)postId;

//发表评论
-(void)makeCommentWithUid:(NSString *)uid PostId:(NSString *)postId Content:(NSString *)content;


@end
