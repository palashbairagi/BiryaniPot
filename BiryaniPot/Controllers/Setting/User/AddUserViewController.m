//
//  AddUserViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/24/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "AddUserViewController.h"
#import "Validation.h"

@interface AddUserViewController ()

@end

@implementation AddUserViewController

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
 
    self.profilePicture.layer.borderWidth = 1;
    self.profilePicture.layer.cornerRadius = 50;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];
    
    CGFloat borderWidth = 2;
    
    CALayer *borderFN = [CALayer layer];
    borderFN.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderFN.frame = CGRectMake(0, self.firstName.frame.size.height - borderWidth, self.firstName.frame.size.width, self.firstName.frame.size.height);
    borderFN.borderWidth = borderWidth;
    self.firstName.borderStyle = UITextBorderStyleNone;
    [self.firstName.layer addSublayer:borderFN];
    self.firstName.layer.masksToBounds = YES;
    
    CALayer *borderLN = [CALayer layer];
    borderLN.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderLN.frame = CGRectMake(0, self.lastName.frame.size.height - borderWidth, self.lastName.frame.size.width, self.lastName.frame.size.height);
    borderLN.borderWidth = borderWidth;
    self.lastName.borderStyle = UITextBorderStyleNone;
    [self.lastName.layer addSublayer:borderLN];
    self.lastName.layer.masksToBounds = YES;
    
    CALayer *borderR = [CALayer layer];
    borderR.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderR.frame = CGRectMake(0, self.role.frame.size.height - borderWidth, self.role.frame.size.width, self.role.frame.size.height);
    borderR.borderWidth = borderWidth;
    [self.role.layer addSublayer:borderR];
    self.role.layer.masksToBounds = YES;
    self.role.backgroundDimmingOpacity = 0.0;
    
    CALayer *borderM = [CALayer layer];
    borderM.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderM.frame = CGRectMake(0, self.mobile.frame.size.height - borderWidth, self.mobile.frame.size.width, self.mobile.frame.size.height);
    borderM.borderWidth = borderWidth;
    self.mobile.borderStyle = UITextBorderStyleNone;
    [self.mobile.layer addSublayer:borderM];
    self.mobile.layer.masksToBounds = YES;
    
    CALayer *borderP = [CALayer layer];
    borderP.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderP.frame = CGRectMake(0, self.licenceNo.frame.size.height - borderWidth, self.licenceNo.frame.size.width, self.licenceNo.frame.size.height);
    borderP.borderWidth = borderWidth;
    self.licenceNo.borderStyle = UITextBorderStyleNone;
    [self.licenceNo.layer addSublayer:borderP];
    self.licenceNo.layer.masksToBounds = YES;
    
    CALayer *borderEM = [CALayer layer];
    borderEM.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderEM.frame = CGRectMake(0, self.email.frame.size.height - borderWidth, self.lastName.frame.size.width, self.email.frame.size.height);
    borderEM.borderWidth = borderWidth;
    self.email.borderStyle = UITextBorderStyleNone;
    [self.email.layer addSublayer:borderEM];
    self.email.layer.masksToBounds = YES;
    
    CALayer *borderPass = [CALayer layer];
    borderPass.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderPass.frame = CGRectMake(0, self.password.frame.size.height - borderWidth, self.password.frame.size.width, self.password.frame.size.height);
    borderPass.borderWidth = borderWidth;
    self.password.borderStyle = UITextBorderStyleNone;
    [self.password.layer addSublayer:borderPass];
    self.password.layer.masksToBounds = YES;
    
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
    
    _roleArray = [NSArray arrayWithObjects:@"Partner", @"Manager", @"Receptionist" ,@"Delivery Person", nil ];
    
}

- (IBAction)profilePictureTapped:(id)sender
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _profilePicture.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
   
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    PHAsset *phAsset = [[PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil] lastObject];
    NSString *imageName = [phAsset valueForKey:@"filename"];
    
    _extension = [imageName pathExtension];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}

