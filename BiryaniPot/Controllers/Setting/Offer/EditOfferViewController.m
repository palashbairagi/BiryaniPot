//
//  EditOfferViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "EditOfferViewController.h"

@interface EditOfferViewController ()

@end

@implementation EditOfferViewController

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
    
    self.updateButton.layer.cornerRadius = 5;
    self.updateButton.layer.borderWidth = 1;
    self.updateButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 100, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.updateButton layer] addSublayer:gradient];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
}

- (IBAction)updateButtonClicked:(id)sender
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
@end
