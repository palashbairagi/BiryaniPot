//
//  AppDelegate.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *orderNavigationController;
@property (strong, nonatomic) UINavigationController *dashboardNavigationController;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, retain) LoginViewController *loginViewController;

@end