-(NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return _roleArray.count;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [[NSAttributedString alloc] initWithString:_roleArray[row] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *selectedOption = self.roleArray[row];
    self.roleLabel.text = selectedOption;
    
    if ([selectedOption isEqualToString:@"Delivery Person"])
    {
        [_passwordLabel setHidden:YES];
        [_password setHidden:YES];
        [_licenceNo setHidden:NO];
        [_licenceNoLabel setHidden:NO];
    }
    else
    {
        [_licenceNo setHidden:YES];
        [_licenceNoLabel setHidden:YES];
        [_passwordLabel setHidden:NO];
        [_password setHidden:NO];
    }
    
    [dropdownMenu closeAllComponentsAnimated:YES];
}

- (IBAction)saveButtonClicked:(id)sender
{
    if(([self isValidate]))
    {
        if ([_roleLabel.text isEqualToString:@"Delivery Person"])
        {
            [self saveDeliveryPerson];
        } else
        {
            [self saveManager];
        }
    }
}

-(void)saveDeliveryPerson
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *name = [NSString stringWithFormat:@"%@ %@", [Validation trim:_firstName.text], [Validation trim:_lastName.text]];
        NSString *mobile = [NSString stringWithFormat:@"%@", [Validation trim:_mobile.text]];
        NSString *email = [NSString stringWithFormat:@"%@", [Validation trim:_email.text]];
        NSString *license = [NSString stringWithFormat:@"%@", [Validation trim:_licenceNo.text]];
        
        if(_extension == NULL) _extension = @"jpg";
        else if(!([_extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame))
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Picture must be in the jpg format"];
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.INSERT_DELIVERY_PERSON_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSMutableData *body = [NSMutableData data];
        
        NSDictionary *params = @{
                                     @"dboyname" : name,
                                     @"dboy_email" : email,
                                     @"dboymobile" : mobile,
                                     @"loc_id"   : Constants.LOCATION_ID,
                                     @"licensenumber"  : license
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
        
        NSData *imageData = UIImageJPEGRepresentation(_profilePicture.image, 1.0);
        NSString *fieldName = @"file";
        NSString *mimetype  = [NSString stringWithFormat:@"image/jpg"];
        NSString *imgName = [NSString stringWithFormat:@"%@.jpg",name];
        
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
                [_delegate getManagers];
                [_delegate getDeliveryPersons];
                [_delegate.userTableView reloadData];
                
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
    }
    @catch(NSException *e)
    {
        DebugLog(@"AddUserViewController [saveDeliveryPerson]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)saveManager
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSString *name = [NSString stringWithFormat:@"%@ %@", [Validation trim:_firstName.text], [Validation trim:_lastName.text]];
        NSString *mobile = [NSString stringWithFormat:@"%@", [Validation trim:_mobile.text]];
        NSString *email = [NSString stringWithFormat:@"%@", [Validation trim:_email.text]];
        NSString *role = [NSString stringWithFormat:@"%@", [Validation trim:_roleLabel.text]];
        NSString *password = [NSString stringWithFormat:@"%@", [Validation trim:_password.text]];
        NSString *superUser = @"4";//[_appDelegate.userDefaults objectForKey:@"userId"];
        
        if ([role isEqualToString:@"Manager"]) role = @"3";
        else if([role isEqualToString:@"Receptionist"]) role = @"2";
        else role = @"175";
        
        if(_extension == NULL) _extension = @"jpg";
        else if(!([_extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame))
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Picture must be in the jpg format"];
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.INSERT_MANAGER_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSMutableData *body = [NSMutableData data];
        
        NSDictionary *params = @{
                                     @"managername" : name,
                                     @"email" : email,
                                     @"mobile" : mobile,
                                     @"managerpassword" : password,
                                     @"superuser"  : superUser,
                                     @"locationid"   : Constants.LOCATION_ID,
                                     @"role"  : role
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
        
        NSData *imageData = UIImageJPEGRepresentation(_profilePicture.image, 1.0);
        NSString *fieldName = @"file";
        NSString *mimetype  = [NSString stringWithFormat:@"image/jpg"];
        NSString *imgName = [NSString stringWithFormat:@"%@.jpg",name];
        
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
                [_delegate getManagers];
                [_delegate getDeliveryPersons];
                [_delegate.userTableView reloadData];
                
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
    }
    @catch(NSException *e)
    {
        DebugLog(@"UserManagementViewController [saveManager]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(BOOL)isValidate
{
    [_firstName resignFirstResponder];
    [_lastName resignFirstResponder];
    [_mobile resignFirstResponder];
    [_email resignFirstResponder];
    
    if ([Validation isEmpty:_firstName])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"First Name Field should not be empty"];
        return false;
    }
    if ([Validation isMore:_firstName thanMaxLength:25])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"First Name Field should not be more than 25 characters"];
        return false;
    }
    
    if ([Validation isEmpty:_lastName])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Last Name Field should not be empty"];
        return false;
    }
    if ([Validation isMore:_lastName thanMaxLength:25])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Last Name Field should not be more than 25 characters"];
        return false;
    }
    
    if ([_roleLabel.text isEqualToString:@"Select"])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Role Field should not be empty"];
        return false;
    }
    
    if([Validation isEmpty:_mobile])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Mobile Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_mobile thanMinLength:10] || [Validation isMore:_mobile thanMaxLength:10])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Mobile Field should exactly equals to 10 digits"];
        return false;
    }
    if ([Validation isNumber:_mobile])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Mobile Field should contain numeric value"];
        return false;
    }
    
    if([Validation isEmpty:_email])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Email Field should not be empty"];
        return false;
    }
    if ([Validation isLess:_email thanMinLength:10])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Email Field should not be less than 10 characters"];
        return false;
    }
    if ([Validation isMore:_email thanMaxLength:50])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Email Field should not exceed 50 characters"];
        return false;
    }
    if ([Validation isEmail:_email])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Invalid Email"];
        return false;
    }
    
    if ([_roleLabel.text isEqualToString:@"Delivery Person"])
    {
        [_licenceNo resignFirstResponder];
        
        if ([Validation isEmpty:_licenceNo])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Licence No Field should not be empty"];
            return false;
        }
    }
    else
    {
        [_password resignFirstResponder];
        
        if ([Validation isEmpty:_password])
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Password Field should not be empty"];
            return false;
        }
    }
    
    return true;
}

@end
