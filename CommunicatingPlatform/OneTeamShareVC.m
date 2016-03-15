//
//  OneTeamShareVC.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/11.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "OneTeamShareVC.h"
#import "HTTPRequestForFirst.h"
#import "MJRefresh.h"
#import "TeamShareModelManager.h"
#import "TeamShareCell.h"
#import "ShareDetailVC.h"

@interface OneTeamShareVC () <httpRequestDelegate>
{
    NSInteger _upOrDownflashFlag;        //1表示下拉刷新，2表示上拉刷新
}

@property (strong, nonatomic) HTTPRequestForFirst *httpRequest;
@property (strong, nonatomic) TeamShareModelManager *modelManager;

@end

@implementation OneTeamShareVC

static NSString *const reuseIdentifier = @"teamShareCellResing";

+ (OneTeamShareVC *)createOneTeamShareVC
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2 - 5 - 2.5;
    CGFloat height = width*3/2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =  CGSizeMake(width, height); //设置每个格子的尺寸
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5); //设置整个collectionView的内边距(上左下右)
    layout.minimumLineSpacing = 5; //设置每一行之间的间距
    layout.minimumInteritemSpacing = 5; //设置同行中控件的水平间距
    //layout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);

    OneTeamShareVC *teamShareVC = [[OneTeamShareVC alloc] initWithCollectionViewLayout:layout];
    
    return teamShareVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInit];
}

-(void)customInit
{
    [self.collectionView registerClass:[TeamShareCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    _modelManager = [[TeamShareModelManager alloc] init];
    
    _upOrDownflashFlag = 0;

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
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh)];
    
    [self.collectionView.header beginRefreshing];
}

-(void)footerRefreshing
{
    self.collectionView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpRefresh)];
}

//下拉刷新
-(void)pullDownRefresh
{
    if (!self.httpRequest) {
        self.httpRequest = [[HTTPRequestForFirst alloc] init];
        self.httpRequest.requestDelegate = self;
    }
    
    [_httpRequest getSharesOfOneTeamWithTime:_httpRequest.timeMax_secondL confid:_teamModel.confid ifPullDown:YES];
    _upOrDownflashFlag = 1;
}

//上拉刷新
-(void)pullUpRefresh
{
    //NSLog(@"上拉刷新");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.footer endRefreshing];
    });
    
    
}

-(void)getShareSuccessfully:(NSDictionary *)dict
{
    //NSLog(@"分享：%@",dict);
    
    NSArray *disposedArray = [_httpRequest.reformData reformDataForShareData:[dict objectForKey:@"post"] timeMin:_httpRequest.timeMin_secondtL timeMax:_httpRequest.timeMax_secondL];
    
    if (disposedArray && disposedArray.count > 0) {
        [_modelManager reformRowDataToModel:disposedArray UpOrDownUpdate:_upOrDownflashFlag];
        
        [self.collectionView reloadData];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _modelManager.teamShareModelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setCellDate:[_modelManager.teamShareModelArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareDetailVC *shareDetailVC = [[ShareDetailVC alloc] init];
    shareDetailVC.model = [_modelManager.teamShareModelArr objectAtIndex:indexPath.row];
    shareDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:shareDetailVC animated:YES];
}

#pragma mark - httpRequestDelegate

- (void)successedWithResponse:(NSData *)data tag:(NSString *)tag
{
    //结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    });
    
    NSDictionary *parsedDict = (NSDictionary *)[_httpRequest.reformData jsonSerialization:data];
    
    if (!parsedDict) {
        NSLog(@"对外分享解析服务器返回的数据失败");
        return;
    }
    
    [self getShareSuccessfully:parsedDict];
}

- (void)failledWithError:(NSError *)error
{
    NSLog(@"对外分享获取分享失败:Error:%@",error);
}

@end
