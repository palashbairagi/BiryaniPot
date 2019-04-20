//
//  FeedbackDetailViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "FeedbackDetailViewController.h"
#import "Constants.h"
#import "Validation.h"

@interface FeedbackDetailViewController ()

@end

@implementation FeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_delegate.smiley == (id)[NSNull null])
    {
        self.feedbackIcon.text = @"-";
    }
    else if ([_delegate.smiley isEqualToString:@"Good"])
    {
        self.feedbackIcon.text = [NSString stringWithFormat:@"%C", 0xf118];
        [_feedbackIcon setTextColor:[UIColor greenColor]];
    }
    else if ([_delegate.smiley isEqualToString:@"Bad"])
    {
        self.feedbackIcon.text = [NSString stringWithFormat:@"%C", 0xf119];
        [_feedbackIcon setTextColor:[UIColor orangeColor]];
    }
    else
    {
        _feedbackIcon.text = @"-";
        [_feedbackIcon setTextColor:[UIColor blackColor]];
    }
    
    _feedbackDescription.text = @"";
    [_feedbackDescription setEditable:FALSE];
    
    _message.text = @"";
    
    _orderNumber.text = [NSString stringWithFormat:@"Order No %@", _delegate.orderNo];
    _customerName.text = [NSString stringWithFormat:@"TO    %@", _delegate.email];
    _orderDate.text = _delegate.orderDate;
    _subject.text = @"Sorry for Inconvenience";
    
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 100, 40);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.sendButton layer] addSublayer:gradient1];
    
   [self userFeedback];
    
}

-(void)userFeedback
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?order_id=%@", Constants.FEEDBACK_BY_USER_URL, _delegate.orderNo]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *userFeedback = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", userFeedback);
        
        _feedbackDescription.text = [userFeedback objectForKey:@"comments"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView dismiss:YES];
        });
        
    }@catch(NSException *e)
    {
        DebugLog(@"FeedbackDetailViewController [userFeedback]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

- (IBAction)sendButtonClicked:(id)sender {
    if([Validation isEmpty:_subject])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Subject Field should not be empty"];
        return;
    }
    else if ([[Validation trim:_message.text] length] == 0)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Message Field should not be empty"];
        return;
    }
    
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *email = _delegate.email;
        
        NSString *post = [NSString stringWithFormat:@"comments=%@&email=%@&subject=%@", _message.text, email ,_subject.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.FEEDBACK_REPLY_URL]];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error != NULL)
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Successful" andMessage:@"Email Sent"];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to send Email"];
                }
                [overlayView dismiss:YES];
            });
            
        }];
        
        [postDataTask resume];
    }
    @catch(NSException *e)
    {
        DebugLog(@"FeedbackDetailViewController [sendButtonClicked]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
