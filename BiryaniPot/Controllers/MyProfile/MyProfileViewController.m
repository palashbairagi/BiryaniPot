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
    
    [self getManagers];
}

- (IBAction)updateButtonClicked:(id)sender
{
    if([self isValidate])
    {
        [self updateUser];
        
        if([_checkButtonStatus isEqualToString:@"Checked"])
        {
            [self changePassword];
        }
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self getManagers];
    _password.text = @"";
    _confirmPassword.text = @"";
    _currentPassword.text = @"";
}

-(void)getManagers
{
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSURL *managerURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=%@",Constants.GET_MANAGER_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:managerURL];
    NSError *error = nil;
    NSDictionary *managersDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for (NSDictionary *managerDictionary in managersDictionary)
    {
        @try
        {
            
            _user = [[User alloc]init];
            _user.userId = [NSString stringWithFormat:@"%@", [managerDictionary objectForKey:@"managerId"]];
            NSString *userId = [NSString stringWithFormat:@"%@", [_appDelegate.userDefaults objectForKey:@"userId"]];
            
            if([_user.userId isEqualToString:userId])
            {
                _user.name = [managerDictionary objectForKey:@"managerName"];
                _user.role = [[managerDictionary objectForKeyedSubscript:@"role"] objectForKey:@"typeName"];
                _user.mobile = [managerDictionary objectForKey:@"managerMobile"];
                _user.phone = @"";
                _user.email = [managerDictionary objectForKey:@"managerEmail"];
                _user.profilePictureURL = [managerDictionary objectForKey:@"imageURL"];
                
                [self setData];
                break;
            }
            
        }
        @catch(NSException *ex)
        {
            NSLog(@"%@ %@", ex.name, ex.reason);
        }
    }
}

-(void)setData
{
    _name.text = _user.name;
    _role.text = _user.role;
    _mobile.text = _user.mobile;
    _email.text = _user.email;
    
    _profilePictureQueue = [[NSOperationQueue alloc] init];
    
    if (_user.profilePicture == nil )
    {
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            UIImage * image = [UIImage imageNamed:@"dp"];
            NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_user.profilePictureURL]];
            
            if (imgData != NULL)
            {
                image = [UIImage imageWithData:imgData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_profilePicture setImage:image];
            });
            
        }];
        
        [_profilePictureQueue addOperation:op];
    }
    else
    {
        _profilePicture.image = _user.profilePicture;
    }
}

-(void)updateUser
{
    NSString *post = [NSString stringWithFormat:@"manager_id=%@&mobile=%@", _user.userId, _mobile.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_PROFILE]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }];
    
    [postDataTask resume];
}

-(void)changePassword
{
    NSString *post = [NSString stringWithFormat:@"managerEmail=%@&oldpassword=%@&newpassword=%@", _user.email, _currentPassword.text, _password.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.CHANGE_PASSWORD]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSDictionary *message = [result objectForKey:@"error"];
        
        if ([[message objectForKey:@"message"] isEqualToString:@"Successfully changed."])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Successful" andMessage:@"Password Change"];
        }
        else
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Incorrect Current Password"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _currentPassword.text = @"";
            _password.text = @"";
            _confirmPassword.text = @"";
        });
        
    }];
    
    [postDataTask resume];
}

- (IBAction)checkButtonClicked:(id)sender
{
    if ([_checkButtonStatus isEqualToString:@"UnChecked"])
    {
        _checkButton.backgroundColor = [UIColor colorWithRed:0.0 green:100.0/256 blue:1.0 alpha:1.0];
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
