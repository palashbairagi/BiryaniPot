//
//  MyProfileViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/26/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.updateButton.layer.cornerRadius = 5;
    self.updateButton.layer.borderWidth = 1;
    self.updateButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 100, 40);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.updateButton layer] addSublayer:gradient1];
    
    [_checkButton setTitle:[NSString stringWithFormat:@"%C", 0xf00c] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"My Profile";
    self.navigationItem.backBarButtonItem = backButton;
    
    _checkButton.backgroundColor = [UIColor whiteColor];
    _checkButtonStatus = @"UnChecked";
    [_currentPassword setEnabled:false];
    [_password setEnabled:false];
    [_confirmPassword setEnabled:false];
    
    [self getProfile];
}

- (IBAction)updateButtonClicked:(id)sender {
    [self isValidate];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self getProfile];
}

-(void)getProfile
{
    NSURL *profileURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?access_token=abcdpop" ,Constants.GET_MY_PROFILE_URL]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:profileURL];
    NSError *error = nil;
    NSDictionary *profileDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    @try
    {
        _name.text = [profileDictionary objectForKey:@"name"];
        _email.text = [profileDictionary objectForKey:@"email"];
        _mobile.text = [profileDictionary objectForKey:@"phone"];
    }
    @catch(NSException *ex)
    {
        NSLog(@"%@ %@", ex.name, ex.reason);
    }
}

- (IBAction)checkButtonClicked:(id)sender
{
    if ([_checkButtonStatus isEqualToString:@"UnChecked"])
    {
        _checkButton.backgroundColor = [UIColor colorWithRed:0.0 green:100/256 blue:1.0 alpha:1.0];
        _checkButtonStatus = @"Checked";
        [_currentPassword setEnabled:true];
        [_password setEnabled:true];
        [_confirmPassword setEnabled:true];
    }
    else
    {
        _checkButton.backgroundColor = [UIColor whiteColor];
        _checkButtonStatus = @"UnChecked";
        [_currentPassword setEnabled:false];
        [_password setEnabled:false];
        [_confirmPassword setEnabled:false];
        _currentPassword.text = @"";
        _confirmPassword.text = @"";
        _password.text = @"";
    }
}

-(BOOL)isValidate{
    
    [_mobile resignFirstResponder];
    [_phone resignFirstResponder];
    [_email resignFirstResponder];
    
    if([Validation isEmpty:_mobile])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Mobile Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_mobile thanMinLength:10] || [Validation isMore:_mobile thanMaxLength:10])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Mobile Field should exactly equals to 10 digits"];
        return false;
    }
    if ([Validation isNumber:_mobile])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Mobile Field should contain numeric value"];
        return false;
    }
    
    if([Validation isEmpty:_phone])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_phone thanMinLength:10] || [Validation isMore:_phone thanMaxLength:10])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone Field should exactly equals to 10 digits"];
        return false;
    }
    if ([Validation isNumber:_phone])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone Field should contain numeric value"];
        return false;
    }
    
    if([Validation isEmpty:_email])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Email Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_email thanMinLength:10])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Email Field should not be less than 10 characters"];
        return false;
    }
    if ([Validation isMore:_email thanMaxLength:50])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Email Field should not exceed 50 characters"];
        return false;
    }
    if ([Validation isEmail:_email])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Invalid Email"];
        return false;
    }
    
    if ([_checkButtonStatus isEqualToString:@"Checked"])
    {
        [_currentPassword resignFirstResponder];
        [_password resignFirstResponder];
        [_confirmPassword resignFirstResponder];
        
        if ([Validation isEmpty:_currentPassword])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Current Password Field should not be empty"];
            return false;
        }
        
        if ([Validation isEmpty:_password])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Password Field should not be empty"];
            return false;
        }
        if ([Validation isMore:_password thanMaxLength:20])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Password Field should not be more than 20 characters"];
            return false;
        }
        
        if ([Validation isEmpty:_confirmPassword])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Confirm Password Field should not be empty"];
            return false;
        }
        if ([Validation isMore:_confirmPassword thanMaxLength:20])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Confirm Password Field should not be more than 20 characters"];
            return false;
        }
        
        if (![[Validation trim:_password.text] isEqualToString:[Validation trim:_confirmPassword.text]])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Confirm Password should match Password Field"];
            return false;
        }
    }
    
    return true;
}

@end
