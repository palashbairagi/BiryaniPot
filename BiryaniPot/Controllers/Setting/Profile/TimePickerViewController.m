//
//  TimePickerViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/28/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "TimePickerViewController.h"

@interface TimePickerViewController ()

@end

@implementation TimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeFormat = [[NSDateFormatter alloc] init];
    [_timeFormat setDateFormat:@"hh:mm a"];
    [_timePicker setDate:[_timeFormat dateFromString:_buttonClicked.titleLabel.text]];
    
    self.doneButton.layer.cornerRadius = 5;
    self.doneButton.layer.borderWidth = 1;
    self.doneButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 80, 30);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.doneButton layer] addSublayer:gradient1];
    
}

- (IBAction)doneButtonClicked:(id)sender
{
    self.time = [_timeFormat stringFromDate:self.timePicker.date];
    
    NSString *day = @"";
    NSString *from = @"";
    NSString *to = @"";
    
    if (_buttonClicked == _delegate.sun_to)
    {
        day = @"Sunday";
        to = _time;
        from = _delegate.sun_from.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.sun_from)
    {
        day = @"Sunday";
        from = _time;
        to = _delegate.sun_to.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.mon_to)
    {
        day = @"Monday";
        to = _time;
        from = _delegate.mon_from.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.mon_from)
    {
        day = @"Monday";
        from = _time;
        to = _delegate.mon_to.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.tue_to)
    {
        day = @"Tuesday";
        to = _time;
        from = _delegate.tue_from.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.tue_from)
    {
        day = @"Tuesday";
        from = _time;
        to = _delegate.tue_to.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.wed_to)
    {
        day = @"Wednesday";
        to = _time;
        from = _delegate.wed_from.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.wed_from)
    {
        day = @"Wednesday";
        from = _time;
        to = _delegate.wed_to.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.thu_to)
    {
        day = @"Thursday";
        to = _time;
        from = _delegate.thu_from.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.thu_from)
    {
        day = @"Thursday";
        from = _time;
        to = _delegate.thu_to.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.fri_to)
    {
        day = @"Friday";
        to = _time;
        from = _delegate.fri_from.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.fri_from)
    {
        day = @"Friday";
        from = _time;
        to = _delegate.fri_to.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.sat_to)
    {
        day = @"Saturday";
        to = _time;
        from = _delegate.sat_from.titleLabel.text;
    }
    else if (_buttonClicked == _delegate.sat_from)
    {
        day = @"Saturday";
        from = _time;
        to = _delegate.sat_to.titleLabel.text;
    }
    
    NSString *post = [NSString stringWithFormat:@"loc_id=1&day=%@&starttime=%@&endtime=%@", day, from, to];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_RESTAURANT_TIME_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    [postDataTask resume];

    [self.buttonClicked setTitle:self.time forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
