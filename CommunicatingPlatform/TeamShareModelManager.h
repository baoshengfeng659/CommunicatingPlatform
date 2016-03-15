//
//  TeamShareModelManager.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/12.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamShareModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *teamShareModelArr;

-(void)reformRowDataToModel:(NSArray *)array UpOrDownUpdate:(NSInteger)flag;

@end

