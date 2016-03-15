//
//  SquareViewCell.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/10/28.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import "SquareViewCell.h"
#import "SquareCellDataDL.h"
#import "SquareModel.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define activityInfoFont [UIFont systemFontOfSize:16]

#define HeadPicture @"head"
#define Pictorial @"pictorial"

@interface SquareViewCell()<cellDataDownloadDelegate>
@property (nonatomic, weak) UILabel *confNameTV;     //车队主题
@property (nonatomic, weak) UILabel *userLabel;          //车队创建者的用户名
@property (nonatomic, weak) UIImageView *headPortraitIV; //车队创建者头像
@property (nonatomic, weak) UIImageView *pictorialIV;    //车队画报
@property (nonatomic, weak) UILabel *activityInfoIV;  //车队详细介绍
@property (nonatomic, weak) UIView *fillView;            //底部填充

@property (nonatomic, strong) SquareCellDataDL *cellDataDL;
@end

@implementation SquareViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //车队主题
        UILabel *confName = [[UILabel alloc] init];
        confName.font = [UIFont systemFontOfSize:16];
        confName.numberOfLines = 0;
        [self.contentView addSubview:confName];
        self.confNameTV = confName;
        
        //车队创建者用户名
        UILabel *user = [[UILabel alloc] init];
        user.font = [UIFont systemFontOfSize:16];
        user.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:user];
        self.userLabel = user;
        
        //创建者头像
        UIImageView *headPortrait = [[UIImageView alloc] init];
        [self.contentView addSubview:headPortrait];
        self.headPortraitIV = headPortrait;
        
        //车队画报
        UIImageView *pictorial = [[UIImageView alloc] init];
        pictorial.layer.borderWidth = 0.5;
        [self.contentView addSubview:pictorial];
        self.pictorialIV = pictorial;
        
        //车队详细介绍
        UILabel *activityInfo = [[UILabel alloc] init];
        activityInfo.font = [UIFont systemFontOfSize:16];
        activityInfo.numberOfLines = 0;
        [self.contentView addSubview:activityInfo];
        self.activityInfoIV = activityInfo;
        
        //底部填充
        UIView *fill = [[UIView alloc] init];
        fill.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:fill];
        self.fillView = fill;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCellDateAndFram:(SquareModel *)model
{
    [self settingData:model];
    [self settingFrame:model];
}

-(void)settingData:(SquareModel *)model
{
    _confNameTV.text = model.confName;
    _userLabel.text = model.user;
    _activityInfoIV.text = model.activityInfo;
    
    //获取团队创建者的头像
    NSString *headFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.headPortrait]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:headFilePath]) {
        _headPortraitIV.image = [UIImage imageWithContentsOfFile:headFilePath];

    } else { //本地不存在头像就从网络上下载
        if (!_cellDataDL) {
            _cellDataDL = [[SquareCellDataDL alloc] init];
            _cellDataDL.downloadDelegate = self;
        }
        
        [_cellDataDL downloadPictureWithTypeName:HeadPicture downloadURL:model.headPortraitURL fileName:model.headPortrait];
    }
    
    //获取团队海报
    NSString *pictorialFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.pictorial]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pictorialFilePath]) {
        _pictorialIV.image = [UIImage imageWithContentsOfFile:pictorialFilePath];
        
    } else { //本地不存在海报就从网络上下载
        if (!_cellDataDL) {
            _cellDataDL = [[SquareCellDataDL alloc] init];
            _cellDataDL.downloadDelegate = self;
        }
        
        [_cellDataDL downloadPictureWithTypeName:Pictorial downloadURL:model.pictorialURL fileName:model.pictorial];
    }
    
    //NSLog(@"头像名:%@,海报名:%@",model.headPortrait,model.pictorial);
}

-(void)settingFrame:(SquareModel *)model
{
    CGFloat padding = 10;

    _confNameTV.frame = CGRectMake(padding, padding, screenW/3, screenW/7);
    
    _userLabel.frame = CGRectMake(padding+_confNameTV.frame.size.width, padding, screenW-padding-_confNameTV.frame.size.width-screenW/7-padding, screenW/7);
    
    _headPortraitIV.frame = CGRectMake(screenW - screenW/7 -padding, padding, screenW/7, screenW/7);
    
    _pictorialIV.frame = CGRectMake(padding, _headPortraitIV.frame.origin.y+_headPortraitIV.frame.size.height+padding, screenW/3, screenW/3);
    
    CGSize textSize = [self sizeWithString:model.activityInfo font:activityInfoFont maxSize:CGSizeMake(screenW/3 - padding*3, screenH/2)];
    _activityInfoIV.frame = CGRectMake(_pictorialIV.frame.origin.x+_pictorialIV.frame.size.width+padding, _pictorialIV.frame.origin.y, screenW*2/3 - padding*3, textSize.height);
    
    if (_pictorialIV.frame.size.height >= _activityInfoIV.frame.size.height) {
        _fillView.frame = CGRectMake(0, _pictorialIV.frame.origin.y+_pictorialIV.frame.size.height + padding, screenW, 20);
        
    } else {
        _fillView.frame = CGRectMake(0, _activityInfoIV.frame.origin.y+_activityInfoIV.frame.size.height + padding, screenW, 20);
    }

//    CGFloat height = CGRectGetMaxY(_fillView.frame);
//    NSLog(@"height=%f",height);
}

-(CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    //如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    //如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    return size;
}

#pragma mark - cellDataDownloadDelegate
-(void)completeDownloadingHeadPortrait:(NSString *)fileName
{
    NSString *headFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:headFilePath]) {
            _headPortraitIV.image = [UIImage imageWithContentsOfFile:headFilePath];
        }
    });
}

-(void)completeDownloadingPictorial:(NSString *)fileName
{
    NSString *pictorialFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:pictorialFilePath]) {
            _pictorialIV.image = [UIImage imageWithContentsOfFile:pictorialFilePath];
        }
    });
}
@end
