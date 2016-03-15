//
//  SquarCellDataDL.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/12/30.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol cellDataDownloadDelegate <NSObject>

@optional
-(void)completeDownloadingHeadPortrait:(NSString *)fileName;
-(void)completeDownloadingPictorial:(NSString *)fileName;

@end

@interface SquareCellDataDL : NSObject

@property (nonatomic, assign) id<cellDataDownloadDelegate> downloadDelegate;

-(void)downloadPictureWithTypeName:(NSString *)typeName downloadURL:(NSString *)urlStr fileName:(NSString *)name;

@end
