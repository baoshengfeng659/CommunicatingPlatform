//
//  HTTPRequestForFourth.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/5.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPRequestForFourth.h"

#define ChangeTabBarNotification @"changeViewControllersOfTabBar"

#define CreateTeamSucessNF @"createTeamSucessfully"
#define CreateTeamFailNF @"createTeamFailled"

#define BoundaryStr @"--"
#define RandomIDStr @"itcast"

#define USERLOGIN @"http://121.41.102.214/wushan/index.php/user/login"
#define CREAT_TEAM @"http://121.41.102.214/wushan/index.php/user/createConf"
#define JOIN_MYSELF_CREATED_GROUP @"http://121.41.102.214/wushan/index.php/user/manageJoinConfInfo"    //加入群
#define GET_MYSELFCREATED_GROUP @"http://121.41.102.214/wushan/index.php/conf/getUsersConf" //查看用户创建的聊天室


@interface HTTPRequestForFourth()
@property (strong, nonatomic) NSString *myConfid; //保存发布成功的聊天室号，用于设置头像

@end

@implementation HTTPRequestForFourth

//创建团队
-(void)createKYTeam:(NSArray *)infoArray
{
    //取出数据
    NSString *teamName = [infoArray objectAtIndex:0];
    
    UIImage *teamImage = [infoArray objectAtIndex:1];
    
    NSString *teamPlace = [infoArray objectAtIndex:2]; //办公地点(出发地点当办公地点)

    NSDate *teamDate = [infoArray objectAtIndex:3]; //团队成立时间(出发时间)
    NSTimeInterval teamBuildDate = [teamDate timeIntervalSince1970];
    
    NSString *teamInfo = [infoArray objectAtIndex:4];

    NSString *myUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    //NSLog(@"%@,%@,%f,%@,%@",teamName,teamPlace,teamBuildDate,teamInfo,myUid);
    
    NSString *shortconf = @"0"; //0：永久会议 1：短会议
    NSString *maxmember = @"100"; //最大人数限制
    NSString *activityMaxMember = @"100"; //车队召集人数
    NSString *joinPasswd = @"123456";
    NSString *confType = @"1"; //confType=1表示创建活动群

    //设置数据
    NSString *uidStr = [self uploadParameter:@"uid" para:myUid];
    NSString *nameStr = [self uploadParameter:@"confName" para:teamName];
    NSString *placeStr = [self uploadParameter:@"activityDeparture" para:teamPlace];
    NSString *dateStr = [self uploadParameter:@"activityStartTime" para:[NSString stringWithFormat:@"%ld",(long)teamBuildDate] ];
    NSString *infoStr = [self uploadParameter:@"activityInfo" para:teamInfo];
    NSString *pictorialStr = [self uploadFileWithMimeType:@"image/jpg" name:@"pictorial[]" filename:@"pictorialImage.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(teamImage, 0.5);
    NSString *bottomStr = [self bottomString];
    
    NSString *HTTPshortconf = [self uploadParameter:@"shortconf" para:shortconf]; //永久
    NSString *HTTPmaxmember = [self uploadParameter:@"maxmember" para:maxmember]; //房间最大人数
    NSString *HTTPactivityMaxMember = [self uploadParameter:@"activityMaxMember" para:activityMaxMember]; //活动最多人数
    NSString *HTTPjoinPasswd = [self uploadParameter:@"joinPasswd" para:joinPasswd]; //房间密码
    NSString *HTTPconfType = [self uploadParameter:@"confType" para:confType]; //1表示活动群
    
    //设置上传的数据体
    NSMutableData *myRequestData=[[NSMutableData alloc]init];
    [myRequestData appendData:[uidStr dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[nameStr dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[placeStr dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[dateStr dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[HTTPshortconf dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[HTTPmaxmember dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[HTTPjoinPasswd dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[HTTPconfType dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[HTTPactivityMaxMember dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[pictorialStr dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:imageData];
    [myRequestData appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //发送请求，创建团队
    NSString *createTeamStr = [NSString stringWithFormat:CREAT_TEAM];
    
    NSURL *createTeamURL=[NSURL URLWithString:createTeamStr];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:createTeamURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    [request setHTTPBody:myRequestData];
    
    /*设置请求方式*/
    [request setHTTPMethod:@"POST"];
    /*设置Content-Length*/
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)myRequestData.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    /*设置Content-Type*/
    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", RandomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:myRequestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"创建团队失败1");

            [[NSNotificationCenter defaultCenter] postNotificationName:CreateTeamFailNF object:nil];
            
            return ;
        }
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"创建车队情况%@",responseData);
        
        NSString *errorStr = [NSString stringWithFormat:@"%@",(NSString *)[responseData objectForKey:@"error"]];
        
        if ([errorStr isEqualToString:@"0"]) {
            NSLog(@"创建团队成功");
            self.myConfid = (NSString *)[[responseData objectForKey:@"data"]objectForKey:@"confid"];

            //自己加入自己创建的车队
            [self joinActiveGroup:self.myConfid];

            [[NSNotificationCenter defaultCenter] postNotificationName:CreateTeamSucessNF object:nil];
            
        } else {
            NSLog(@"创建团队失败2");
            [[NSNotificationCenter defaultCenter] postNotificationName:CreateTeamFailNF object:nil];
        }
        
    }];
    [uploadTask resume];
    
}


-(void)loginAccountWithUsername:(NSString *)name andPassword:(NSString *)password
{
    NSString *downloadStr = [NSString stringWithFormat:@"%@",USERLOGIN];
    downloadStr = [downloadStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//NSString中如果包括中文字符的话,转为NSURL得到的值为nil。用该方法可以解决解析问题

    NSURL *downloadURL = [NSURL URLWithString:downloadStr];
    
    //NSLog(@"downloadURL=%@",downloadURL);
    
    NSString *requestBody = [NSString stringWithFormat:@"user=%@&password=%@",name,password];
    requestBody = [requestBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downloadURL];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];
    [request setAllHTTPHeaderFields:nil];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"%@",@"登录请求失败");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:nil delegate:nil cancelButtonTitle:@"请检查手机网络" otherButtonTitles:nil];
                [alertView show];
            });
            
            return ;
        }

        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        NSString *errorStr = [NSString stringWithFormat:@"%@",[responseDict objectForKey:@"error"]];
        
        if ([errorStr isEqualToString:@"0"]) {
            //NSLog(@"responseDict = %@",responseDict);
            
            NSDictionary *dict = [responseDict objectForKey:@"data"];
            
            NSString *username = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            NSString *password = [NSString stringWithFormat:@"%@",[dict objectForKey:@"password"]];
            NSString *uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeTabBarNotification object:nil];
            
        } else if ([errorStr isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户名不存在" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            });
            
        } else if ([errorStr isEqualToString:@"2"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码错误" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请从试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            });
        }
    }];
    
    [dataTask resume];
}

-(void)joinActiveGroup:(NSString *)teamConfid
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (!uid) {
        NSLog(@"自己加入自己创建的聊天室出问题：本人uid不存在");
        return;
    }
    
    NSString *requestStr = [NSString stringWithFormat:@"%@?uid=%@&confid=%@&op=%d",JOIN_MYSELF_CREATED_GROUP,uid,teamConfid,1];
    
    NSLog(@"用户加入自己创建的聊天室requestStr = %@",requestStr);
    
    NSURL *url = [NSURL URLWithString:requestStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (connectionError) {
            NSLog(@"加入自己创建的车队，请求错误");
            return ;
        }
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        // NSLog(@"处理申请加入车队接口返回信息：%@",responseData);
        
        if (![[responseData objectForKey:@"error"] isKindOfClass:[NSNull class]])
        {
            NSString *errorStr = [NSString stringWithFormat:@"%@",(NSString *)[responseData objectForKey:@"error"]];
            if ([errorStr isEqualToString:@"0"]) {
                NSLog(@"创建者加入车队成功");
            } else {
                NSLog(@"创建者加入车队失败：error=%@",errorStr);
            }
        }
    }];
}


