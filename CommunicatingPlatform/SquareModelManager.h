//
//  SquareModelManager.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/12/29.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquareModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *squareModelArr;

-(void)reformRowDataToModel:(NSArray *)array UpOrDownUpdate:(NSInteger)flag;

@end
