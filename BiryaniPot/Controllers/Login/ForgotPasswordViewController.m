//
//  ForgotPasswordViewController.m
//  BiryaniPot
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
    
    [_waitView setHidden:FALSE];
    [_activityIndicator startAnimating];
    
    [super viewDidLoad];
    [self initComponents];
    
    [_activityIndicator stopAnimating];
    [_waitView setHidden:TRUE];
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
    
    [_waitView setHidden:FALSE];
    [_activityIndicator startAnimating];
    
    [self sendPassword];
    
    [_activityIndicator stopAnimating];
    [_waitView setHidden:TRUE];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendPassword
{
    NSString *email = _email.text;
    
    NSString *post = [NSString stringWithFormat:@"username=%@", email];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.FORGOT_PASSWORD_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }];
    [postDataTask resume];
}

@end
