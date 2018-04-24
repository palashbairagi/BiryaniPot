//
//  SelectTimeViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "SelectTimeViewController.h"

@interface SelectTimeViewController ()

@end

@implementation SelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yesButton.layer.cornerRadius = 5;
    self.yesButton.layer.borderWidth = 1;
    self.yesButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 80, 30);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.yesButton layer] addSublayer:gradient1];
    
    _timeArray = [[NSMutableArray alloc]init];
    
    for (int i=1; i<25; i++)
    {
        [_timeArray addObject:[NSString stringWithFormat:@"%d", i*5]];
    }
}

- (IBAction)noButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)yesButtonClicked:(id)sender
{
    NSString *estimatedTime = [NSString stringWithFormat:@"%@",_timeArray[[_timePicker selectedRowInComponent:0]]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?order_id=%@&order_type_id=%@&est_time=%@", Constants.UPDATE_ESTIMATED_TIME_URL, _order.orderNo, _order.deliveryType, estimatedTime]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate getAllOrders];
            [self dismissViewControllerAnimated:YES completion:nil];
            [_delegate.queueTableView reloadData];
            [_delegate.preparingTableView reloadData];
        });
    }];
    [postDataTask resume];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 24;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _timeArray[row];
}
@end
