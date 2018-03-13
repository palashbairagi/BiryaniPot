//
//  ForgotPasswordViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/7/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
}

-(void) initComponents
{
    self.headerView.layer.borderWidth = 1;
    self.headerView.layer.cornerRadius = 3;
    self.headerView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.headerView.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];
    
    self.email.backgroundColor = [UIColor whiteColor];
    self.email.borderStyle = UITextBorderStyleRoundedRect;
    self.email.layer.cornerRadius = 3;
    self.email.layer.borderWidth = 1;
    self.email.layer.borderColor = [[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] CGColor];
    
    
    self.sendMePassword.layer.cornerRadius = 5;
    self.sendMePassword.layer.borderWidth = 1;
    self.sendMePassword.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 300, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.sendMePassword layer] addSublayer:gradient];
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
