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
#import "Validation.h"
#import "AppDelegate.h"


@interface LoginViewController ()

@property (nonatomic) AppDelegate *appDelegate;

@end

@implementation LoginViewController

NSMutableData *mutableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([_appDelegate.userDefaults objectForKey:@"loginStatus"] != NULL && [[_appDelegate.userDefaults objectForKey:@"loginStatus"] intValue] == 1)
    {
        _appDelegate.window.rootViewController = _appDelegate.tabBarController;
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
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", _username.text, _password.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.LOGIN_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary * loginDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSString *isLoginValid = [loginDictionary objectForKey:@"isLoginValid"];
        
        if ([isLoginValid intValue] == 1)
        {
            [_appDelegate.userDefaults setObject:[loginDictionary objectForKey:@"locationId"] forKey:@"locationId"];
            [_appDelegate.userDefaults setObject:[loginDictionary objectForKey:@"userId"] forKey:@"userId"];
            [_appDelegate.userDefaults setObject:[loginDictionary objectForKey:@"userName"] forKey:@"userName"];
            [_appDelegate.userDefaults setObject:[loginDictionary objectForKey:@"userRole"] forKey:@"userRole"];
            [_appDelegate.userDefaults setBool:YES forKey:@"loginStatus"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _appDelegate.window.rootViewController = _appDelegate.tabBarController;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Unable to Login" andMessage:@"Incorrect Username or Password"];
            });
        }
    }];
    [postDataTask resume];
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
