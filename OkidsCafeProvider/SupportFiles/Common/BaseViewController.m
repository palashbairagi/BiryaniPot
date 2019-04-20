//
//  BaseViewController.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/11/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "BaseViewController.h"
#import "AdminitrationViewController.h"
#import "MyProfileViewController.h"
#import "Constants.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.topItem.title = [self getLocationName];

    UIBarButtonItem * logout = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonClicked:)];
    logout.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem * setting = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonClicked:)];
    setting.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem * myProfile = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile"] style:UIBarButtonItemStylePlain target:self action:@selector(myProfileButtonClicked:)];
    myProfile.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: logout, setting, myProfile, nil]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:253.0/255.0 green:205.0/255.0 blue:25.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:216.0/255.0 green:33.0/255.0 blue:42.0/255.0 alpha:1];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   // self.navigationController.navigationBar.topItem.title = [self getLocationName];
}

-(NSString *) getLocationName
{
    NSError *error = nil;
    NSURL *addressURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?location_id=%@",Constants.GET_LOCATION_DETAILS, Constants.LOCATION_ID]];
    
    NSData *responseJSONData = [NSData dataWithContentsOfURL:addressURL options:kNilOptions error:&error];
    if (error != nil)
    {
        return @"";
    }
    
    NSDictionary *addressDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    if (error != nil)
    {
        return @"";
    }
    
    //NSString *houseNumber = [[addressDictionary objectForKey:@"address"] objectForKey:@"houseNumber"];
    //NSString *streetName = [[addressDictionary objectForKey:@"address"] objectForKey:@"streetName"];
   // NSString *city = [[addressDictionary objectForKey:@"address"] objectForKey:@"city"];
   // NSString *state = [[[addressDictionary  objectForKey:@"address"]objectForKey:@"state"] objectForKey:@"stateName"];
    
    //return [NSString stringWithFormat:@"%@, %@", streetName, city];
    return [addressDictionary objectForKey:@"locationName"];
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
    [appDelegate.userDefaults removeObjectForKey:@"organizationId"];
    [appDelegate.userDefaults removeObjectForKey:@"accessToken"];
    [appDelegate.userDefaults removeObjectForKey:@"menuId"];
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
