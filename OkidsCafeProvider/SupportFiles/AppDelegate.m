//
//  AppDelegate.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "AppDelegate.h"
#import "DashboardViewController.h"
#import "OrderViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    
     _loginViewController = [[LoginViewController alloc]init];
    
    DashboardViewController *dashboardViewController = [[DashboardViewController alloc]init];
    OrderViewController *orderViewController = [[OrderViewController alloc]init];
    
    _dashboardNavigationController = [[UINavigationController alloc]initWithRootViewController:dashboardViewController];
    _orderNavigationController = [[UINavigationController alloc]initWithRootViewController:orderViewController];
    
    _orderNavigationController.tabBarItem.title = @"ORDER";
    _orderNavigationController.tabBarItem.image = [UIImage imageNamed:@"order"];
    _dashboardNavigationController.tabBarItem.title = @"DASHBOARD";
    _dashboardNavigationController.tabBarItem.image = [UIImage imageNamed:@"dashboard"];
    
    self.tabBarController = [[UITabBarController alloc]init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: _orderNavigationController, _dashboardNavigationController, nil];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:216.0/255.0 green:33.0/255.0 blue:42.0/255.0 alpha:1.0]];
    
    [self.tabBarController.tabBar setBarTintColor: [UIColor colorWithRed:253.0/255.0 green:205.0/255.0 blue:25.0/255.0 alpha:1.0]];
    
//    UIImageView *logoHolder = [[UIImageView alloc] initWithFrame:CGRectMake(60, 3, 120, 40)];
//    UIImage *logo = [UIImage imageNamed:@"biryanipotusa"];
//    logoHolder.image = logo;
//    [self.tabBarController.tabBar addSubview:logoHolder];
//    
//    UITabBarItem* first = [[self.tabBarController.tabBar items] objectAtIndex:0];
//    first.titlePositionAdjustment = UIOffsetMake(110.0, 0.0);
//
//    UITabBarItem* second = [[self.tabBarController.tabBar items] objectAtIndex:1];
//    second.titlePositionAdjustment = UIOffsetMake(-110.0, 0.0);
    
    self.window.rootViewController = _loginViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
