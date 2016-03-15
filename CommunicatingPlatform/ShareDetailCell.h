//
//  ShareDetailCell.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/13.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TeamShareModel;

@interface ShareDetailCell : UITableViewCell

- (void)setFirstCell:(TeamShareModel *)model;

- (void)setCommentCell:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath;

@end
