//
//  FirstSectionRootController.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/10/28.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import "FirstSectionRootController.h"
#import "SquareViewCell.h"
#import "MJRefresh.h"
#import "HTTPRequestForFirst.h"
#import "SquareModelManager.h"
#import "OneTeamShareVC.h"

#define SquareCellReusing @"squareCellReusing"

@interface FirstSectionRootController () <httpRequestDelegate>
{
    int _upOrDownflashFlag;                                     //1表示下拉刷新，2表示上拉刷新
}
@property (strong, nonatomic) HTTPRequestForFirst *httpRequest;
@property (strong, nonatomic) SquareModelManager *modelManager;

@end

@implementation FirstSectionRootController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self squareCustomInit];
}

-(void)squareCustomInit
{
    [self.tableView registerClass:[SquareViewCell class] forCellReuseIdentifier:SquareCellReusing];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _upOrDownflashFlag = 0;
    
    self.httpRequest = [[HTTPRequestForFirst alloc] init];
    self.httpRequest.requestDelegate = self;
    
    self.modelManager = [[SquareModelManager alloc] init];
    
    [self setUpRefresh];  //配置上拉和下拉刷新
}

-(void)setUpRefresh
{
    //配置下拉刷新
    [self headerRefreshing];
    
    //配置上拉刷新
    [self footerRefreshing];
}

-(void)headerRefreshing
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshLoadNewData)];
    
    [self.tableView.header beginRefreshing];
}

-(void)footerRefreshing
{
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshLoadMoreData)];
}

//下拉刷新
-(void)mjRefreshLoadNewData
{
   // NSLog(@"下拉刷新");
    if (!self.httpRequest) {
        self.httpRequest = [[HTTPRequestForFirst alloc] init];
        self.httpRequest.requestDelegate = self;
    }
    
    [self.httpRequest getGroupWhichHasOpenedShares:_httpRequest.timeMax_firstL ifPullDown:YES];
    _upOrDownflashFlag = 1;
}

//上拉刷新
-(void)mjRefreshLoadMoreData
{
    //NSLog(@"上拉刷新");
    
    if (!self.httpRequest) {
        self.httpRequest = [[HTTPRequestForFirst alloc] init];
        self.httpRequest.requestDelegate = self;
    }
    
    [self.httpRequest getGroupWhichHasOpenedShares:_httpRequest.timeMin_firstL ifPullDown:NO];
    _upOrDownflashFlag = 2;
}

//根据分享时间获取活动群列表
-(void)hasGotGroupsSeparatedByTime:(NSDictionary *)dict
{
    NSMutableArray *disposedArray = [_httpRequest.reformData reformDataForSquareData:dict timeMin:_httpRequest.timeMin_firstL timeMax:_httpRequest.timeMax_firstL];
    
    if (disposedArray && disposedArray.count > 0) {
        [_modelManager reformRowDataToModel:disposedArray UpOrDownUpdate:_upOrDownflashFlag];
        
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _modelManager.squareModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SquareViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SquareCellReusing];
    if (cell == nil) {
        cell = [[SquareViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SquareCellReusing];
    }
    
    [cell setCellDateAndFram:[_modelManager.squareModelArr objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 228.6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneTeamShareVC *teamShareVC = [OneTeamShareVC createOneTeamShareVC];

    teamShareVC.teamModel = [_modelManager.squareModelArr objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:teamShareVC animated:YES];
}

#pragma mark - httpRequestDelegate

-(void)successedWithResponse:(NSData *)data tag:(NSString *)tag
{
    //结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    });
    
    NSDictionary *parsedDict = (NSDictionary *)[_httpRequest.reformData jsonSerialization:data];
    
    if (!parsedDict) {
        return;
    }
    
    NSInteger tagInt = [tag integerValue];
    switch (tagInt) {
        case 0:
            //根据分享时间获取活动群列表
            [self hasGotGroupsSeparatedByTime:parsedDict];
            break;
        default:
            break;
    }
}

-(void)failledWithError:(NSError *)error
{
    NSLog(@"请求失败,error:%@",error);
}

@end
