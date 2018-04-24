//
//  AddOfferViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/25/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSMaterialCalendarPicker.h"
#import "OfferViewController.h"

@interface AddOfferViewController : UIViewController <SSMaterialCalendarPickerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, NSURLSessionDelegate>

@property OfferViewController *delegate;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UITextField *offerName;
@property (weak, nonatomic) IBOutlet UITextField *offerValue;
@property (weak, nonatomic) IBOutlet UITextField *offerDescription;
@property (weak, nonatomic) IBOutlet UITextField *minimumOrder;
@property (weak, nonatomic) IBOutlet UITextField *maxDiscount;
@property (weak, nonatomic) IBOutlet UITextField *limitPerCustomer;
@property (weak, nonatomic) IBOutlet UITextField *maxUsageLimit;


@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *uploadPhotoLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) SSMaterialCalendarPicker *datePicker;
@end
