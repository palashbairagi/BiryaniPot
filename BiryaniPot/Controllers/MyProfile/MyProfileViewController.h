//
//  MyProfileViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/26/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyProfileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *role;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (nonatomic, retain) NSString *checkButtonStatus;
@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
