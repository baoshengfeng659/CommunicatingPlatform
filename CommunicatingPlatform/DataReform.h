//
//  DataReform.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/11/3.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataReform.h"

@protocol changeDataDelegate <NSObject>

@optional

-(void)changeMaxtimeOrMintime:(double)timeMin andMax:(double)timeMax;

-(void)teamSharechangeMaxtimeOrMintime:(double)timeMin andMax:(double)timeMax;

@end


@interface DataReform : NSObject

@property (nonatomic, assign) id<changeDataDelegate> changeDelegate;

-(NSDictionary *)jsonSerialization:(NSData *)originData;

//处理数据---根据分享时间获取活动群列表
-(NSMutableArray *)reformDataForSquareData:(NSDictionary *)receivedDict timeMin:(double)timeMin timeMax:(double)timeMax;

//处理数据---获取活动群对外公开列表
-(NSMutableArray *)reformDataForShareData:(id)shareData timeMin:(double)timeMin timeMax:(double)timeMax;

//处理数据---获取评论
-(NSArray *)reformDataForComments:(NSArray *)originalData;

@end
