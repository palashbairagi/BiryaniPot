//
//  AddOfferViewController.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/25/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "AddOfferViewController.h"
#import "Validation.h"
#import "Constants.h"
#import "CalendarViewController.h"
#import <Photos/Photos.h>

@interface AddOfferViewController ()

@end

@implementation AddOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
}

-(void) saveRecord
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
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
        NSString *isPercent = [NSString stringWithFormat:@"%i", _isPercent];
        
        if(_extension == NULL) _extension = @"jpg";
        else if(!([_extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame))
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Promo Picture must be in the jpg format"];
        }
        
        NSString *imgName = [NSString stringWithFormat:@"%@.%@", promoCode, _extension];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.INSERT_OFFER_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSMutableData *body = [NSMutableData data];
        
        NSDictionary *params = @{@"codename" : promoCode,
                                 @"code_description" : offerDescription,
                                 @"validfrom" : validFrom,
                                 @"validtill" : validTill,
                                 @"minvalue"  : minValue,
                                 @"maxdisc"   : maxDiscount,
                                 @"maxtimes"  : maxTimes,
                                 @"usage_limit" : usageLimit,
                                 @"coupon_percent" : promoPercent,
                                 @"is_percent"  : isPercent,
                                 @"loc_id"    : Constants.LOCATION_ID
                                 };
        
        NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:contentType forHTTPHeaderField:@"content-Type"];
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
        
        NSData *imageData = UIImageJPEGRepresentation(_offerImageView.image, 1.0);
        NSString *fieldName = @"coupon_image";
        NSString *mimetype  = [NSString stringWithFormat:@"image/%@", _extension];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, imgName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        request.HTTPBody = body;
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:task];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate.offerArray removeAllObjects];
                [_delegate getOffers];
                [_delegate.offerCollectionView reloadData];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:result preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                    [self dismissViewControllerAnimated:NO completion:nil];
                }];
                
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:^{
                    [overlayView dismiss:YES];
                }];
            });
        }];
        
        [task resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"AddOfferViewController [saveRecord]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
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
    
    [_fromButton setTitle:[Constants GET_TODAY_DATE] forState:UIControlStateNormal];
    [_toButton setTitle:[Constants GET_FIFTEEN_DAYS_FROM_NOW_DATE] forState:UIControlStateNormal];
    
    [_isPercentButton setTitle:[NSString stringWithFormat:@"%C", 0xf00c] forState:UIControlStateNormal];
    
    _isPercentButton.backgroundColor = [UIColor whiteColor];
    _isPercent = FALSE;
    
}

- (IBAction)saveButtonClicked:(id)sender
{
    if([self isValidate])
    {
        [self saveRecord];
    }
    
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dateDuration:(id)sender
{
    CalendarViewController * calendarVC = [[CalendarViewController alloc]init];
    calendarVC.modalPresentationStyle = UIModalPresentationFormSheet;
    calendarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    calendarVC.preferredContentSize = CGSizeMake(400, 450);
    calendarVC.toDateDelegate = _toButton;
    calendarVC.fromDateDelegate = _fromButton;
    calendarVC.disablePastDates = TRUE;
    [self presentViewController:calendarVC animated:YES completion:nil];
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
   
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    PHAsset *phAsset = [[PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil] lastObject];
    NSString *imageName = [phAsset valueForKey:@"filename"];
    
    _extension = [imageName pathExtension];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)isPercentButtonClicked:(id)sender
{
    if (!_isPercent)
    {
        _isPercentButton.backgroundColor = [UIColor colorWithRed:0.0 green:100.0/256 blue:1.0 alpha:1.0];
        _isPercent = TRUE;
        
    }
    else
    {
        _isPercentButton.backgroundColor = [UIColor whiteColor];
        _isPercent = FALSE;
    }
}

-(BOOL)isValidate
{
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
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Promo Value Field should not exceed 2 digits"];
        return false;
    }
    if ([Validation isNumber:_offerValue])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Promo Value Field should be a number"];
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
    
    if ([Validation isEmpty:_minimumOrder])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Minimum Order Field should not be empty"];
        return false;
    }
    if ([Validation isNumber:_minimumOrder])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Minimum Order Field should contain numbers only"];
        return false;
    }
    if([Validation isMore:_minimumOrder thanMaxLength:3])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Minimum Order Field should not be more than 999"];
        return false;
    }
    
    if ([Validation isEmpty:_maxDiscount])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Discount Field should not be empty"];
        return false;
    }
    if ([Validation isNumber:_maxDiscount])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Discount Field should contain numbers only"];
        return false;
    }
    if([Validation isMore:_maxDiscount thanMaxLength:2])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Discount Field should not be more than 99"];
        return false;
    }
    
    if ([Validation isEmpty:_limitPerCustomer])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Limit Per Customer Field should not be empty"];
        return false;
    }
    if ([Validation isNumber:_limitPerCustomer])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Limit Per Customer Field should contain numbers only"];
        return false;
    }
    if([Validation isMore:_limitPerCustomer thanMaxLength:4])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Limit Per Customer Field should not be more than 9999"];
        return false;
    }
    
    if ([Validation isEmpty:_maxUsageLimit])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Usage Limit Field should not be empty"];
        return false;
    }
    if ([Validation isNumber:_maxUsageLimit])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Maximum Usage Limit Field should contain numbers only"];
        return false;
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
    
    if(_offerImageView.image == nil)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"No Image"];
        return false;
    }
    
    return true;
}

@end
