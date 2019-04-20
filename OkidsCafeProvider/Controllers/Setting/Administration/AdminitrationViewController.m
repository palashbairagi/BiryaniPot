//
//  AdminitrationViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/6/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "AdminitrationViewController.h"
#import "DashboardViewController.h"
#import "ProfileViewController.h"
#import "UserManagementViewController.h"
#import "OfferViewController.h"
#import "MenuViewController.h"
#import "LandingPagesViewController.h"

@interface AdminitrationViewController ()

@end

@implementation AdminitrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:NO];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"Administration";
    
    self.navigationItem.backBarButtonItem = backButton;
}

- (IBAction)restaurantProfileTapped:(id)sender
{
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    [self.navigationController pushViewController:profileVC animated:NO];
}

- (IBAction)userManagementTapped:(id)sender
{
    UserManagementViewController *userVC = [[UserManagementViewController alloc]init];
    [self.navigationController pushViewController:userVC animated:NO];
}

- (IBAction)offersTapped:(id)sender
{
    OfferViewController *offerVC = [[OfferViewController alloc]init];
    [self.navigationController pushViewController:offerVC animated:NO];
}

- (IBAction)menuTapped:(id)sender
{
    MenuViewController *menuVC = [[MenuViewController alloc]init];
    [self.navigationController pushViewController:menuVC animated:NO];
}

- (IBAction)landingPagesTapped:(id)sender
{
    LandingPagesViewController *landingPagesVC = [[LandingPagesViewController alloc]init];
    [self.navigationController pushViewController:landingPagesVC animated:NO];
}


@end
