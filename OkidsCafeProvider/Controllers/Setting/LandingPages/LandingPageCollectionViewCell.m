//
//  LandingPageCollectionViewCell.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 3/18/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "LandingPageCollectionViewCell.h"

@implementation LandingPageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapped:)];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
    [_image addGestureRecognizer:_tapGestureRecognizer];
    
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    [_pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)imageTapped:(id)sender
{
    [self.delegate presentViewController:_pickerController animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    PHAsset *phAsset = [[PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil] lastObject];
    NSString *imageName = [phAsset valueForKey:@"filename"];
    
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
    
    if ([[imageName pathExtension] caseInsensitiveCompare:@"jpg"] == NSOrderedSame)
    {
        _image.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self updateImage];
    }
    else
    {
        [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Error" andMessage:@"Please select JPG Image"];
    }
}

-(void) updateImage
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.delegate.view animated:YES];
    
    @try
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSString *organizationid = Constants.ORGANIZATION_ID;
        NSString *isactive = @"1";
        NSString *filename = [NSString stringWithFormat:@"%ld", _image.tag+1];
        NSString *imgName = filename;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_LANDING_IMAGE]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSMutableData *body = [NSMutableData data];
        
        NSDictionary *params = @{
                                     @"organizationid" : organizationid,
                                     @"isactive" : isactive,
                                     @"imageid" : imgName,
                                     @"filename" : filename
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
        
        NSData *imageData = UIImageJPEGRepresentation(_image.image, 1.0);
        NSString *fieldName = @"landingimage";
        NSString *mimetype  = [NSString stringWithFormat:@"image/jpg"];
        
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
                [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Alert" andMessage:result];
                [_delegate getImages];
                [_delegate.landingPageCollectionView reloadData];
                 [overlayView dismiss:YES];
            });
            
        }];
        [task resume];
    }@catch(NSException *e)
    {
        DebugLog(@"LandingPageCollectionCell [updateImage]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

@end
