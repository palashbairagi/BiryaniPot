//
//  AddCategoryViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "Validation.h"

@interface AddCategoryViewController ()

@end

@implementation AddCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *borderL1 = [CALayer layer];
    borderL1.borderColor = [[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] CGColor];;
    borderL1.frame = CGRectMake(0, self.name.frame.size.height - 2, self.name.frame.size.width, self.name.frame.size.height);
    borderL1.borderWidth = 2;
    self.name.borderStyle = UITextBorderStyleNone;
    [self.name.layer addSublayer:borderL1];
    self.name.layer.masksToBounds = YES;
    
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 100, 40);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.saveButton layer] addSublayer:gradient1];

    [_nonVegButton setTitle:[NSString stringWithFormat:@"%C", 0xf00c] forState:UIControlStateNormal];
    _nonVegButton.backgroundColor = [UIColor whiteColor];
    _isNonVeg = false;
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonClicked:(id)sender
{
    NSString *categoryName = _name.text;
    NSString *nonVegSupport = [NSString stringWithFormat:@"%d", _isNonVeg];
    
    if(_extension == NULL) _extension = @"jpg";
    else if(!([_extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame))
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Picture must be in the jpg format"];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.INSERT_CATEGORY_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSMutableData *body = [NSMutableData data];
    
    NSDictionary *params = @{
                             @"category_name" : categoryName,
                             @"menu_id" : Constants.MENU_ID,
                             @"is_nonveg_supported" : nonVegSupport
                             };
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:contentType forHTTPHeaderField:@"content-Type"];
    
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    NSData *imageData = UIImageJPEGRepresentation(_image.image, 1.0);
    NSString *fieldName = @"file";
    NSString *mimetype  = [NSString stringWithFormat:@"image/jpg"];
    NSString *imgName = [NSString stringWithFormat:@"%@.jpg",categoryName];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, imgName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = body;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
            return;
        }
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate getCategory];
            [_delegate.menuCollectionView reloadData];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:result preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [alertController dismissViewControllerAnimated:YES completion:nil];
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    }];
    [task resume];
}

- (IBAction)uploadPhotoTapped:(id)sender
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)takePhotoButtonClicked:(id)sender
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
    _image.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    PHAsset *phAsset = [[PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil] lastObject];
    NSString *imageName = [phAsset valueForKey:@"filename"];
    
    _extension = [imageName pathExtension];
    
    _uploadPhotoLabel.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nonVegButtonClicked:(id)sender
{
    if(_isNonVeg)
    {
        _nonVegButton.backgroundColor = [UIColor whiteColor];
        _isNonVeg = FALSE;
    }
    else
    {
        _nonVegButton.backgroundColor = [UIColor colorWithRed:0.0 green:100.0/256 blue:1.0 alpha:1.0];
        _isNonVeg = TRUE;
    }
}


-(BOOL)isValidate
{
    if([Validation isEmpty:_name])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Name  Field should not be empty"];
        return false;
    }
    if([Validation isMore:_name thanMaxLength:25])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Name Field should not exceed 25 characters"];
        return false;
    }
    
    return true;
}

@end
