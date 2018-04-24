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

}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonClicked:(id)sender
{
    if([self isValidate])
    {
        NSString *imgURL = @"xyz.jpeg";
        NSString *categoryName = _name.text;
        
        NSString *post = [NSString stringWithFormat:@"category_name=%@&img_url=%@&menu_id=1&is_nonveg_supported=0", categoryName, imgURL];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.INSERT_CATEGORY_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"PUT"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate.categoryArray removeAllObjects];
                [_delegate getCategory];
                [_delegate.menuCollectionView reloadData];
            });
            
        }];
        [postDataTask resume];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    _uploadPhotoLabel.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
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
