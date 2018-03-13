//
//  AddCategoryViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCategoryViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *uploadPhotoLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
