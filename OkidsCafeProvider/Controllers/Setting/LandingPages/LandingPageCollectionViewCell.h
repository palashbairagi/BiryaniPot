//
//  LandingPageCollectionViewCell.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 3/18/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandingPagesViewController.h"
#import "AppDelegate.h"
#import <Photos/Photos.h>

@interface LandingPageCollectionViewCell : UICollectionViewCell <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) LandingPagesViewController *delegate;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, retain) UIImagePickerController *pickerController;
@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain) AppDelegate *appDelegate;
@end
