//
//  ForgotPasswordViewController.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/7/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Constants.h"

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
    
    _otpLabel.hidden = TRUE;
}


-(void)sendPassword
{
    @try
    {
        MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];

        NSString *email = _email.text;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?username=%@", Constants.FORGOT_PASSWORD_URL, email]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:postDataTask];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [postDataTask resume];
                });
                
                return;
            }
            
            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [postDataTask resume];
                });
                
                return;
            }
            
            DebugLog(@"%@", resultDictionary);
            
            if ([[resultDictionary objectForKey:@"isValid"] integerValue] == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _sessionId = [resultDictionary objectForKey:@"sessionId"];
                    _otpLabel.hidden = FALSE;
                    _email.text = @"";
                    _email.placeholder = @"Enter One Time Password";
                    [_sendMePassword setTitle:@"Send me Password" forState:UIControlStateNormal];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to send One Time Password"];
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [overlayView dismiss:YES];
            });
            
        }];
        
        [postDataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"ForgotPasswordViewController [sendPassword]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
}

-(void)getPassword
{
    @try
    {
        MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];

        NSString *otp = _email.text;
        NSString *post = [NSString stringWithFormat:@"otp=%@&sessionId=%@", otp, _sessionId];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.GET_PASSWORD_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
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
            
            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", resultDictionary);
            
            if ([[resultDictionary objectForKey:@"isValid"] integerValue] == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _email.text =[NSString stringWithFormat:@"%@", [resultDictionary objectForKey:@"password"]];
                    _otpLabel.text = @"Your Password is";
                    _sendMePassword.hidden = TRUE;
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to get Password"];
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [overlayView dismiss:YES];
            });
            
        }];
        
        [postDataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"ForgotPasswordViewController [getPassword]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMeButtonClicked:(id)sender
{
    if ([Validation isEmpty:_email])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Text Field should not be Empty"];
        return;
    }
    
    if(_sessionId == NULL)
    {
        [self sendPassword];
    }
    else
    {
        [self getPassword];
    }
   
}

@end
