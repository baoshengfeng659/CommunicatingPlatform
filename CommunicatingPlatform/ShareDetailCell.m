//
//  ShareDetailCell.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/13.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "ShareDetailCell.h"
#import "TeamShareModel.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface ShareDetailCell()
@property (assign, nonatomic) NSInteger selectWhichRow;

@end

@implementation ShareDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setFirstCell:(TeamShareModel *)model
{
    //headPortraitName，user，time，imageFileName，content
    UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, screenW/7, screenW/7)];
    
    UILabel *userLabel = [[UILabel alloc] init];
    userLabel.font = [UIFont systemFontOfSize:15];
    userLabel.frame = CGRectMake(headIV.frame.origin.x + headIV.frame.size.width + 10, 5, screenW*4/7, screenW/7/2);
    userLabel.text = model.user;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.frame = CGRectMake(headIV.frame.origin.x + headIV.frame.size.width + 10, CGRectGetMaxY(userLabel.frame), screenW*4/7, screenW/7/2);
    timeLabel.text = model.time;
    
    UIImageView *shareIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(headIV.frame) + 5, screenW - 10, screenW)];
    
    CGFloat height = [self calculateTextHeight:model.content];
    UILabel *contentLB = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(shareIV.frame) + 5, screenW-10, height)];
    contentLB.font = [UIFont systemFontOfSize:20];
    contentLB.text = model.content;
    
    UIView *filledView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLB.frame), screenW, 20)];
    filledView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(filledView.frame);
    self.frame = frame;
    
    //获取发布者头像
    NSString *headFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.headPortraitName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:headFilePath]) {
        headIV.image = [UIImage imageWithContentsOfFile:headFilePath];
        
    } else { //本地不存在
    }
    
    //获取分享图片，如果不存在就下载
    NSString *shareImageFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.imageFileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:shareImageFilePath]) {
        shareIV.image = [UIImage imageWithContentsOfFile:shareImageFilePath];
        
    } else { //本地不存在
    }
    
    [self addSubview:headIV];
    [self addSubview:userLabel];
    [self addSubview:timeLabel];
    [self addSubview:shareIV];
    [self addSubview:contentLB];
    [self addSubview:filledView];
}

- (void)setCommentCell:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath;
{
    self.backgroundColor = [UIColor colorWithRed:1 green:250.0/255 blue:250.0/255 alpha:1];
    
    if ([[dict allKeys]containsObject:@"atUid"]) {
        NSString *atUidStr = [dict objectForKey:@"atUid"];
        NSString *uidStr = [dict objectForKey:@"uid"];
        NSString *contentStr = [dict objectForKey:@"content"];
                
        [self addCommentWithContent:contentStr uid:uidStr atUid:atUidStr atWhichRow:indexPath.row];
    } else {
        NSString *uidStr = [dict objectForKey:@"uid"];
        NSString *contentStr = [dict objectForKey:@"content"];
        
        [self addCommentWithContent:contentStr uid:uidStr atUid:@"" atWhichRow:indexPath.row];
    }
}

-(void)addCommentWithContent:(NSString *)contentStr uid:(NSString *)uidStr atUid:(NSString *)atUidStr atWhichRow:(NSInteger)row
{
    _selectWhichRow = row;
    
    if ([atUidStr isEqualToString:@""]) {
        self.textLabel.text = [NSString stringWithFormat:@"%@: %@",uidStr,contentStr];
    } else {
        self.textLabel.text = [NSString stringWithFormat:@"%@%@%@: %@",uidStr,@"回复",atUidStr,contentStr];
    }
    
    CGSize limitSize = CGSizeMake(self.frame.size.width - self.accessoryView.frame.size.width - 50, 800);
    
    CGSize cellSize = [self.textLabel.text boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textLabel.font} context:nil].size;
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, cellSize.height + 10)];
}

//UITextView高度自适应文本
- (CGFloat)calculateTextHeight:(NSString *)text
{
    CGFloat height = [text boundingRectWithSize:CGSizeMake(screenW-10, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:25],NSFontAttributeName, nil] context:nil].size.height;
    
    return height;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
