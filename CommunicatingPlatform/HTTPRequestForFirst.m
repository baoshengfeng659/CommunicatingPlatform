//
//  HTTPRequest.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/10/29.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import "HTTPRequestForFirst.h"
#import "AFNetworking.h"

#define TAGZero @"0"
#define GET_ACTIVE_GROUP_BYSHARE @"http://121.41.102.214/wushan/index.php/conf/getConfByShare" //根据分享时间获取活动群列表

#define TAGOne @"1"
#define GET_SHARE_PUBLIC @"http://121.41.102.214/wushan/index.php/post/confOpenShare"   //查看某个群的群外公开列表

#define TAGTwo @"2"
#define GET_COMMENT @"http://121.41.102.214/wushan/index.php/comment/getCommentList"   //获取评论和回复评论

#define TAGThree @"3"
#define PUBLISH_COMMENT @"http://121.41.102.214/wushan/index.php/comment/addComment"   //发表评论

#define BoundaryStr @"--"
#define RandomIDStr @"itcast"

@interface HTTPRequestForFirst() <changeDataDelegate>
{
    NSInteger _upOrDownflashFlag;           //1表示下拉刷新，2表示上拉刷新
}

@end

@implementation HTTPRequestForFirst

-(id)init
{
    self = [super init];
    if (self) {
        _timeMax_firstL = 0;
        _timeMin_firstL = 0;
        _upOrDownflashFlag = 0;
        
        _timeMax_secondL = 0;
        _timeMin_secondtL = 0;
        
        _reformData = [[DataReform alloc] init];
        _reformData.changeDelegate = self;
    }
    
    return self;
}

-(void)getGroupWhichHasOpenedShares:(CGFloat)time ifPullDown:(BOOL)isPullDown
{
    NSURL *requestUrl;
    
    //下拉刷新
    if (isPullDown == YES)
    {
        if (time == 0) {//第一次请求(下拉刷新)
            requestUrl = [NSURL URLWithString:GET_ACTIVE_GROUP_BYSHARE];
            
        } else { //非首次请求的下拉刷新
            requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?endTime=%f&pageSize=5",GET_ACTIVE_GROUP_BYSHARE,time+0.5]];
        }
    }
    
    //上拉刷新
    else
    {
        requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?startTime=%f&pageSize=5",GET_ACTIVE_GROUP_BYSHARE,time-0.5]];
    }

    //NSLog(@"请求url=%@",requestUrl);
    
    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requst completionHandler:^(NSData *data, NSURLResponse *reponse, NSError *error){
        if (!error) {
            [self.requestDelegate successedWithResponse:data tag:TAGZero];
            
        } else {
            NSLog(@"广场刷新请求失败:Error:%@",error);
            
            [self.requestDelegate failledWithError:error];
        }
    }];
    
    [dataTask resume];
}

//获取某个群的群外公开列表
-(void)getSharesOfOneTeamWithTime:(CGFloat)time confid:(NSString *)confid ifPullDown:(BOOL)isPullDown
{
    NSURL *requestUrl;
    
    //下拉刷新
    if (isPullDown == YES)
    {
        if (time == 0) {//第一次请求(下拉刷新)
            requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?confid=%@&pageSize=5",GET_SHARE_PUBLIC,confid]];
            
        } else { //非首次请求的下拉刷新
            requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?confid=%@&endTime=%f&pageSize=5",GET_SHARE_PUBLIC,confid,time+0.5]];
        }

    }
    
    //上拉刷新
    else
    {
        requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?confid=%@&startTime=%f&pageSize=5",GET_SHARE_PUBLIC,confid,time-0.5]];
    }
    
   // NSLog(@"获取群外分享链接：%@",requestUrl);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:requestUrl completionHandler:^(NSData *data,NSURLResponse *response, NSError *error){
        if (!error) {
            [self.requestDelegate successedWithResponse:data tag:TAGZero];
            
        } else {
            NSLog(@"团队对外分享刷新请求失败:Error:%@",error);
            
            [self.requestDelegate failledWithError:error];
        }
    }];
    
    [task resume];
}

//获取评论
-(void)getCommentOfTheShareWithPostId:(NSString *)postId
{
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?postId=%@",GET_COMMENT,postId]];

    NSLog(@"%@",requestUrl);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    NSURLSessionDataTask *task = [session dataTaskWithURL:requestUrl completionHandler:^(NSData *data,NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"获取评论失败(error=1表示没评论),error:%@",error);
            return ;
        }
        
        [self.requestDelegate successedWithResponse:data tag:TAGTwo];
    }];
    
    [task resume];
}

//发表评论
-(void)makeCommentWithUid:(NSString *)uid PostId:(NSString *)postId Content:(NSString *)content
{
    NSString *uidStr = [self uploadParameter:@"uid" para:uid];
    NSString *postIdStr = [self uploadParameter:@"postId" para:postId];
    NSString *contentStr = [self uploadParameter:@"content" para:content];
    NSString *bottomStr = [self bottomString];

    NSMutableData *requestData = [[NSMutableData alloc] init];
    [requestData appendData:[uidStr dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:[postIdStr dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:[contentStr dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *makeCommentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",PUBLISH_COMMENT]];

   // NSLog(@"makeCommentURL == :%@",makeCommentURL);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:makeCommentURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPBody:requestData];

    /*设置请求方式*/
    [request setHTTPMethod:@"POST"];
    /*设置Content-Length*/
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)requestData.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    /*设置Content-Type*/
    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", RandomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"发表评论出错，error:%@",error);
            return ;
        }
        
        NSLog(@"评论成功");
        //[self.requestDelegate successedWithResponse:data tag:TAGThree];
        
    }];
    
    [uploadTask resume];
}

// 上传格式
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


#pragma mark - changeDataDelegate
-(void)changeMaxtimeOrMintime:(double)timeMin andMax:(double)timeMax
{
    _timeMin_firstL = timeMin;
    _timeMax_firstL = timeMax;
}

-(void)teamSharechangeMaxtimeOrMintime:(double)timeMin andMax:(double)timeMax
{
    _timeMin_secondtL = timeMin;
    _timeMax_secondL = timeMax;
}
@end
