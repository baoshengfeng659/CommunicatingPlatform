//
//  FourthSectionCell.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/4.
//  Copyright © 2016年 baoshengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourthSectionCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//创建团队
- (void)setCellImage:(UIImage *)image andTitle:(NSString *)title;

@end
