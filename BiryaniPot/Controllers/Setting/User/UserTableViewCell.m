//
//  UserTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf1f8] forState:UIControlStateNormal];
    
    [_deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf1f8] forState:UIControlStateHighlighted];
    _profilePictureQueue = [[NSOperationQueue alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellData:(User *)user withSelectedIndex:(NSInteger)selectedIndex
{
    _name.text = user.name;
    _role.text = user.role;
    _mobile.text = user.mobile;
    _licenceNo.text = user.licenseNumber;
    _email.text = user.email;
    _deleteButton.titleLabel.text = [NSString stringWithFormat:@"%C", 0xf1f8];
    
    if (user.profilePicture == nil )
    {
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            UIImage * image = [UIImage imageNamed:@"dp"];
            NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profilePictureURL]];
            
            if (imgData != NULL)
            {
                image = [UIImage imageWithData:imgData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_profilePicture setImage:image];
            });
            
        }];
        
        [_profilePictureQueue addOperation:op];
    }
    else
    {
        _profilePicture.image = user.profilePicture;
    }
}

- (IBAction)deleteButtonClicked:(UIButton *)sender
{
    User *user = _delegate.userArray[sender.tag];
    
    if ([user.role isEqualToString:@"Delivery Person"])
    {
        [self deleteDeliveryPerson:user];
    }
    else if([user.role isEqualToString:@"Manager"] || [user.role isEqualToString:@"Partner"] || [user.role isEqualToString:@"Receptionist"])
    {
        [self deleteManager:user];
    }
    else
    {
        [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Alert" andMessage:@"Unable to Delete"];
    }
}

-(void)deleteDeliveryPerson:(User *)user
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.delegate.view animated:YES];
    
    @try
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.DELETE_DELIVERY_PERSON_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSMutableData *body = [NSMutableData data];
        
        NSDictionary *params = @{
                                     @"dboy_id" : user.userId,
                                     @"dboy_name" : user.name,
                                     @"email" : user.email,
                                     @"mobile" : user.mobile,
                                     @"loc_id"   : Constants.LOCATION_ID,
                                     @"is_active"  : @"0"
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
        
//        NSData *imageData = UIImageJPEGRepresentation(_profilePicture.image, 1.0);
//        NSString *fieldName = @"file";
//        NSString *mimetype  = [NSString stringWithFormat:@"image/jpg"];
//        NSString *imgName = [NSString stringWithFormat:@"%@.jpg",name];
//
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, imgName] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:imageData];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        request.HTTPBody = body;
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            DebugLog(@"%@ %@", result, response);
            
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate getManagers];
                [_delegate getDeliveryPersons];
                [_delegate.userTableView reloadData];
                
                [overlayView dismiss:YES];
            });
        }];
        [task resume];
    }
    @catch(NSException *e)
    {
        DebugLog(@"UserTableViewCell [deleteDeliveryPerson]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)deleteManager:(User *)user
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.delegate.view animated:YES];
    
    @try
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?username=%@&loc_id=%@", Constants.DELETE_MANAGER_URL, user.email ,Constants.LOCATION_ID]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPMethod:@"POST"];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", result);
            
            NSDictionary *status = [result objectForKey:@"status"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([status isEqual:[NSNumber numberWithInt:1]])
                {
                    [_delegate getManagers];
                    [_delegate getDeliveryPersons];
                    [_delegate.userTableView reloadData];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Error" andMessage:@"Unable to delete"];
                }
                
                [overlayView dismiss:YES];
            });

        }];
        
        [postDataTask resume];
    }
    @catch(NSException *e)
    {
        DebugLog(@"UserTableViewCell [deleteManager]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

@end
