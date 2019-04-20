//
//  AddUserViewController.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/24/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDropDownMenu.h"
#import "Constants.h"
#import "UserManagementViewController.h"
#import "AppDelegate.h"
#import <Photos/Photos.h>

@interface AddUserViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate, NSURLSessionDelegate>

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, retain) UserManagementViewController *delegate;

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *role;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *licenceNo;
@property (weak, nonatomic) IBOutlet UILabel *licenceNoLabel;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, retain) NSString *extension;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) NSArray * roleArray;

@property (nonatomic, retain) NSOperationQueue *profilePictureQueue ;

@end
