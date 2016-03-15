//
//  TSCellDataDL.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/12.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSCellDataDL.h"

#define HeadPicture @"headImage"
#define ShareImage @"shareImae"

@implementation TSCellDataDL

-(void)downloadPictureWithTypeName:(NSString *)typeName downloadURL:(NSString *)urlStr fileName:(NSString *)name
{
    NSURL *downloadURL = [NSURL URLWithString:urlStr];

    NSLog(@"downloadURL=%@, name=%@",downloadURL,name);

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithURL:downloadURL completionHandler:^(NSURL *location,NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"图片下载出错：%@",error.localizedDescription);
            return ;
        }
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        
        if (image) {
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:name];
            
            //保存图片到本地
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                [UIImageJPEGRepresentation(image, 0.5) writeToFile:filePath atomically:YES];
            }
            
            if ([typeName isEqualToString:HeadPicture]) {
                [_downloadDelegate completeDownloadingHeadPortrait:name];
            }
            if ([typeName isEqualToString:ShareImage]) {
                [_downloadDelegate completeDownloadingShareImage:name];
            }
        }
    }];
    
    [downLoadTask resume];
}

@end
