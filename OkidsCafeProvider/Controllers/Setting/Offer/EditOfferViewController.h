//
//  EditOfferViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "OfferViewController.h"
#import "Offer.h"
#import <Photos/Photos.h>

@interface EditOfferViewController : UIViewController
<UINavigationControllerDelegate,UIImagePickerControllerDelegate, NSURLSessionDelegate>

@property OfferViewController *delegate;

@property (nonatomic, retain) NSOperationQueue *offerQueue ;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UITextField *offerName;
@property (weak, nonatomic) IBOutlet UITextField *offerValue;
@property (weak, nonatomic) IBOutlet UITextField *offerDescription;
@property (weak, nonatomic) IBOutlet UITextField *minimumOrder;
@property (weak, nonatomic) IBOutlet UITextField *maxDiscount;
@property (weak, nonatomic) IBOutlet UITextField *limitPerCustomer;
@property (weak, nonatomic) IBOutlet UITextField *maxUsageLimit;
@property (weak, nonatomic) IBOutlet UIButton *isPercentButton;
@property (nonatomic, retain) NSString *extension;

@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *uploadPhotoLabel;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) Offer *offer;
 
@end
