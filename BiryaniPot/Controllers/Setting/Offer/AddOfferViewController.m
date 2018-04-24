//
//  AddOfferViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/25/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "AddOfferViewController.h"
#import "Validation.h"
#import "Constants.h"
#import <SSMaterialCalendarPicker/NSDate+SSDateAdditions.h>

@interface AddOfferViewController ()

@end

@implementation AddOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
}

-(void)initComponents
{
    self.headerView.layer.borderWidth = 1;
    self.headerView.layer.cornerRadius = 3;
    self.headerView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.headerView.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];
    
    self.footerView.layer.borderWidth = 1;
    self.footerView.layer.cornerRadius = 3;
    self.footerView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.footerView.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];
    
    CGFloat borderWidth = 2;
    
    CALayer *borderN = [CALayer layer];
    borderN.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderN.frame = CGRectMake(0, self.offerName.frame.size.height - borderWidth, self.offerName.frame.size.width, self.offerName.frame.size.height);
    borderN.borderWidth = borderWidth;
    self.offerName.borderStyle = UITextBorderStyleNone;
    [self.offerName.layer addSublayer:borderN];
    self.offerName.layer.masksToBounds = YES;
    
    CALayer *borderV = [CALayer layer];
    borderV.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderV.frame = CGRectMake(0, self.offerValue.frame.size.height - borderWidth, self.offerValue.frame.size.width, self.offerValue.frame.size.height);
    borderV.borderWidth = borderWidth;
    self.offerValue.borderStyle = UITextBorderStyleNone;
    [self.offerValue.layer addSublayer:borderV];
    self.offerValue.layer.masksToBounds = YES;
    
    CALayer *borderMO = [CALayer layer];
    borderMO.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderMO.frame = CGRectMake(0, self.minimumOrder.frame.size.height - borderWidth, self.minimumOrder.frame.size.width, self.minimumOrder.frame.size.height);
    borderMO.borderWidth = borderWidth;
    self.minimumOrder.borderStyle = UITextBorderStyleNone;
    [self.minimumOrder.layer addSublayer:borderMO];
    self.minimumOrder.layer.masksToBounds = YES;
    
    CALayer *borderMD = [CALayer layer];
    borderMD.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderMD.frame = CGRectMake(0, self.maxDiscount.frame.size.height - borderWidth, self.maxDiscount.frame.size.width, self.maxDiscount.frame.size.height);
    borderMD.borderWidth = borderWidth;
    self.maxDiscount.borderStyle = UITextBorderStyleNone;
    [self.maxDiscount.layer addSublayer:borderMD];
    self.maxDiscount.layer.masksToBounds = YES;
    
    CALayer *borderLPC = [CALayer layer];
    borderLPC.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderLPC.frame = CGRectMake(0, self.limitPerCustomer.frame.size.height - borderWidth, self.limitPerCustomer.frame.size.width, self.limitPerCustomer.frame.size.height);
    borderLPC.borderWidth = borderWidth;
    self.limitPerCustomer.borderStyle = UITextBorderStyleNone;
    [self.limitPerCustomer.layer addSublayer:borderLPC];
    self.limitPerCustomer.layer.masksToBounds = YES;
    
    CALayer *borderMUL = [CALayer layer];
    borderMUL.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderMUL.frame = CGRectMake(0, self.maxUsageLimit.frame.size.height - borderWidth, self.maxUsageLimit.frame.size.width, self.maxUsageLimit.frame.size.height);
    borderMUL.borderWidth = borderWidth;
    self.maxUsageLimit.borderStyle = UITextBorderStyleNone;
    [self.maxUsageLimit.layer addSublayer:borderMUL];
    self.maxUsageLimit.layer.masksToBounds = YES;
    
    CALayer *borderD = [CALayer layer];
    borderD.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderD.frame = CGRectMake(0, self.offerDescription.frame.size.height - borderWidth, self.offerDescription.frame.size.width, self.offerDescription.frame.size.height);
    borderD.borderWidth = borderWidth;
    self.offerDescription.borderStyle = UITextBorderStyleNone;
    [self.offerDescription.layer addSublayer:borderD];
    self.offerDescription.layer.masksToBounds = YES;
    
    self.datePicker = _datePicker = [SSMaterialCalendarPicker initCalendarOn:self.view withDelegate:self];
    
    // Set a primary and a secondary color
    self.datePicker.primaryColor = [UIColor colorWithRed:0.87 green:0.39 blue:0.08 alpha:1];
    self.datePicker.secondaryColor = [UIColor colorWithRed:0.87 green:0.39 blue:0.08 alpha:1];

    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 100, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.saveButton layer] addSublayer:gradient];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (IBAction)saveButtonClicked:(id)sender
{
    if([self isValidate])
    {
        NSString *promoCode = [NSString stringWithFormat:@"%@", _offerName.text];
        NSString *offerDescription = [NSString stringWithFormat:@"%@", _offerDescription.text];
        NSString *validFrom = [Constants changeDateFormatForAPI:_fromButton.titleLabel.text];
        NSString *validTill = [Constants changeDateFormatForAPI:_toButton.titleLabel.text];
        NSString *minValue = [NSString stringWithFormat:@"%@", _minimumOrder.text];
        NSString *maxDiscount = [NSString stringWithFormat:@"%@", _maxDiscount.text];
        NSString *maxTimes = [NSString stringWithFormat:@"%@", _limitPerCustomer.text];
        NSString *usageLimit = [NSString stringWithFormat:@"%@", _maxUsageLimit.text];
        NSString *promoPercent = [NSString stringWithFormat:@"%@", _offerValue.text];
        NSString *imgURL = @"xyz.jpeg";
        
        
        NSString *post = [NSString stringWithFormat:@"codename=%@&code_description=%@&validfrom=%@&validtill=%@&minvalue=%@&maxdisc=%@&maxtimes=%@&usage_limit=%@&coupon_percent=%@&coupon_imgurl=%@&loc_id=%@", promoCode, offerDescription, validFrom, validTill, minValue, maxDiscount, maxTimes, usageLimit, promoPercent, imgURL, Constants.LOCATION_ID];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.INSERT_OFFER_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSString *boundary = @"-----Upload---Image-----";
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate.offerArray removeAllObjects];
                [_delegate getOffers];
                [_delegate.offerCollectionView reloadData];
            });
            
        }];
        [postDataTask resume];
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

