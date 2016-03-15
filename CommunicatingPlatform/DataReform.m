//
//  DataReform.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/11/3.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import "DataReform.h"

@implementation DataReform
-(instancetype)jsonSerialization:(NSData *)originData
{
    if (!originData)
    {
        NSLog(@"请求返回的数据originData=NULL");
        return nil;
    }

    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:originData options:NSJSONReadingAllowFragments error:nil];
    
    NSString *errorStr = [NSString stringWithFormat:@"%@",[responseDict objectForKey:@"error"]];
    if (![errorStr isEqualToString:@"0"]) {
        NSLog(@"请求错误，error:%@:",errorStr);
        return nil;
    }

    // NSLog(@"responseDict=%@",responseDict);
    
    return [responseDict objectForKey:@"data"];
}

-(NSMutableArray *)reformDataForSquareData:(NSDictionary *)receivedDict timeMin:(double)timeMin timeMax:(double)timeMax;
{
   // NSLog(@"receivedDict=%@",receivedDict);
    
    __block double minTime = timeMin;
    __block double maxTime = timeMax;
    
    //NSMutableArray *copyArray = [groupArray mutableCopy];
    NSMutableArray *copyArray = [[NSMutableArray alloc] init];
    
    [receivedDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if (![obj[@"confid"] isEqual:[NSNull null]] && obj[@"confid"] != nil) {
            [copyArray addObject:obj];
        }
        
        //获取更新时间点的最大/最小值
        if (obj[@"time"] != nil)
        {
            NSString *timeStr = [NSString stringWithFormat:@"%@",obj[@"time"]];
            
            if ([timeStr doubleValue] < minTime || minTime == 0) {
                //NSLog(@"timeMin = %f",[timeStr doubleValue]);
                minTime = [timeStr doubleValue];
            }
            
            if ([timeStr doubleValue] > maxTime) {
              //  NSLog(@"timeMax = %f",[timeStr doubleValue]);
                maxTime = [timeStr doubleValue];
            }
            
            if (minTime != timeMin || maxTime != timeMax) {
                [self.changeDelegate changeMaxtimeOrMintime:minTime andMax:maxTime];
            }
        }
    }];
    //NSLog(@"经过整理的群：%@",copyArray);
    
    return copyArray;
}

//处理数据---获取活动群对外公开列表
-(NSMutableArray *)reformDataForShareData:(id)shareData timeMin:(double)timeMin timeMax:(double)timeMax
{
     double minTime = timeMin;
     double maxTime = timeMax;
    
    if ([shareData isKindOfClass:[NSArray class]]) {
        for(NSDictionary *dict in shareData)
        {
            NSString *timeStr = [NSString stringWithFormat:@"%@",dict[@"time"]];
            
            if ([timeStr doubleValue] < minTime || minTime == 0) {
                //NSLog(@"timeMin = %f",[timeStr doubleValue]);
                minTime = [timeStr doubleValue];
            }

            if ([timeStr doubleValue] > maxTime) {
                //  NSLog(@"timeMax = %f",[timeStr doubleValue]);
                maxTime = [timeStr doubleValue];
            }

            if (minTime != timeMin || maxTime != timeMax) {
                [self.changeDelegate teamSharechangeMaxtimeOrMintime:minTime andMax:maxTime];
                //[self.changeDelegate changeMaxtimeOrMintime:minTime andMax:maxTime];
            }
        }
        
        return shareData;
        
    } else if ([shareData isKindOfClass:[NSDictionary class]]) {
        
    }
    
    return nil;
}

//处理数据---获取评论
-(NSArray *)reformDataForComments:(NSArray *)originalData
{
    NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in originalData)
    {
        NSDictionary *commentDict = [dict objectForKey:@"comment"];
        
        [commentsArray addObject:commentDict];
    }
    
    return commentsArray;
}

@end
