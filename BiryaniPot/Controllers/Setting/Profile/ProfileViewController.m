//
//  LocationViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "ProfileViewController.h"
#import "TimePickerViewController.h"
#import "Constants.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self getProfile];
    [self getTime];
}

-(void)initComponents
{
    self.saveAndCancelView.layer.borderWidth = 1;
    self.saveAndCancelView.layer.cornerRadius = 3;
    self.saveAndCancelView.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];
    
    CGFloat borderWidth = 2;
    
    CALayer *borderL1 = [CALayer layer];
    borderL1.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderL1.frame = CGRectMake(0, self.location.frame.size.height - borderWidth, self.location.frame.size.width, self.location.frame.size.height);
    borderL1.borderWidth = borderWidth;
    self.location.borderStyle = UITextBorderStyleNone;
    [self.location.layer addSublayer:borderL1];
    self.location.layer.masksToBounds = YES;
    
    CALayer *borderAL1 = [CALayer layer];
    borderAL1.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderAL1.frame = CGRectMake(0, self.addressLine1.frame.size.height - borderWidth, self.addressLine1.frame.size.width, self.addressLine1.frame.size.height);
    borderAL1.borderWidth = borderWidth;
    self.addressLine1.borderStyle = UITextBorderStyleNone;
    [self.addressLine1.layer addSublayer:borderAL1];
    self.addressLine1.layer.masksToBounds = YES;
    
    CALayer *borderAL2 = [CALayer layer];
    borderAL2.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderAL2.frame = CGRectMake(0, self.addressLine2.frame.size.height - borderWidth, self.addressLine2.frame.size.width, self.addressLine2.frame.size.height);
    borderAL2.borderWidth = borderWidth;
    self.addressLine2.borderStyle = UITextBorderStyleNone;
    [self.addressLine2.layer addSublayer:borderAL2];
    self.addressLine2.layer.masksToBounds = YES;
    
    CALayer *borderZ = [CALayer layer];
    borderZ.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderZ.frame = CGRectMake(0, self.zip.frame.size.height - borderWidth, self.zip.frame.size.width, self.zip.frame.size.height);
    borderZ.borderWidth = borderWidth;
    self.zip.borderStyle = UITextBorderStyleNone;
    [self.zip.layer addSublayer:borderZ];
    self.zip.layer.masksToBounds = YES;
    
    CALayer *borderC = [CALayer layer];
    borderC.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderC.frame = CGRectMake(0, self.city.frame.size.height - borderWidth, self.city.frame.size.width, self.city.frame.size.height);
    borderC.borderWidth = borderWidth;
    self.city.borderStyle = UITextBorderStyleNone;
    [self.city.layer addSublayer:borderC];
    self.city.layer.masksToBounds = YES;
    
    CALayer *borderS = [CALayer layer];
    borderS.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderS.frame = CGRectMake(0, self.state.frame.size.height - borderWidth, self.state.frame.size.width, self.location.frame.size.height);
    borderS.borderWidth = borderWidth;
    self.state.borderStyle = UITextBorderStyleNone;
    [self.state.layer addSublayer:borderS];
    self.state.layer.masksToBounds = YES;
    
    CALayer *borderP1 = [CALayer layer];
    borderP1.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderP1.frame = CGRectMake(0, self.phone1.frame.size.height - borderWidth, self.phone1.frame.size.width, self.phone1.frame.size.height);
    borderP1.borderWidth = borderWidth;
    self.phone1.borderStyle = UITextBorderStyleNone;
    [self.phone1.layer addSublayer:borderP1];
    self.phone1.layer.masksToBounds = YES;
    
    CALayer *borderP2 = [CALayer layer];
    borderP2.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderP2.frame = CGRectMake(0, self.phone2.frame.size.height - borderWidth, self.phone2.frame.size.width, self.phone2.frame.size.height);
    borderP2.borderWidth = borderWidth;
    self.phone2.borderStyle = UITextBorderStyleNone;
    [self.phone2.layer addSublayer:borderP2];
    self.phone2.layer.masksToBounds = YES;
    
    self.openingHoursHeaderView.layer.cornerRadius = 3;
    self.openingHoursHeaderView.layer.borderWidth = 1;
    self.openingHoursHeaderView.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] CGColor];
    
    self.openingHoursView.layer.cornerRadius = 3;
    self.openingHoursView.layer.borderWidth = 1;
    self.openingHoursView.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] CGColor];
    
    [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradientS = [CAGradientLayer layer];
    gradientS.frame = CGRectMake(0, 0, 100, 40);
    gradientS.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradientS.locations = @[@(0), @(1)];gradientS.startPoint = CGPointMake(0.5, 0);
    gradientS.endPoint = CGPointMake(0.5, 1);
    gradientS.cornerRadius = 5;
    [[self.saveButton layer] addSublayer:gradientS];

    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradientC = [CAGradientLayer layer];
    gradientC.frame = CGRectMake(0, 0, 100, 40);
    gradientC.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradientC.locations = @[@(0), @(1)];gradientC.startPoint = CGPointMake(0.5, 0);
    gradientC.endPoint = CGPointMake(0.5, 1);
    gradientC.cornerRadius = 5;
    [[self.cancelButton layer] addSublayer:gradientC];
    self.cancelButton.tintColor = [UIColor whiteColor];
    
    [self disableAll];
}

