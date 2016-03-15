//
//  FourthSectionCell.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/4.
//  Copyright © 2016年 baoshengfeng. All rights reserved.
//

#import "FourthSectionCell.h"

#define CellRusingID @"fourthSectionCellReuse"

#define screenW [UIScreen mainScreen].bounds.size.width

@interface FourthSectionCell()
@property (weak, nonatomic) UIImageView *cellImageView;
@property (weak, nonatomic) UILabel *cellLabel;

@end

@implementation FourthSectionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    FourthSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellRusingID];
    
    if (!cell) {
        cell = [[FourthSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellRusingID];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.cellImageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:label];
        self.cellLabel = label;
    }
    
    return self;
}

- (void)setCellImage:(UIImage *)image andTitle:(NSString *)title
{
    _cellImageView.frame = CGRectMake(10, 5, screenW/6, screenW/6);
    _cellLabel.frame = CGRectMake(_cellImageView.frame.size.width + 20, 0, screenW - _cellImageView.frame.size.width -50, screenW/6);
    
    _cellImageView.image = image;
    _cellLabel.text = title;
    
    CGRect frame = self.frame;
    frame.size.height = _cellImageView.frame.size.height + 10;
    self.frame = frame;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
