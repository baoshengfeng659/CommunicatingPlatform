//
//  MyTeamViewController.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/4.
//  Copyright © 2016年 baoshengfeng. All rights reserved.
//

#import "MyTeamViewController.h"
#import "CreateTeamVC.h"

#define CreateTeamStr @"创建团队"

@interface MyTeamViewController ()
@property (strong, nonatomic) NSMutableArray *tableList;

@end

@implementation MyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInit];
}

- (void)customInit
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.scrollEnabled = NO;
    
    UIBarButtonItem *rightBn = [[UIBarButtonItem alloc] initWithTitle:CreateTeamStr style:UIBarButtonItemStylePlain target:self action:@selector(createMyTeam)];
    self.navigationItem.rightBarButtonItem = rightBn;
    
    _tableList = [[NSMutableArray alloc] initWithObjects:@"我创建的团队",@"我加入的团队",nil];
}

-(void)createMyTeam
{
    CreateTeamVC *teamCreateVC = [[CreateTeamVC alloc] init];
    
    [self.navigationController pushViewController:teamCreateVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSString *cellTitle = [_tableList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellTitle;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ;
        
    } else if (indexPath.row == 1) {
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    return headView;
}

@end
