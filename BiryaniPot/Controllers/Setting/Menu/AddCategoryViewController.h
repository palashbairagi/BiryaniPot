//
//  AddCategoryViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "Constants.h"

@interface AddCategoryViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *uploadPhotoLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) MenuViewController *delegate;

@end
