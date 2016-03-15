//
//  CPMainController.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 15/10/27.
//  Copyright (c) 2015年 baoshengfeng. All rights reserved.
//

#import "CPMainController.h"
#import "FirstSectionRootController.h"
#import "SecondSectionRootController.h"
#import "ThirdSectionRootController.h"
#import "FourthSectionRootController.h"
#import "LoginAndRegisterVC.h"

#define FirstSectionName @"动态"
#define SecondSectionName @"关注"
#define ThirdSectionName @"快秀"
#define FourthSectionName @"我的"

#define NumberOfSection 4

#define ChangeTabBarNotification @"changeViewControllersOfTabBar"

@interface CPMainController ()
@property (strong ,nonatomic) FirstSectionRootController *firstVC;
@property (strong ,nonatomic) SecondSectionRootController *secondVC;
@property (strong ,nonatomic) ThirdSectionRootController *thirdVC;
@property (strong ,nonatomic) FourthSectionRootController *fourthVC;

@end

@implementation CPMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllChildViewController];
}

-(void)setUpAllChildViewController
{
    _firstVC = [[FirstSectionRootController alloc] init];
    [self setUpOneChildViewController:_firstVC imageInTabBar:nil titleInTabBar:FirstSectionName titleInNav:FirstSectionName imageOfNavBackground:nil];
    
    _secondVC = [[SecondSectionRootController alloc] init];

    _thirdVC = [[ThirdSectionRootController alloc] init];
    
    _fourthVC = [[FourthSectionRootController alloc] init];
    
    
    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];

    if (user) {
        [self setUpOneChildViewController:_secondVC imageInTabBar:nil titleInTabBar:SecondSectionName titleInNav:SecondSectionName imageOfNavBackground:nil];

        [self setUpOneChildViewController:_thirdVC imageInTabBar:nil titleInTabBar:ThirdSectionName titleInNav:ThirdSectionName imageOfNavBackground:nil];
        
        [self setUpOneChildViewController:_fourthVC imageInTabBar:nil titleInTabBar:FourthSectionName titleInNav:FourthSectionName imageOfNavBackground:nil];
        
    } else {
        LoginAndRegisterVC *VC_2 = [[LoginAndRegisterVC alloc] init];
        [self setUpOneChildViewController:VC_2 imageInTabBar:nil titleInTabBar:SecondSectionName titleInNav:SecondSectionName imageOfNavBackground:nil];

        LoginAndRegisterVC *VC_3 = [[LoginAndRegisterVC alloc] init];
        [self setUpOneChildViewController:VC_3 imageInTabBar:nil titleInTabBar:ThirdSectionName titleInNav:ThirdSectionName imageOfNavBackground:nil];
        
        LoginAndRegisterVC *VC_4 = [[LoginAndRegisterVC alloc] init];
        [self setUpOneChildViewController:VC_4 imageInTabBar:nil titleInTabBar:FourthSectionName titleInNav:FourthSectionName imageOfNavBackground:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewControllersOfTabBar) name:ChangeTabBarNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpOneChildViewController:(UIViewController *)vc imageInTabBar:(UIImage *)tabImage titleInTabBar:(NSString *)tabTitle titleInNav:(NSString *)navTitle imageOfNavBackground:(UIImage *)navBGimage
{
    //创建一个导航控制器
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    //tabBar处显示的图片,图片渲染处理
    if (tabImage) {
        navC.tabBarItem.image = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    //导航标题(显示在navC.tabBarItem下面)
    if (tabTitle) {
        navC.title = tabTitle;
    }
    
    //导航处的背景
    if (navBGimage) {
        [navC.navigationBar setBackgroundImage:navBGimage forBarMetrics:UIBarMetricsDefault];
    }
    
    //试图控制器标题(显示在导航中间处)
    if (navTitle) {
        vc.navigationItem.title = navTitle;
    }
    
    //把导航控制器加入到UITabBarController
    [self addChildViewController:navC];
}

-(UINavigationController *)changeOneChildViewController:(UIViewController *)vc imageInTabBar:(UIImage *)tabImage titleInTabBar:(NSString *)tabTitle titleInNav:(NSString *)navTitle imageOfNavBackground:(UIImage *)navBGimage
{
    //创建一个导航控制器
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    //tabBar处显示的图片,图片渲染处理
    if (tabImage) {
        navC.tabBarItem.image = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    //导航标题(显示在navC.tabBarItem下面)
    if (tabTitle) {
        navC.title = tabTitle;
    }
    
    //导航处的背景
    if (navBGimage) {
        [navC.navigationBar setBackgroundImage:navBGimage forBarMetrics:UIBarMetricsDefault];
    }
    
    //试图控制器标题(显示在导航中间处)
    if (navTitle) {
        vc.navigationItem.title = navTitle;
    }
    
    return navC;
}

-(void)changeViewControllersOfTabBar
{
    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];

    if (!user) {
        NSMutableArray *array = (NSMutableArray *)self.viewControllers;
        
        for (int i = 0 ;i < 3; i++)
            [array removeLastObject];
        
        LoginAndRegisterVC *VC_2 = [[LoginAndRegisterVC alloc] init];
        LoginAndRegisterVC *VC_3 = [[LoginAndRegisterVC alloc] init];
        LoginAndRegisterVC *VC_4 = [[LoginAndRegisterVC alloc] init];
        
        [array insertObject:[self changeOneChildViewController:VC_2 imageInTabBar:nil titleInTabBar:SecondSectionName titleInNav:SecondSectionName imageOfNavBackground:nil] atIndex:1];
        [array insertObject:[self changeOneChildViewController:VC_3 imageInTabBar:nil titleInTabBar:ThirdSectionName titleInNav:ThirdSectionName imageOfNavBackground:nil] atIndex:2];
        [array insertObject:[self changeOneChildViewController:VC_4 imageInTabBar:nil titleInTabBar:FourthSectionName titleInNav:FourthSectionName imageOfNavBackground:nil] atIndex:3];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewControllers = array;
        });
        
    } else {
        NSMutableArray *array = (NSMutableArray *)self.viewControllers;
        
        for (int i = 0 ;i < 3; i++)
            [array removeLastObject];
        
        [array insertObject:[self changeOneChildViewController:_secondVC imageInTabBar:nil titleInTabBar:SecondSectionName titleInNav:SecondSectionName imageOfNavBackground:nil] atIndex:1];
        
        [array insertObject:[self changeOneChildViewController:_thirdVC imageInTabBar:nil titleInTabBar:ThirdSectionName titleInNav:ThirdSectionName imageOfNavBackground:nil] atIndex:2];
        
        [array insertObject:[self changeOneChildViewController:_fourthVC imageInTabBar:nil titleInTabBar:FourthSectionName titleInNav:FourthSectionName imageOfNavBackground:nil] atIndex:3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewControllers = array;
        });
    }
}


