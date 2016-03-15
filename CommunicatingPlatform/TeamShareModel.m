//
//  TeamShareModel.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/12.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "TeamShareModel.h"

@implementation TeamShareModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        // 当使用setValuesForKeysWithDictionary:方法时,对于数据模型中缺少的、不能与任何键配对的属性的时候,系统会自动调用setValue:forUndefinedKey:这个方法(必须重写这个方法，不然会报错)
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
