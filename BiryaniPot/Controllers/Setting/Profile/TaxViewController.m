//
//  TaxViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 5/19/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "TaxViewController.h"

@interface TaxViewController ()

@end

@implementation TaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CGFloat borderWidth = 2;
   
    CALayer *borderN = [CALayer layer];
    borderN.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderN.frame = CGRectMake(0, self.taxNameTextField.frame.size.height - borderWidth, self.taxNameTextField.frame.size.width, self.taxNameTextField.frame.size.height);
    borderN.borderWidth = borderWidth;
    self.taxNameTextField.borderStyle = UITextBorderStyleNone;
    [self.taxNameTextField.layer addSublayer:borderN];
    self.taxNameTextField.layer.masksToBounds = YES;
    
    CALayer *border = [CALayer layer];
    border.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    border.frame = CGRectMake(0, self.taxTextField.frame.size.height - borderWidth, self.taxTextField.frame.size.width, self.taxTextField.frame.size.height);
    border.borderWidth = borderWidth;
    self.taxTextField.borderStyle = UITextBorderStyleNone;
    [self.taxTextField.layer addSublayer:border];
    self.taxTextField.layer.masksToBounds = YES;
    
    CALayer *borderV = [CALayer layer];
    borderV.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderV.frame = CGRectMake(0, self.deliveryTextField.frame.size.height - borderWidth, self.deliveryTextField.frame.size.width, self.deliveryTextField.frame.size.height);
    borderV.borderWidth = borderWidth;
    self.deliveryTextField.borderStyle = UITextBorderStyleNone;
    [self.deliveryTextField.layer addSublayer:borderV];
    self.deliveryTextField.layer.masksToBounds = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 100, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.saveButton layer] addSublayer:gradient];
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self getTaxAndDeliveryFee];
}

-(void)getTaxAndDeliveryFee
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?locationid=%@",Constants.GET_TAX_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    _deliveryTextField.text = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"deliveryFee"]];
    _taxNameTextField.text = [[resultDic objectForKey:@"tax"] objectForKey:@"taxName"];
    _taxTextField.text = [NSString stringWithFormat:@"%@", [[resultDic objectForKey:@"tax"] objectForKey:@"taxPercent"]];
}

-(void)updateTaxAndDelivery
{
    NSString *post = [NSString stringWithFormat:@"locationid=%@&taxpercent=%@&taxname=%@&deliveryfee=%@", Constants.LOCATION_ID, _taxTextField.text, _taxNameTextField.text, _deliveryTextField.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_TAX_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSLog(@"%@ %@", response, resultDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[resultDic objectForKey:@"status"] intValue] == 1)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to update"];
            }
        });
        
    }];
    [postDataTask resume];
    
    
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:self completion:nil];
}

- (IBAction)saveButtonClicked:(id)sender
{
    [self updateTaxAndDelivery];
}


@end
