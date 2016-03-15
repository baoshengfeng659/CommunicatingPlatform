//
//  LoginViewController.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/5.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"

@interface LoginViewController ()
@property (strong, nonatomic) LoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customInit];
}

-(void)customInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginView = [[LoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_loginView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
