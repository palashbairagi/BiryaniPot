//
//  LoginViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "DashboardViewController.h"
#import "Constants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

NSMutableData *mutableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([self.userDefaults objectForKey:@"login_status"] != NULL && [[self.userDefaults objectForKey:@"login_status"] intValue] == 1)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = appDelegate.tabBarController;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)initComponents{
    
    self.username.backgroundColor = [UIColor whiteColor];
    self.username.borderStyle = UITextBorderStyleRoundedRect;
    self.username.layer.cornerRadius = 3;
    self.username.layer.borderWidth = 1;
    self.username.layer.borderColor = [[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] CGColor];
    
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.borderStyle = UITextBorderStyleRoundedRect;
    self.password.layer.cornerRadius = 3;
    self.password.layer.borderWidth = 1;
    self.password.layer.borderColor = [[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1] CGColor];

    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 280, 44);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;[[self.loginButton layer] addSublayer:gradient];
    
}

- (IBAction)loginButtonClicked:(id)sender
{
    [self authenticate];
}

-(void)authenticate
{
    NSURL *url = nil;
    NSMutableURLRequest *request = nil;
    
    NSString *parameter = [NSString stringWithFormat:@"username=%@&password=%@",_username.text, _password.text];
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    url = [NSURL URLWithString:Constants.LOGIN_URL];
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:parameterData];
    
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( connection )
    {
        mutableData = [NSMutableData new];
    }
    else
    {
        NSLog(@"Unable to make connection");
    }
    
}

#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection Failed with %@", error);
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary * loginDictionary = [NSJSONSerialization JSONObjectWithData:mutableData options:0 error:nil];
    
    NSString *isLoginValid = [loginDictionary objectForKey:@"isLoginValid"];
    
    if ([isLoginValid intValue] == 1)
    {
        [self.userDefaults setObject:[loginDictionary objectForKey:@"userName"] forKey:@"user_name"];
        [self.userDefaults setBool:YES forKey:@"login_status"];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = appDelegate.tabBarController;
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Unauthorized Access" message:@"Incorrect Username or Password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (IBAction)forgotPasswordButtonClicked:(id)sender
{
    ForgotPasswordViewController *forgotPasswordVC = [[ForgotPasswordViewController alloc]init];
    forgotPasswordVC.modalPresentationStyle = UIModalPresentationFormSheet;
    forgotPasswordVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    forgotPasswordVC.preferredContentSize = CGSizeMake(400, 230);
    [self presentViewController:forgotPasswordVC animated:YES completion:nil];
}


@end
