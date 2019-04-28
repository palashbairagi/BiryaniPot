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
    
    [self getAppSetting];
    
    if ([_appDelegate.userDefaults objectForKey:@"loginStatus"] != NULL && [[_appDelegate.userDefaults objectForKey:@"loginStatus"] intValue] == 1)
    {
        [self authenticateWithUsername:[_appDelegate.userDefaults objectForKey:@"userName"] andPassword:[_appDelegate.userDefaults objectForKey:@"password"]];
    }
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
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)authenticateWithUsername: (NSString *)username andPassword : (NSString *)password
{
    NSString *organizationId = [Constants ORGANIZATION_ID];
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&organizationid=%@", username, password, organizationId];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.LOGIN_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Login - Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:postDataTask];

            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSDictionary * loginDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", loginDictionary);
            
            long isLoginValid = [[loginDictionary objectForKey:@"isLoginValid"] longValue];
            
            if (isLoginValid == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_appDelegate.userDefaults setObject:[loginDictionary objectForKey:@"locationId"] forKey:@"locationId"];
                    [_appDelegate.userDefaults setObject:[loginDictionary objectForKey:@"userId"] forKey:@"userId"];
                    [_appDelegate.userDefaults setObject:username forKey:@"userName"];
                    [_appDelegate.userDefaults setObject:password forKey:@"password"];
                    [_appDelegate.userDefaults setObject:[loginDictionary objectForKey:@"userRole"] forKey:@"userRole"];
                    [_appDelegate.userDefaults setBool:YES forKey:@"loginStatus"];
                    [_appDelegate.userDefaults setObject:[loginDictionary objectForKey:@"accessToken"] forKey:@"accessToken"];
                    _appDelegate.window.rootViewController = _appDelegate.tabBarController;
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Incorrect Email & Password Combination"];
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [overlayView dismiss:YES];
            });
            
        }];
        [postDataTask resume];
    }
    @catch(NSException *e)
    {
        DebugLog(@"LoginViewController [authenticate]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void) getAppSetting
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.APP_SETTING_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:postDataTask];

            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSDictionary * settingDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", settingDictionary);
            
            [_appDelegate.userDefaults setObject:[settingDictionary objectForKey:@"organizationId"] forKey:@"organizationId"];
            [_appDelegate.userDefaults setObject:[settingDictionary objectForKey:@"menuId"] forKey:@"menuId"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [overlayView dismiss:YES];
            });
            
        }];
        
        [postDataTask resume];
    }
    @catch(NSException *e)
    {
        DebugLog(@"LoginViewController [getAppSetting]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        
    }
}

- (IBAction)loginButtonClicked:(id)sender
{
    if ([Validation isEmpty:_username])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Please enter email"];
        return;
    }
    
    if ([Validation isEmpty:_password])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Please enter password"];
        return;
    }
    
    [self authenticateWithUsername:[Validation trim:_username.text] andPassword:[Validation trim:_password.text]];
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