#pragma mark - 上传格式

-(NSString *)uploadParameter:(NSString *)name para:(NSString *)para
{
    NSMutableString *paraStr = [NSMutableString string];
    
    [paraStr appendFormat:@"%@%@\n",BoundaryStr,RandomIDStr];
    [paraStr appendFormat:@"Content-Disposition: form-data; name=\"%@\"\n\n",name];
    [paraStr appendFormat:@"%@\n",para];
    
    return paraStr;
}

- (NSString *)uploadFileWithMimeType:(NSString *)mimeType name:(NSString *)name filename:(NSString *)filename
{
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendFormat:@"%@%@\n",BoundaryStr,RandomIDStr];
    [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n",name,filename];
    [strM appendFormat:@"Content-Type: %@\n\n",mimeType];
    
    return strM;
}

- (NSString *)bottomString
{
    NSMutableString *bottomStr = [NSMutableString string];
    
    //[bottomStr appendFormat:@"\n%@%@\n",boundaryStr,randomIDStr];//这才是正确的？
    
    [bottomStr appendFormat:@"%@%@\n",BoundaryStr,RandomIDStr];
    [bottomStr appendFormat:@"Content-Disposition: form-data; name=\"submit\"\n\n"];
    [bottomStr appendFormat:@"Submit\n"];
    [bottomStr appendFormat:@"%@%@--\n",BoundaryStr,RandomIDStr];
    
    return bottomStr;
}

@end
