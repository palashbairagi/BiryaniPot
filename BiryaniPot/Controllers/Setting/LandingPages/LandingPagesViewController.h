//
//  LandingPagesViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LandingPagesViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (nonatomic, retain) UIImagePickerController *pickerController1;
@property (nonatomic, retain) UIImagePickerController *pickerController2;
@property (nonatomic, retain) UIImagePickerController *pickerController3;

@end
