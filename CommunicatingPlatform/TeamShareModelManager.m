//
//  TeamShareModelManager.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/12.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "TeamShareModelManager.h"
#import "TeamShareModel.h"

#define HeadNamePrefix @"KYUserHead"
#define ShareImagePrefix @"KYShareImage"
#define PictureSuffix @".jpg"

#define HostAddress @"http://121.41.102.214/wushan"

@implementation TeamShareModelManager

-(id)init
{
    self = [super init];
    if (self) {
        self.teamShareModelArr = [[NSMutableArray alloc] init];
    }
    
    return self;
}


//flag=1表示下啦刷新
-(void)reformRowDataToModel:(NSArray *)array UpOrDownUpdate:(NSInteger)flag
{
   // NSLog(@"array = %@",array);

    for (NSDictionary *dict in array)
    {
        NSString *confid = [dict objectForKeyedSubscript:@"confid"];
        
        NSString *content = [dict objectForKeyedSubscript:@"content"];
        
        NSString *headPortraitName = [NSString stringWithFormat:@"%@%@%@",HeadNamePrefix,[dict objectForKey:@"uid"],PictureSuffix];
        NSString *headPortraitURL = [NSString stringWithFormat:@"%@%@",HostAddress,[dict objectForKey:@"headPortrait"]];

        NSString *imageFileName = [NSString stringWithFormat:@"%@%@%@",ShareImagePrefix,[dict objectForKey:@"postId"],PictureSuffix];
        NSString *imageFileURL = [NSString stringWithFormat:@"%@%@",HostAddress,[dict objectForKey:@"imageFile"]];
        
        NSString *user = [dict objectForKeyedSubscript:@"user"];
        
        NSString *uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
        
        NSString *postId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"postId"]];
        
        NSString *time = [NSString stringWithFormat:@"%@",[dict objectForKey:@"time"]];
        
        NSDictionary *modelDict = [NSDictionary dictionaryWithObjectsAndKeys:confid,@"confid",content,@"content",headPortraitName,@"headPortraitName",headPortraitURL,@"headPortraitURL",imageFileName,@"imageFileName",imageFileURL,@"imageFileURL",user,@"user",uid,@"uid",postId,@"postId",time,@"time",nil];
        
        TeamShareModel *model = [[TeamShareModel alloc] initWithDict:modelDict];

        if (flag == 1) { //下拉刷新
            [_teamShareModelArr insertObject:model atIndex:0];
            
        } else if (flag == 2) { //上拉刷新
            [_teamShareModelArr addObject:model];
        }
    }
}
@end

