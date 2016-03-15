//
//  LoginAndRegisterVC.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/5.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "LoginAndRegisterVC.h"
#import "LoginViewController.h"

@interface LoginAndRegisterVC ()
@property (strong, nonatomic) UIButton *loginBn;
@property (strong, nonatomic) UIButton *registerBn;

@end

@implementation LoginAndRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customInit];
}

-(void)customInit
{
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:1 alpha:1];
    
    _loginBn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.center.y-70, self.view.frame.size.width-40, 50)];
    _loginBn.layer.cornerRadius = 10;
    [_loginBn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loginBn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_loginBn addTarget:self action:@selector(loginBnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_loginBn setBackgroundColor:[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1]];//135 206 250
    [_loginBn setBackgroundImage:[self getClickedBnBackgroundColor] forState:UIControlStateHighlighted];
    
    _registerBn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.center.y+20, self.view.frame.size.width-40, 50)];
    _registerBn.layer.cornerRadius = 10;
    [_registerBn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _registerBn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_registerBn addTarget:self action:@selector(registerBnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_registerBn setBackgroundColor:[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1]];//135 206 250
    [_registerBn setBackgroundImage:[self getClickedBnBackgroundColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:_loginBn];
    [self.view addSubview:_registerBn];
}

-(void)loginBnClicked
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)registerBnClicked
{
    [[[UIAlertView alloc]initWithTitle:@"暂不支持注册" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(UIImage *)getClickedBnBackgroundColor
{
    
    CGRect rect = CGRectMake(0, 0, _loginBn.frame.size.width, _loginBn.frame.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.5 alpha:0.5].CGColor);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10] addClip];
    
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