//#pragma mark - UITabBarControllerDelegate
//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
//    
//    if ([viewController isEqual:[self.viewControllers objectAtIndex:3]])
//    {
//        if (!user) {
//            NSMutableArray *array = (NSMutableArray *)self.viewControllers;
//            [array removeObjectAtIndex:3];
//            [array insertObject:[self changeOneChildViewController:_loginVC imageInTabBar:nil titleInTabBar:FourthSectionName titleInNav:FourthSectionName imageOfNavBackground:nil] atIndex:3];
//            self.viewControllers = array;
//            
//        } else {
//            UINavigationController *navi = (UINavigationController *)viewController;
//            
//            if (![[navi.viewControllers objectAtIndex:3] isKindOfClass:[FourthSectionRootController class]])
//            {
//                NSMutableArray *array = (NSMutableArray *)self.viewControllers;
//                [array removeObjectAtIndex:3];
//                [array insertObject:[self changeOneChildViewController:_fourthVC imageInTabBar:nil titleInTabBar:FourthSectionName titleInNav:FourthSectionName imageOfNavBackground:nil] atIndex:3];
//                self.viewControllers = array;
//            }
//        }
//    }
//}
//
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    UIViewController *VC = tabBarController.selectedViewController;
//    
//    if ([VC isEqual:viewController]) {
//        return NO;
//    }
//    return YES;
//}
@end
