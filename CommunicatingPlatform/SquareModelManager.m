//
//  SquareModelManager.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/12/29.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import "SquareModelManager.h"
#import "SquareModel.h"

#define HeadNamePrefix @"KYUserHead"
#define PictorialPrefix @"KYPictorial"
#define PictureSuffix @".jpg"

#define HostAddress @"http://121.41.102.214/wushan"

@implementation SquareModelManager

-(id)init
{
    self = [super init];
    if (self) {
        self.squareModelArr = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)reformRowDataToModel:(NSArray *)array UpOrDownUpdate:(NSInteger)flag;
{
    NSString *confid;
    NSString *uid;
    NSString *user;
    NSString *headPortrait;
    NSString *confName;
    NSString *pictorial;
    NSString *activityInfo;
    NSString *headPortraitURL;
    NSString *pictorialURL;
    
    for (NSDictionary *dict in array)
    {
        confid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confid"]];
        uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
        user = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user"]];
        confName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"confName"]];
        activityInfo = [NSString stringWithFormat:@"%@",[dict objectForKey:@"activityInfo"]];
        headPortrait = [NSString stringWithFormat:@"%@%@%@",HeadNamePrefix,[dict objectForKey:@"uid"],PictureSuffix];
        pictorial = [NSString stringWithFormat:@"%@%@%@",PictorialPrefix,[dict objectForKey:@"confid"],PictureSuffix];
        headPortraitURL = [NSString stringWithFormat:@"%@%@",HostAddress,[dict objectForKey:@"headPortrait"]];
        pictorialURL = [NSString stringWithFormat:@"%@%@",HostAddress,[dict objectForKey:@"pictorial"]];
        
        NSDictionary *modelDict = [NSDictionary dictionaryWithObjectsAndKeys:confid,@"confid",uid,@"uid",user,@"user",confName,@"confName",activityInfo,@"activityInfo",headPortrait,@"headPortrait",pictorial,@"pictorial",headPortraitURL,@"headPortraitURL",pictorialURL,@"pictorialURL",nil];
        
        SquareModel *model = [[SquareModel alloc] initWithDict:modelDict];
        
        if (flag == 1) { //下拉刷新
            [_squareModelArr insertObject:model atIndex:0];

        } else if (flag == 2) { //上拉刷新
            [_squareModelArr addObject:model];
        }
       // NSLog(@"%@,%@,%@,%@",model.headPortrait,model.pictorial,model.uid,model.user);
    }
    //NSLog(@"array=%@",array);
}

@end
