//
//  SelectDeliveryPersonViewController.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/22/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "SelectDeliveryPersonViewController.h"
#import "Order.h"
#import "Constants.h"
#import "User.h"

@interface SelectDeliveryPersonViewController ()

@end

@implementation SelectDeliveryPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameArray = [[NSMutableArray alloc]init];
    
    self.selectButton.layer.cornerRadius = 5;
    self.selectButton.layer.borderWidth = 1;
    self.selectButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 80, 30);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.selectButton layer] addSublayer:gradient1];
    
    [self getDeliveryPersons];
}

-(void)getDeliveryPersons
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSURL *deliveryPersonURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=%@",Constants.GET_DELIVERY_PERSON_URL, Constants.LOCATION_ID]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:deliveryPersonURL];
        
        DebugLog(@"Request %@", deliveryPersonURL);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *deliveryPersonsDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", deliveryPersonsDictionary);
        
        for (NSDictionary *deliveryPersonDictionary in deliveryPersonsDictionary)
        {
            
            NSString *dboyId = [deliveryPersonDictionary objectForKey:@"dboyId"];
            NSString *imgURL = [deliveryPersonDictionary objectForKey:@"dboyImgUrl"];
            NSString *dboyMobile = [deliveryPersonDictionary objectForKey:@"dboyMobile"];
            NSString *name = [deliveryPersonDictionary objectForKey:@"dboyName"];
            NSString *isActive = [deliveryPersonDictionary objectForKey:@"isActive"];
            NSString *isAvailable = [deliveryPersonDictionary objectForKey:@"isAvailable"];
            
            if ([isActive intValue] == 1 && [isAvailable intValue] == 1)
            {
                User *user = [[User alloc]init];
                user.userId = dboyId;
                user.name = name;
                user.profilePictureURL = imgURL;
                user.mobile = dboyMobile;
                
                [_nameArray addObject:user];
            }
        }
        
        [overlayView dismiss:YES];
        
    }@catch(NSException *e)
    {
        DebugLog(@"SelectDeliveryPersonViewController [getDeliveryPerson]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(void)assignDeliveryPerson:(User *)user
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        
        NSString *orderNo = _order.orderNo;
        NSString *estTime = _order.timeRemain;
        NSString *dboyId = user.userId;
        
        NSString *post = [NSString stringWithFormat:@"est_time=%@&order_id=%@&deliveryboy_id=%@", estTime, orderNo, dboyId];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", Constants.ASSIGN_DELIVERY_PERSON_URL, post]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
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
            
            NSDictionary *status = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"status %@",status);
            
            if ([[status objectForKey:@"status"] intValue] == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Success" andMessage:@"Delivery Assigned"];
                    [_delegate loadData];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Error" andMessage:@"Unable to assign delivery"];
                    [_delegate loadData];
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [overlayView dismiss:YES];
            });
            
        }];
        
        [postDataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"SelectDeliveryPersonViewController [assignDeliveryPersonViewController]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

- (IBAction)selectButtonClicked:(id)sender
{
    User *user = [_nameArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
    [self assignDeliveryPerson:user];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _nameArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    User *user = _nameArray[row];
    return user.name;
}
@end
