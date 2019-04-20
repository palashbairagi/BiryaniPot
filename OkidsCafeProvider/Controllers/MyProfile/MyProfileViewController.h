//
//  MyProfileViewController.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/26/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import <Photos/Photos.h>

@interface MyProfileViewController : BaseViewController <NSURLSessionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) User *user;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *role;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (nonatomic, retain) NSString *checkButtonStatus;
@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, retain) NSString *extension;

@property (nonatomic, retain) NSOperationQueue *profilePictureQueue ;

@end