-(void) imageUpload
{
    
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dateDuration:(id)sender
{
    [_datePicker showAnimated];
}

- (void)rangeSelectedWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd YYYY"];
    [self.fromButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:startDate]] forState:UIControlStateNormal];
    [self.toButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:endDate]] forState:UIControlStateNormal];
}

- (IBAction)uploadPhotoTapped:(id)sender
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)takePhotoClicked:(id)sender
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _offerImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _uploadPhotoLabel.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)isValidate
{
    [_offerName resignFirstResponder];
    [_offerValue resignFirstResponder];
    [_minimumOrder resignFirstResponder];
    [_offerDescription resignFirstResponder];
    
    if([Validation isEmpty:_offerName])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Promo Code Field should not be empty"];
        return false;
    }
    if([Validation isMore:_offerName thanMaxLength:20])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Promo Code Field should not exceed 20 characters"];
        return false;
    }
    
    if([Validation isEmpty:_offerValue])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Promo Value Field should not be empty"];
        return false;
    }
    if([Validation isMore:_offerValue thanMaxLength:2])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Promo Value Field should not exceed 99%"];
        return false;
    }
    
    if([Validation isEmpty:_offerDescription])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Description Field should not be empty"];
        return false;
    }
    if([Validation isMore:_offerDescription thanMaxLength:100])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Description Field should not exceed 100 characters"];
        return false;
    }
    
    if ([Validation isNumber:_minimumOrder])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Minimum Order Field should contain numbers only"];
    }
    if([Validation isMore:_minimumOrder thanMaxLength:3])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Minimum Order Field should not be more than 999"];
        return false;
    }
    
    if ([Validation isNumber:_maxDiscount])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Discount Field should contain numbers only"];
    }
    if([Validation isMore:_maxDiscount thanMaxLength:2])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Discount Field should not be more than 99"];
        return false;
    }
    
    if ([Validation isNumber:_limitPerCustomer])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Limit Per Customer Field should contain numbers only"];
    }
    if([Validation isMore:_limitPerCustomer thanMaxLength:4])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Limit Per Customer Field should not be more than 9999"];
        return false;
    }
    
    if ([Validation isNumber:_maxUsageLimit])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Usage Limit Field should contain numbers only"];
    }
    if([Validation isMore:_maxUsageLimit thanMaxLength:4])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Usage Limit Field should not be more than 9999"];
        return false;
    }
    
    if([_fromButton.titleLabel.text isEqualToString:@"Select"] || [_toButton.titleLabel.text isEqualToString:@"Select"])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Date range should not be empty"];
        return false;
    }
    
    return true;
}

@end
