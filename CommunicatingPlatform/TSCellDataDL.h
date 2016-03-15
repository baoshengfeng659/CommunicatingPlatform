//
//  TSCellDataDL.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/12.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol downloadDelegate <NSObject>

@optional
-(void)completeDownloadingHeadPortrait:(NSString *)fileName;
-(void)completeDownloadingShareImage:(NSString *)fileName;

@end

@interface TSCellDataDL : NSObject

@property (assign, nonatomic) id<downloadDelegate> downloadDelegate;

-(void)downloadPictureWithTypeName:(NSString *)typeName downloadURL:(NSString *)urlStr fileName:(NSString *)name;

@end
