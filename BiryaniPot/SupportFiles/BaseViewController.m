//
//  BaseViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/11/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "BaseViewController.h"
#import "AdminitrationViewController.h"
#import "MyProfileViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIBarButtonItem * logout = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonClicked:)];
    logout.tintColor = [UIColor blackColor];
    
    UIBarButtonItem * setting = [[UIBarButtonItem alloc]initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonClicked:)];
    setting.tintColor = [UIColor blackColor];
    
    UIBarButtonItem * myProfile = [[UIBarButtonItem alloc] initWithTitle:@"Hello, Admin" style:UIBarButtonItemStylePlain target:self action:@selector(myProfileButtonClicked:)];
    myProfile.tintColor = [UIColor blackColor];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: logout, setting, myProfile, nil]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:253.0/255.0 green:205.0/255.0 blue:25.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:216.0/255.0 green:33.0/255.0 blue:42.0/255.0 alpha:1];
    
}

-(void)logoutButtonClicked:(UIButton *)sender
{
    [self logout];
}

-(void)logout
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate.userDefaults removeObjectForKey:@"locationId"];
    [appDelegate.userDefaults removeObjectForKey:@"userId"];
    [appDelegate.userDefaults removeObjectForKey:@"userName"];
    [appDelegate.userDefaults removeObjectForKey:@"Password"];
    [appDelegate.userDefaults removeObjectForKey:@"userRole"];
    [appDelegate.userDefaults removeObjectForKey:@"loginStatus"];
    [appDelegate.userDefaults synchronize];
    
    appDelegate.window.rootViewController = appDelegate.loginViewController;
}

-(void)settingButtonClicked:(UIButton *)sender
{
    AdminitrationViewController *adminVC = [[AdminitrationViewController alloc]init];
    [self.navigationController pushViewController:adminVC animated:NO];
}

-(void)myProfileButtonClicked:(UIButton *)sender
{
    MyProfileViewController *profileVC = [[MyProfileViewController alloc]init];
    [self.navigationController pushViewController:profileVC animated:NO];
}

@end