- (IBAction)saveButtonClicked:(id)sender
{
    if ([_saveButton.titleLabel.text isEqualToString:@"Edit"])
    {
        [self enableAll];
        [self.saveButton setTitle:@"Update" forState:UIControlStateNormal];
    }
    else
    {
        if ([self isValidate])
        {
            [self disableAll];
            [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
            [self updateProfile];
        }
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self disableAll];
    [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self getProfile];
}

-(void)disableAll
{
    [_location setEnabled:NO];
    [_addressLine1 setEnabled:NO];
    [_addressLine2 setEnabled:NO];
    [_phone1 setEnabled:NO];
    [_phone2 setEnabled:NO];
    [_zip setEnabled:NO];
    [_city setEnabled:NO];
    [_state setEnabled:NO];
    [_cancelButton setEnabled:NO];
    
    self.cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

}

-(void)enableAll
{
    [_location setEnabled:YES];
    [_addressLine1 setEnabled:YES];
    [_addressLine2 setEnabled:YES];
    [_phone1 setEnabled:YES];
    [_phone2 setEnabled:YES];
    [_zip setEnabled:YES];
    [_city setEnabled:YES];
    [_state setEnabled:YES];
    [_cancelButton setEnabled:YES];
    
    self.cancelButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)timeButtonClicked:(id)sender
{
    if ([_saveButton.titleLabel.text isEqualToString:@"Update"])
    {
        TimePickerViewController * timePickerViewController = [[TimePickerViewController alloc]init];
        timePickerViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        timePickerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        timePickerViewController.preferredContentSize = CGSizeMake(400, 450);
        timePickerViewController.buttonClicked = sender;
        timePickerViewController.delegate = self;
        [self presentViewController:timePickerViewController animated:YES completion:nil];
    }
}

-(void)getProfile
{
    NSURL *profileURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=1",Constants.GET_RESTAURANT_PROFILE_URL]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:profileURL];
    NSError *error = nil;
    NSArray *profileDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    @try
    {
        _addressLine1.text = [[profileDictionary objectAtIndex:0] objectForKey:@"address1"];
        _addressLine2.text = [[profileDictionary objectAtIndex:0] objectForKey:@"address2"];
        _city.text = [[profileDictionary objectAtIndex:0] objectForKey:@"city"];
        _location.text = [[profileDictionary objectAtIndex:0] objectForKey:@"locationName"];
        _phone1.text = [[profileDictionary objectAtIndex:0] objectForKey:@"phone1"];
        _phone2.text = [[profileDictionary objectAtIndex:0] objectForKey:@"phone2"];
        _state.text = [NSString stringWithFormat:@"%@", [[[profileDictionary objectAtIndex:0] objectForKey:@"state"] objectForKey:@"stateName"]];
        _zip.text = [NSString stringWithFormat:@"%@", [[profileDictionary objectAtIndex:0] objectForKey:@"zipCode"]];
    }
    @catch(NSException *ex)
    {
        NSLog(@"%@ %@", ex.name, ex.reason);
    }
}

-(void)updateProfile
{
    NSString *location = [NSString stringWithFormat:@"%@", _location.text];
    NSString *address1 = [NSString stringWithFormat:@"%@", _addressLine1.text];
    NSString *address2 = [NSString stringWithFormat:@"%@", _addressLine2.text];
    NSString *city = [NSString stringWithFormat:@"%@", _city.text];
    NSString *zip = [NSString stringWithFormat:@"%@", _zip.text];
    NSString *phone1 = [NSString stringWithFormat:@"%@", _phone1.text];
    NSString *phone2 = [NSString stringWithFormat:@"%@", _phone2.text];
    
    NSString *post = [NSString stringWithFormat:@"loc_id=1&loc_name=%@&address_lane1=%@&address_lane2=%@&zipcode=%@&city=%@&state_id=2&phone1=%@&phone2=%@&is_active=1", location, address1, address2, zip, city, phone1, phone2];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_RESTAURANT_PROFILE_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    [postDataTask resume];
}

-(void)getTime
{
    NSURL *timeURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=1",Constants.GET_RESTAURANT_TIME_URL]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:timeURL];
    NSError *error = nil;
    NSArray *timesArray = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
   
    for (NSDictionary *timeDictionary in timesArray)
    {
        @try
        {
            NSString *day = [timeDictionary objectForKey:@"day"];
            NSString *from = [timeDictionary objectForKey:@"startTime"];
            NSString *to = [timeDictionary objectForKey:@"endTime"];
            
            if ([day isEqualToString:@"Sunday"])
            {
                _sunday.text = day;
                [_sun_from setTitle:from forState:UIControlStateNormal];
                [_sun_to setTitle:to forState:UIControlStateNormal];
            }
            else if ([day isEqualToString:@"Monday"])
            {
                _monday.text = day;
                [_mon_from setTitle:from forState:UIControlStateNormal];
                [_mon_to setTitle:to forState:UIControlStateNormal];
            }
            else if ([day isEqualToString:@"Tuesday"])
            {
                _tuesday.text = day;
                [_tue_from setTitle:from forState:UIControlStateNormal];
                [_tue_to setTitle:to forState:UIControlStateNormal];
            }
            else if ([day isEqualToString:@"Wednesday"])
            {
                _wednesday.text = day;
                [_wed_from setTitle:from forState:UIControlStateNormal];
                [_wed_to setTitle:to forState:UIControlStateNormal];
            }
            else if ([day isEqualToString:@"Thursday"])
            {
                _thursday.text = day;
                [_thu_from setTitle:from forState:UIControlStateNormal];
                [_thu_to setTitle:to forState:UIControlStateNormal];
            }
            else if ([day isEqualToString:@"Friday"])
            {
                _friday.text = day;
                [_fri_from setTitle:from forState:UIControlStateNormal];
                [_fri_to setTitle:to forState:UIControlStateNormal];
            }
            else if ([day isEqualToString:@"Saturday"])
            {
                _saturday.text = day;
                [_sat_from setTitle:from forState:UIControlStateNormal];
                [_sat_to setTitle:to forState:UIControlStateNormal];
            }

        }
        @catch(NSException *ex)
        {
            NSLog(@"%@ %@", ex.name, ex.reason);
        }
    }
}

-(BOOL)isValidate{
    
    [_location resignFirstResponder];
    [_addressLine1 resignFirstResponder];
    [_addressLine2 resignFirstResponder];
    [_zip resignFirstResponder];
    [_city resignFirstResponder];
    [_state resignFirstResponder];
    [_phone1 resignFirstResponder];
    [_phone2 resignFirstResponder];
    
    if([Validation isEmpty:_location])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Location Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_location thanMinLength:3])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Location Field should should not be less than 3 characters"];
        return false;
    }
    if ([Validation isMore:_location thanMaxLength:20])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Location Field should should not be more than 20 characters"];
        return false;
    }
    
    if ([Validation isEmpty:_addressLine1])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Address1 Field should not be empty"];
        return false;
    }
    if ([Validation isMore:_addressLine1 thanMaxLength:50])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Address1 Field should not be more than 50 characters"];
        return false;
    }
    
    if ([Validation isMore:_addressLine2 thanMaxLength:50])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Address2 Field should not be more than 50 characters"];
        return false;
    }
    
    if ([Validation isEmpty:_zip])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Zip Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_zip thanMinLength:5] || [Validation isMore:_zip thanMaxLength:5])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Zip Field should exactly equals to 5 digits"];
        return false;
    }
    if ([Validation isNumber:_zip])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Zip Field should contain numeric value"];
        return false;
    }
    
    if([Validation isEmpty:_city])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"City Field should not be empty"];
        return false;
    }
    if([Validation isMore:_city thanMaxLength:20]) {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"City Field should not be more than 20 characters"];
        return false;
    }
    
    if([Validation isEmpty:_state])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"State Field should not be empty"];
        return false;
    }
    if([Validation isMore:_state thanMaxLength:40]) {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"State Field should not be more than 40 characters"];
        return false;
    }
    
    if([Validation isEmpty:_phone1])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone1 Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_phone1 thanMinLength:10] || [Validation isMore:_phone1 thanMaxLength:10])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone1 Field should exactly equals to 10 digits"];
        return false;
    }
    if ([Validation isNumber:_phone1])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone1 Field should contain numeric value"];
        return false;
    }
    
    if([Validation isEmpty:_phone2])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone2 Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_phone2 thanMinLength:10] || [Validation isMore:_phone2 thanMaxLength:10])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone2 Field should exactly equals to 10 digits"];
        return false;
    }
    if ([Validation isNumber:_phone2])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Phone2 Field should contain numeric value"];
        return false;
    }
    
    return true;
}

@end
