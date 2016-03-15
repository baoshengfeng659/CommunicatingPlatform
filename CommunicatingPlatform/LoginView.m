//
//  LoginView.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/5.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "LoginView.h"
#import "HTTPRequestForFourth.h"

@interface LoginView() <UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITextField *userTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *loginBn;
@property (strong, nonatomic) UIButton *forgetPasswordBt;

@property (strong,nonatomic) UITapGestureRecognizer *gesture;

@property (strong, nonatomic) UIAlertView *loginSucessAlertView;

@property (strong, nonatomic) HTTPRequestForFourth *httpRequest;

@end

@implementation LoginView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setView];
    }
    
    return self;
}

-(void)setView
{
    self.backgroundColor = [UIColor colorWithRed:1 green:250/255.0 blue:250/255.0 alpha:1];
    
    _gesture=[[UITapGestureRecognizer alloc]init];
    _gesture.delegate = self;
    [self addGestureRecognizer:_gesture];
    
    _userTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, self.frame.size.width-20, 50)];
    _userTextField.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:1 alpha:1];
    _userTextField.layer.cornerRadius = 8;
    _userTextField.placeholder = @"请输入用户名";
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, self.frame.size.width-20, 50)];
    _passwordTextField.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:1 alpha:1];
    _passwordTextField.layer.cornerRadius = 8;
    _passwordTextField.keyboardType =  UIKeyboardAppearanceDefault;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"请输入密码";
    
    _loginBn = [[UIButton alloc] initWithFrame:CGRectMake(10, 190, 80, 40)];
    [_loginBn setTitle:@"登陆" forState:UIControlStateNormal];
    _loginBn.layer.cornerRadius = 8;
    [_loginBn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginBn addTarget:self action:@selector(loginBnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_loginBn setBackgroundColor:[UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:0.3]];
    [_loginBn setBackgroundImage:[self getClickedBnBackgroundColor] forState:UIControlStateHighlighted];
    
    _forgetPasswordBt = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-90, 190, 80, 40)];
    [_forgetPasswordBt setTitle:@"忘记密码" forState:UIControlStateNormal];
    _forgetPasswordBt.layer.cornerRadius = 8;
    [_forgetPasswordBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_forgetPasswordBt addTarget:self action:@selector(forgetBnClicked) forControlEvents:UIControlEventTouchUpInside];
    _forgetPasswordBt.backgroundColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:0.3];
    [_forgetPasswordBt setBackgroundImage:[self getClickedBnBackgroundColor] forState:UIControlStateHighlighted];
    
    [self addSubview:_passwordTextField];
    [self addSubview:_userTextField];
    [self addSubview:_loginBn];
    [self addSubview:_forgetPasswordBt];
    
    self.loginSucessAlertView = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    self.loginSucessAlertView.delegate = self;
}

-(void)loginBnClicked
{
    if (!_httpRequest) {
        _httpRequest = [[HTTPRequestForFourth alloc] init];
    }
    
    [_httpRequest loginAccountWithUsername:_userTextField.text andPassword:_passwordTextField.text];
}

-(void)forgetBnClicked
{
    
}

-(void)loginSuccessfully
{
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


#pragma mark- UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //若果点击的事文本框架，则屏蔽掉手势
    if ([touch.view isKindOfClass:[UITextField class]]) {
        return NO;
    }

    [_userTextField  resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    return YES;
}

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:_loginSucessAlertView]) {
        [self loginSuccessfully];
    }
}

@end
