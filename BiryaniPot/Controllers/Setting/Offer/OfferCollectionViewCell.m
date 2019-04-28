//
//  OfferCollectionViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "OfferCollectionViewCell.h"
#import "EditOfferViewController.h"

@implementation OfferCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_editButton setTitle:[NSString stringWithFormat:@"%C", 0xf040] forState:UIControlStateNormal];
    [_editButton setTitle:[NSString stringWithFormat:@"%C", 0xf040] forState:UIControlStateHighlighted];
    [_deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateNormal];
    [_deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateHighlighted];
}

- (IBAction)editButtonClicked:(UIButton *)sender
{
    EditOfferViewController * editOfferViewController = [[EditOfferViewController alloc]init];
    editOfferViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    editOfferViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    editOfferViewController.preferredContentSize = CGSizeMake(1000, 566);
    editOfferViewController.delegate = _delegate;
    editOfferViewController.offer = _delegate.offerArray[_editButton.tag];
    
    [self.delegate presentViewController:editOfferViewController animated:YES completion:nil];
}

- (void) delete: (Offer *) offer
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.delegate.view animated:YES];
    
    @try
    {
        
        for (NSIndexPath *indexPath in self.delegate.offerCollectionView.indexPathsForSelectedItems)
        {
            [self.delegate.offerCollectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        
        NSString *promoCode = offer.name;
        NSString *offerDescription = offer.description;
        NSString *validFrom = offer.startFrom;
        NSString *validTill = offer.endAt;
        NSString *minValue = offer.minValue;
        NSString *maxDiscount = offer.maxDisc;
        NSString *maxTimes = offer.maxTimes;
        NSString *usageLimit = offer.maxUsageLimit;
        NSString *imgName = offer.imageURL;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_OFFER_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSMutableData *body = [NSMutableData data];
        
        NSDictionary *params = @{@"code_id" : offer.offerId,
                                 @"codename" : promoCode,
                                 @"code_description" : offerDescription,
                                 @"validfrom" : validFrom,
                                 @"validtill" : validTill,
                                 @"minvalue"  : minValue,
                                 @"maxdisc"   : maxDiscount,
                                 @"maxtimes"  : maxTimes,
                                 @"usage_limit" : usageLimit,
                                 @"is_active"  : @"0",
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
        
        NSData *imageData = UIImageJPEGRepresentation(self.offerImage.image, 1.0);
        NSString *fieldName = @"coupon_image";
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, imgName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate getOffers];
                [_delegate.offerCollectionView reloadData];
                [overlayView dismiss:YES];
            });
            
        }];
        
        [task resume];
    }@catch(NSException *e)
    {
        DebugLog(@"OfferCollectionViewCell [deleteButtonClicked]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    
}

-(void) alert: (Offer *) offer
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self delete: offer];
        });
        
    }];
    
    [alertController addAction:yes];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:no];
    
    [_delegate presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)deleteButtonClicked:(UIButton *)sender
{
    Offer *offer = _delegate.offerArray[_deleteButton.tag];
    
    [self alert:offer];
}


@end
