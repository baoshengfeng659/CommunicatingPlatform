//
//  TeamShareCell.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/12.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "TeamShareCell.h"
#import "TeamShareModel.h"
#import "TSCellDataDL.h"

#define HeadPicture @"headImage"
#define ShareImage @"shareImae"

#define CellWidth self.frame.size.width
#define CellHeight self.frame.size.height
#define BottomHeight self.frame.size.height/5
#define GapSpace 5

@interface TeamShareCell() <downloadDelegate>

@property (strong, nonatomic) UIImageView *shareIV;
@property (strong, nonatomic) UIImageView *headIV;
@property (strong, nonatomic) UITextField *contentFD;

@property (strong, nonatomic) TSCellDataDL *cellDataDL;

@end

@implementation TeamShareCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        
        _shareIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CellWidth, CellHeight-BottomHeight)];
        
        _headIV = [[UIImageView alloc] initWithFrame:CGRectMake(GapSpace, CGRectGetMaxY(_shareIV.frame) + GapSpace, BottomHeight - GapSpace*2, BottomHeight - GapSpace*2)];
        _headIV.layer.cornerRadius = _headIV.frame.size.width/2;
        _headIV.clipsToBounds = YES;

        _contentFD = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headIV.frame) + GapSpace, CGRectGetMaxY(_shareIV.frame) + GapSpace, CellWidth - _headIV.frame.size.width - GapSpace*2, BottomHeight - GapSpace*2)];
        _contentFD.userInteractionEnabled = NO;
        _contentFD.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:_shareIV];
        [self addSubview:_headIV];
        [self addSubview:_contentFD];
    }
    
    return self;
}

-(void)setCellDate:(TeamShareModel *)cellModel
{
    [self settingCellDate:cellModel];
}

-(void)settingCellDate:(TeamShareModel *)cellModel
{
    _contentFD.text = cellModel.content;
    
    //获取发布者头像，如果不存在就下载
    NSString *headFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",cellModel.headPortraitName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:headFilePath]) {
        _headIV.image = [UIImage imageWithContentsOfFile:headFilePath];
        
    } else { //本地不存在
        if (!_cellDataDL) {
            _cellDataDL = [[TSCellDataDL alloc] init];
            _cellDataDL.downloadDelegate = self;
        }
        [_cellDataDL downloadPictureWithTypeName:HeadPicture downloadURL:cellModel.headPortraitURL fileName:cellModel.headPortraitName];
    }
    
    //获取分享图片，如果不存在就下载
    NSString *shareImageFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",cellModel.imageFileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:shareImageFilePath]) {
        _shareIV.image = [UIImage imageWithContentsOfFile:shareImageFilePath];
        
    } else { //本地不存在
        if (!_cellDataDL) {
            _cellDataDL = [[TSCellDataDL alloc] init];
            _cellDataDL.downloadDelegate = self;
        }
        [_cellDataDL downloadPictureWithTypeName:HeadPicture downloadURL:cellModel.imageFileURL fileName:cellModel.imageFileName];
    }

}

#pragma mark - downloadDelegate

-(void)completeDownloadingHeadPortrait:(NSString *)fileName
{
    NSString *headFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:headFilePath]) {
            _headIV.image = [UIImage imageWithContentsOfFile:headFilePath];
        }
    });
}

-(void)completeDownloadingShareImage:(NSString *)fileName
{
    NSString *shareImageFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:shareImageFilePath]) {
            _shareIV.image = [UIImage imageWithContentsOfFile:shareImageFilePath];
        }
    });
}

@end
