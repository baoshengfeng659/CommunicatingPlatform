//
//  CreateTeamVC.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/4.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "CreateTeamVC.h"
#import "ViewForCreateTeam.h"

#define CreateTeamSucessNF @"createTeamSucessfully"
#define CreateTeamFailNF @"createTeamFailled"

@interface CreateTeamVC ()<UIAlertViewDelegate>

@property (strong, nonatomic) ViewForCreateTeam *createTeamView;

@property (strong, nonatomic) UIAlertView *backBnAlert;
@property (strong, nonatomic) UIAlertView *createTeamFailAlert;
@property (strong, nonatomic) UIAlertView *createTeamSucessAlert;

@end

@implementation CreateTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customInit];
}

- (void)customInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTeamSucessFully) name:CreateTeamSucessNF object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTeamfailled) name:CreateTeamFailNF object:nil];

    
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBnClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(createTeam)];
    
    _createTeamView = [[ViewForCreateTeam alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_createTeamView];
}

-(void)createTeam
{
    [_createTeamView createMyTeam];
}

-(void)backBnClicked
{
    if (!self.backBnAlert) {
        self.backBnAlert = [[UIAlertView alloc] initWithTitle:@"是否放弃创建团队?" message:nil delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"取消", nil];
    }
    
    [_backBnAlert show];
}

-(void)createTeamSucessFully
{
    if (!_createTeamSucessAlert) {
        _createTeamSucessAlert = [[UIAlertView alloc] initWithTitle:@"创建团队成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [_createTeamSucessAlert show];
    });
}

-(void)createTeamfailled
{
    if (!_createTeamFailAlert) {
        _createTeamFailAlert = [[UIAlertView alloc] initWithTitle:@"创建团队失败" message:@"请重试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_createTeamFailAlert show];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.backBnAlert)
    {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } 
    }
    
    if (alertView == self.createTeamSucessAlert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
