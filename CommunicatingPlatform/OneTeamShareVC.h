//
//  OneTeamShareVC.h
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/11.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"

@interface OneTeamShareVC : UICollectionViewController

@property (strong, nonatomic) SquareModel *teamModel;

+ (OneTeamShareVC *)createOneTeamShareVC;

@end
